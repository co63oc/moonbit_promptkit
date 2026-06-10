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

///| Audio content for messages

///| type must be "input_audio"

///|
/// Uses OpenAI-compatible format: { "type": "input_audio", "input_audio": { "data": "url" } }
pub struct AudioContent {
  type_ : String
  input_audio : AudioInput
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
/// Audio request for Qwen3-Omni-Captioner
pub struct AudioRequest {
  model : String
  messages : Array[Json]
  stream : Bool?
  stream_options : @lib.StreamOptions?
} derive(ToJson)

///|
/// Create audio input structure
pub fn audio_input(url : String) -> AudioInput {
  AudioInput::{ data: url }
}

///|
/// Create audio content for messages
pub fn audio_content(url : String) -> AudioContent {
  AudioContent::{ type_: "input_audio", input_audio: audio_input(url) }
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
/// Audio setting for MiniMax-style TTS
pub struct AudioSetting {
  sample_rate : Int?
  bitrate : Int?
  format : String?
  channel : Int?
} derive(Debug, ToJson, @json.FromJson)

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
/// TTS request for CosyVoice (SpeechSynthesizer API)
pub struct TtsRequest {
  model : String
  input : TtsInput
} derive(Debug, ToJson)

///|
/// TTS request for Qwen-TTS/MiniMax (multimodal-generation API)
pub struct MultimodalTtsRequest {
  model : String
  input : Json
} derive(Debug, ToJson)

///|
/// TTS audio result
pub struct TtsAudioResult {
  url : String?
  data : String?
  expires_at : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// TTS output
pub struct TtsOutput {
  audio : TtsAudioResult?
  finish_reason : String?
  task_status : String?
  task_id : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// TTS response (non-streaming)
pub struct TtsResponse {
  output : TtsOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

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
/// Custom voice parameters
pub struct CustomVoiceParameters {
  sample_rate : Int?
  response_format : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Custom voice request (voice cloning / voice design)
pub struct CustomVoiceRequest {
  model : String
  input : Json
  parameters : CustomVoiceParameters?
} derive(Debug, ToJson)

///|
/// Custom voice output
pub struct CustomVoiceOutput {
  voice : String?
  voice_id : String?
  preview_audio : TtsAudioResult?
  voices : Array[Json]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Custom voice response
pub struct CustomVoiceResponse {
  output : CustomVoiceOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Default TTS models
pub let default_cosyvoice_model : String = "cosyvoice-v3-flash"

///|
pub let default_qwen_tts_model : String = "qwen3-tts-flash"

///|
pub let default_minimax_model : String = "MiniMax/speech-2.8-hd"

///|
/// Default voice for CosyVoice
pub let default_cosyvoice_voice : String = "longanyang"

///|
/// Default voice for Qwen-TTS
pub let default_qwen_tts_voice : String = "Cherry"
