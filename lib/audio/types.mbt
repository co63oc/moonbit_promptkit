///|
/// Audio understanding types for Qwen3-Omni-Captioner
/// Uses OpenAI-compatible `input_audio` format (not DashScope `audio_url`)
///

///| Audio input data

///|
/// data is the URL to the audio file
pub struct AudioInput {
  data : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend AudioInput with ToJson::{to_json}

///|
pub extend AudioInput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AudioInput with @moonbitlang/core/debug.Debug::{to_repr}

///| Audio content for messages

///| type must be "input_audio"

///|
/// Uses OpenAI-compatible format: { "type": "input_audio", "input_audio": { "data": "url" } }
pub struct AudioContent {
  type_ : String
  input_audio : AudioInput
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub extend AudioContent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend AudioContent with ToJson::{to_json}

///|
pub extend AudioContent with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Audio request for Qwen3-Omni-Captioner
pub struct AudioRequest {
  model : String
  messages : Array[Json]
  stream : Bool?
  stream_options : @lib.StreamOptions?
} derive(ToJson)

///|
pub extend AudioRequest with ToJson::{to_json}

///|
/// Create audio input structure
pub fn audio_input(url : String) -> AudioInput {
  { data: url }
}

///|
/// Create audio content for messages
pub fn audio_content(url : String) -> AudioContent {
  { type_: "input_audio", input_audio: audio_input(url) }
}

///|
/// Default audio captioner model
pub let default_model : String = "qwen3-omni-30b-a3b-captioner"

///|
/// TTS (Text-to-Speech) types

///|
/// Voice setting for MiniMax-style TTS
pub struct VoiceSetting {
  voice_id : String?
  speed : Float?
  vol : Float?
  pitch : Float?
  emotion : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend VoiceSetting with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VoiceSetting with ToJson::{to_json}

///|
pub extend VoiceSetting with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Audio setting for MiniMax-style TTS
pub struct AudioSetting {
  sample_rate : Int?
  bitrate : Int?
  format : String?
  channel : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend AudioSetting with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AudioSetting with ToJson::{to_json}

///|
pub extend AudioSetting with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// TTS input for CosyVoice/Qwen-TTS (SpeechSynthesizer API)
pub struct TtsInput {
  text : String
  voice : String?
  format : String?
  sample_rate : Int?
  language_type : String?
  instruction : String?
  enable_ssml : Bool?
  word_timestamp_enabled : Bool?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend TtsInput with ToJson::{to_json}

///|
pub extend TtsInput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend TtsInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// TTS input for Qwen-TTS (multimodal-generation API)
pub struct QwenTtsInput {
  text : String
  voice : String?
  language_type : String?
  instructions : String?
  optimize_instructions : Bool?
  voice_setting : VoiceSetting?
  audio_setting : AudioSetting?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend QwenTtsInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend QwenTtsInput with ToJson::{to_json}

///|
pub extend QwenTtsInput with @moonbitlang/core/json.FromJson::{from_json}

///|
/// TTS request for CosyVoice (SpeechSynthesizer API)
pub struct TtsRequest {
  model : String
  input : TtsInput
} derive(Debug, ToJson)

///|
pub extend TtsRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TtsRequest with ToJson::{to_json}

///|
/// TTS request for Qwen-TTS/MiniMax (multimodal-generation API)
pub struct MultimodalTtsRequest {
  model : String
  input : Json
} derive(Debug, ToJson)

///|
pub extend MultimodalTtsRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MultimodalTtsRequest with ToJson::{to_json}

///|
/// TTS audio result
pub struct TtsAudioResult {
  url : String?
  data : String?
  expires_at : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend TtsAudioResult with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend TtsAudioResult with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TtsAudioResult with ToJson::{to_json}

///|
/// TTS output
pub struct TtsOutput {
  audio : TtsAudioResult?
  finish_reason : String?
  task_status : String?
  task_id : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend TtsOutput with ToJson::{to_json}

///|
pub extend TtsOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend TtsOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// TTS response (non-streaming)
pub struct TtsResponse {
  output : TtsOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend TtsResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TtsResponse with ToJson::{to_json}

///|
pub extend TtsResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Custom voice action types (internal use)

///|
/// Voice cloning input (CosyVoice style)
pub struct VoiceCloningInput {
  action : String
  target_model : String
  prefix : String?
  url : String?
  preferred_name : String?
  audio : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend VoiceCloningInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VoiceCloningInput with ToJson::{to_json}

///|
pub extend VoiceCloningInput with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Voice design input
pub struct VoiceDesignInput {
  action : String
  target_model : String
  preferred_name : String?
  voice_prompt : String
  preview_text : String?
  prefix : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend VoiceDesignInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VoiceDesignInput with ToJson::{to_json}

///|
pub extend VoiceDesignInput with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Custom voice parameters
pub struct CustomVoiceParameters {
  sample_rate : Int?
  response_format : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend CustomVoiceParameters with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CustomVoiceParameters with @moonbitlang/core/json.FromJson::{
  from_json,
}

///|
pub extend CustomVoiceParameters with ToJson::{to_json}

///|
/// Custom voice request (voice cloning / voice design)
pub struct CustomVoiceRequest {
  model : String
  input : Json
  parameters : CustomVoiceParameters?
} derive(Debug, ToJson)

///|
pub extend CustomVoiceRequest with ToJson::{to_json}

///|
pub extend CustomVoiceRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Custom voice output
pub struct CustomVoiceOutput {
  voice : String?
  voice_id : String?
  preview_audio : TtsAudioResult?
  voices : Array[Json]?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend CustomVoiceOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend CustomVoiceOutput with ToJson::{to_json}

///|
pub extend CustomVoiceOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Custom voice response
pub struct CustomVoiceResponse {
  output : CustomVoiceOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend CustomVoiceResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CustomVoiceResponse with ToJson::{to_json}

///|
pub extend CustomVoiceResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Default TTS models
pub let default_cosyvoice_model : String = "cosyvoice-v3-flash"

///|
/// The default_qwen_tts_model value.
pub let default_qwen_tts_model : String = "qwen3-tts-flash"

///|
/// The default_minimax_model value.
pub let default_minimax_model : String = "MiniMax/speech-2.8-hd"

///|
/// Default voice for CosyVoice
pub let default_cosyvoice_voice : String = "longanyang"

///|
/// Default voice for Qwen-TTS
pub let default_qwen_tts_voice : String = "Cherry"
