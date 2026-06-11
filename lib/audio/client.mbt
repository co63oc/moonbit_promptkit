///|
/// Audio understanding API for Qwen3-Omni-Captioner
/// Uses OpenAI-compatible `input_audio` format
///

///|
/// Caption audio using Qwen3-Omni-Captioner
pub async fn caption_audio(
  config : @lib.ClientConfig,
  audio_url : String,
) -> String {
  caption_audio_impl(config, audio_url, default_model)
}

///|
/// Caption audio with specific model
pub async fn caption_audio_with_model(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
) -> String {
  caption_audio_impl(config, audio_url, model)
}

///|
/// Message structure for audio requests
struct AudioMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
/// Internal: build request and call API
async fn caption_audio_impl(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
) -> String {
  // Build audio content
  let audio_json = audio_content(audio_url).to_json()

  // Audio goes in a user message
  let audio_message = AudioMessage::{ role: "user", content: [audio_json] }
  let messages : Array[Json] = [audio_message.to_json()]

  // Build request
  let request = AudioRequest::{
    model,
    messages,
    stream: None,
    stream_options: None,
  }

  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Audio caption request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No audio caption generated")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///|
/// TTS (Text-to-Speech) APIs

///|
/// Synthesize speech using CosyVoice (SpeechSynthesizer API)
/// Returns audio URL (valid for 24 hours)
pub async fn cosyvoice_tts(config : @lib.ClientConfig, text : String) -> String {
  cosyvoice_tts_impl(
    config,
    text,
    default_cosyvoice_model,
    default_cosyvoice_voice,
    None,
    None,
    None,
  )
}

///|
/// Synthesize speech using CosyVoice with specific voice
pub async fn cosyvoice_tts_with_voice(
  config : @lib.ClientConfig,
  text : String,
  voice : String,
) -> String {
  cosyvoice_tts_impl(
    config,
    text,
    default_cosyvoice_model,
    voice,
    None,
    None,
    None,
  )
}

///|
/// Synthesize speech using CosyVoice with full options
pub async fn cosyvoice_tts_with_options(
  config : @lib.ClientConfig,
  text : String,
  model? : String,
  voice? : String,
  format? : String,
  sample_rate? : Int,
  instruction? : String,
) -> String {
  cosyvoice_tts_impl(
    config,
    text,
    model.unwrap_or(default_cosyvoice_model),
    voice.unwrap_or(default_cosyvoice_voice),
    format,
    sample_rate,
    instruction,
  )
}

///|
/// Internal: CosyVoice TTS implementation
async fn cosyvoice_tts_impl(
  config : @lib.ClientConfig,
  text : String,
  model : String,
  voice : String,
  format : String?,
  sample_rate : Int?,
  instruction : String?,
) -> String {
  let input = TtsInput::{
    text,
    voice: Some(voice),
    format,
    sample_rate,
    language_type: None,
    instruction,
    enable_ssml: None,
    word_timestamp_enabled: None,
  }
  let request = TtsRequest::{ model, input }

  let url = "\{config.base_url}/services/audio/tts/SpeechSynthesizer"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "CosyVoice TTS request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : TtsResponse = body.json() |> @json.from_json()
  match resp.output.audio {
    Some(audio) =>
      match audio.url {
        Some(u) => u
        None => fail("No audio URL in response")
      }
    None => fail("No audio output in response")
  }
}

///|
/// Synthesize speech using Qwen-TTS (multimodal-generation API)
/// Returns audio URL (valid for 24 hours)
pub async fn qwen_tts(config : @lib.ClientConfig, text : String) -> String {
  qwen_tts_impl(
    config,
    text,
    default_qwen_tts_model,
    default_qwen_tts_voice,
    None,
  )
}

///|
/// Synthesize speech using Qwen-TTS with specific voice
pub async fn qwen_tts_with_voice(
  config : @lib.ClientConfig,
  text : String,
  voice : String,
) -> String {
  qwen_tts_impl(config, text, default_qwen_tts_model, voice, None)
}

///|
/// Synthesize speech using Qwen-TTS with instructions (instruct mode)
pub async fn qwen_tts_with_instruction(
  config : @lib.ClientConfig,
  text : String,
  instructions : String,
) -> String {
  qwen_tts_impl(
    config,
    text,
    "qwen3-tts-instruct-flash",
    default_qwen_tts_voice,
    Some(instructions),
  )
}

///|
/// Internal: Qwen-TTS implementation
async fn qwen_tts_impl(
  config : @lib.ClientConfig,
  text : String,
  model : String,
  voice : String,
  instructions : String?,
) -> String {
  let input = QwenTtsInput::{
    text,
    voice: Some(voice),
    language_type: None,
    instructions,
    optimize_instructions: instructions.map(_ => true),
    voice_setting: None,
    audio_setting: None,
  }
  let request = MultimodalTtsRequest::{ model, input: input.to_json() }

  let url = "\{config.base_url}/services/aigc/multimodal-generation/generation"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Qwen-TTS request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : TtsResponse = body.json() |> @json.from_json()
  match resp.output.audio {
    Some(audio) =>
      match audio.url {
        Some(u) => u
        None => fail("No audio URL in response")
      }
    None => fail("No audio output in response")
  }
}

///|
/// Synthesize speech using MiniMax
pub async fn minimax_tts(
  config : @lib.ClientConfig,
  text : String,
  voice_id : String,
) -> String {
  minimax_tts_impl(config, text, default_minimax_model, voice_id, None, None)
}

///|
/// Synthesize speech using MiniMax with options
pub async fn minimax_tts_with_options(
  config : @lib.ClientConfig,
  text : String,
  model? : String,
  voice_id? : String,
  speed? : Float,
  emotion? : String,
) -> String {
  minimax_tts_impl(
    config,
    text,
    model.unwrap_or(default_minimax_model),
    voice_id.unwrap_or("male-qn-qingse"),
    speed,
    emotion,
  )
}

///|
/// Internal: MiniMax TTS implementation
async fn minimax_tts_impl(
  config : @lib.ClientConfig,
  text : String,
  model : String,
  voice_id : String,
  speed : Float?,
  emotion : String?,
) -> String {
  let voice_setting = VoiceSetting::{
    voice_id: Some(voice_id),
    speed,
    vol: None,
    pitch: None,
    emotion,
  }
  let audio_setting = AudioSetting::{
    sample_rate: Some(32000),
    bitrate: Some(128000),
    format: Some("mp3"),
    channel: Some(1),
  }
  let input_obj = Json::object(
    Map::Map(
      [
        ("text", text.to_json()),
        ("voice_setting", voice_setting.to_json()),
        ("audio_setting", audio_setting.to_json()),
      ].view(),
    ),
  )
  let request = MultimodalTtsRequest::{ model, input: input_obj }

  let url = "\{config.base_url}/services/aigc/multimodal-generation/generation"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "MiniMax TTS request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : TtsResponse = body.json() |> @json.from_json()
  match resp.output.audio {
    Some(audio) =>
      match audio.url {
        Some(u) => u
        None => fail("No audio URL in response")
      }
    None => fail("No audio output in response")
  }
}

///|
/// Voice Cloning APIs

///|
/// Clone voice using CosyVoice (create custom voice from audio URL)
pub async fn cosyvoice_clone_voice(
  config : @lib.ClientConfig,
  audio_url : String,
  target_model : String,
  prefix : String,
) -> String {
  let input = VoiceCloningInput::{
    action: "create_voice",
    target_model,
    prefix: Some(prefix),
    url: Some(audio_url),
    preferred_name: None,
    audio: None,
  }
  let request = CustomVoiceRequest::{
    model: "voice-enrollment",
    input: input.to_json(),
    parameters: None,
  }

  let url = "\{config.base_url}/services/audio/tts/customization"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "CosyVoice voice cloning failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : CustomVoiceResponse = body.json() |> @json.from_json()
  match resp.output.voice_id {
    Some(v) => v
    None => fail("No voice_id in response")
  }
}

///|
/// Clone voice using Qwen-TTS (create custom voice from audio URL)
pub async fn qwen_clone_voice(
  config : @lib.ClientConfig,
  audio_url : String,
  target_model : String,
  preferred_name : String,
) -> String {
  let audio_obj = Json::object(Map::Map([("data", audio_url.to_json())].view()))
  let input = VoiceCloningInput::{
    action: "create",
    target_model,
    prefix: None,
    url: None,
    preferred_name: Some(preferred_name),
    audio: Some(audio_obj),
  }
  let request = CustomVoiceRequest::{
    model: "qwen-voice-enrollment",
    input: input.to_json(),
    parameters: None,
  }

  let url = "\{config.base_url}/services/audio/tts/customization"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Qwen voice cloning failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : CustomVoiceResponse = body.json() |> @json.from_json()
  match resp.output.voice {
    Some(v) => v
    None => fail("No voice in response")
  }
}

///|
/// Voice Design APIs

///|
/// Design voice using CosyVoice (create custom voice from text description)
pub async fn cosyvoice_design_voice(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  prefix : String,
) -> String {
  cosyvoice_design_voice_impl(
    config,
    voice_prompt,
    target_model,
    prefix,
    None,
    None,
  )
}

///|
/// Design voice using CosyVoice with preview
pub async fn cosyvoice_design_voice_with_preview(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  prefix : String,
  preview_text : String,
) -> (String, String?) {
  let voice_id = cosyvoice_design_voice_impl(
    config,
    voice_prompt,
    target_model,
    prefix,
    Some(preview_text),
    Some("wav"),
  )
  (voice_id, None) // Preview audio is returned in the same response, but we simplify here
}

///|
/// Internal: CosyVoice design voice implementation
async fn cosyvoice_design_voice_impl(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  prefix : String,
  preview_text : String?,
  response_format : String?,
) -> String {
  let input = VoiceDesignInput::{
    action: "create_voice",
    target_model,
    preferred_name: None,
    voice_prompt,
    preview_text,
    prefix: Some(prefix),
  }
  let parameters = match response_format {
    Some(fmt) =>
      Some(CustomVoiceParameters::{
        sample_rate: Some(24000),
        response_format: Some(fmt),
      })
    None => None
  }
  let request = CustomVoiceRequest::{
    model: "voice-enrollment",
    input: input.to_json(),
    parameters,
  }

  let url = "\{config.base_url}/services/audio/tts/customization"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "CosyVoice voice design failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : CustomVoiceResponse = body.json() |> @json.from_json()
  match resp.output.voice_id {
    Some(v) => v
    None => fail("No voice_id in response")
  }
}

///|
/// Design voice using Qwen-TTS (create custom voice from text description)
pub async fn qwen_design_voice(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  preferred_name : String,
) -> String {
  qwen_design_voice_impl(
    config,
    voice_prompt,
    target_model,
    preferred_name,
    None,
    None,
  )
}

///|
/// Design voice using Qwen-TTS with preview text
pub async fn qwen_design_voice_with_preview(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  preferred_name : String,
  preview_text : String,
) -> String {
  qwen_design_voice_impl(
    config,
    voice_prompt,
    target_model,
    preferred_name,
    Some(preview_text),
    Some("wav"),
  )
}

///|
/// Internal: Qwen design voice implementation
async fn qwen_design_voice_impl(
  config : @lib.ClientConfig,
  voice_prompt : String,
  target_model : String,
  preferred_name : String,
  preview_text : String?,
  response_format : String?,
) -> String {
  let input = VoiceDesignInput::{
    action: "create",
    target_model,
    preferred_name: Some(preferred_name),
    voice_prompt,
    preview_text,
    prefix: None,
  }
  let parameters = match response_format {
    Some(fmt) =>
      Some(CustomVoiceParameters::{
        sample_rate: Some(24000),
        response_format: Some(fmt),
      })
    None => None
  }
  let request = CustomVoiceRequest::{
    model: "qwen-voice-design",
    input: input.to_json(),
    parameters,
  }

  let url = "\{config.base_url}/services/audio/tts/customization"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Qwen voice design failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : CustomVoiceResponse = body.json() |> @json.from_json()
  match resp.output.voice {
    Some(v) => v
    None => fail("No voice in response")
  }
}

///|
/// SSML TTS (CosyVoice)
pub async fn cosyvoice_tts_ssml(
  config : @lib.ClientConfig,
  ssml_text : String,
  voice : String,
) -> String {
  let input = TtsInput::{
    text: ssml_text,
    voice: Some(voice),
    format: None,
    sample_rate: None,
    language_type: None,
    instruction: None,
    enable_ssml: Some(true),
    word_timestamp_enabled: None,
  }
  let request = TtsRequest::{ model: default_cosyvoice_model, input }

  let url = "\{config.base_url}/services/audio/tts/SpeechSynthesizer"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "CosyVoice SSML TTS request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : TtsResponse = body.json() |> @json.from_json()
  match resp.output.audio {
    Some(audio) =>
      match audio.url {
        Some(u) => u
        None => fail("No audio URL in response")
      }
    None => fail("No audio output in response")
  }
}
