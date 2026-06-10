///|
/// Qwen-Omni API (多模态大模型)
/// Qwen3.5-Omni - 全模态理解与生成
/// Endpoint: /chat/completions (OpenAI compatible, streaming)
///

///|
/// Default Qwen-Omni model
pub let default_model : String = "qwen3.5-omni-plus"

///|
/// Flash model for cost-sensitive scenarios
pub let flash_model : String = "qwen3.5-omni-flash"

///|
/// Audio output configuration
struct AudioConfig {
  voice : String
  format : String
} derive(ToJson)

///|
/// Omni request
struct OmniRequest {
  model : String
  messages : Array[@lib.Message]
  modalities : Array[String]
  audio : AudioConfig?
  stream : Bool?
  stream_options : @lib.StreamOptions?
} derive(ToJson)

///|
/// Chat with Qwen-Omni (text input, text + audio output)
/// Returns text response
pub async fn chat(
  config : @lib.ClientConfig,
  messages : Array[@lib.Message],
  voice? : String,
  output_audio? : Bool,
) -> String {
  let v = voice.unwrap_or("Tina")
  let audio_config = if output_audio.unwrap_or(false) {
    Some(AudioConfig::{ voice: v, format: "wav" })
  } else {
    None
  }
  let modalities = if output_audio.unwrap_or(false) {
    ["text", "audio"]
  } else {
    ["text"]
  }
  let request = OmniRequest::{
    model: default_model,
    messages,
    modalities,
    audio: audio_config,
    stream: Some(true),
    stream_options: Some(@lib.stream_options(true)),
  }

  let url = "\{config.base_url}/chat/completions"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "***",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Qwen-Omni request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  // Parse streaming response - extract text content
  let text = body.text()
  extract_text_from_stream(text)
}

///|
/// Analyze audio content with Qwen-Omni
pub async fn analyze_audio(
  config : @lib.ClientConfig,
  audio_url : String,
  prompt : String,
) -> String {
  let content = [
    @lib.audio_content(audio_url),
    @lib.text_content(prompt),
  ]
  let messages = [@lib.user_message_with_contents(content)]
  chat(config, messages, output_audio=false)
}

///|
/// Analyze video content with Qwen-Omni
pub async fn analyze_video(
  config : @lib.ClientConfig,
  video_url : String,
  prompt : String,
) -> String {
  let content = [
    @lib.video_content(video_url),
    @lib.text_content(prompt),
  ]
  let messages = [@lib.user_message_with_contents(content)]
  chat(config, messages, output_audio=false)
}

// Internal helpers
fn extract_text_from_stream(stream_text : String) -> String {
  // For now, return the raw response
  // Users can parse the streaming response themselves
  stream_text
}
