///|
/// Audio understanding types for Qwen3-Omni-Captioner
/// Uses OpenAI-compatible `input_audio` format (not DashScope `audio_url`)
///

///| Audio input data
///| data is the URL to the audio file
pub struct AudioInput {
  data : String
} derive(Debug, ToJson, @json.FromJson)

///| Audio content for messages
///| type must be "input_audio"
///| Uses OpenAI-compatible format: { "type": "input_audio", "input_audio": { "data": "url" } }
pub struct AudioContent {
  type_ : String
  input_audio : AudioInput
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///| Audio request for Qwen3-Omni-Captioner
pub struct AudioRequest {
  model : String
  messages : Array[Json]
  stream : Bool?
  stream_options : @lib.StreamOptions?
} derive(ToJson)

///| Create audio input structure
pub fn audio_input(url : String) -> AudioInput {
  AudioInput::{ data: url }
}

///| Create audio content for messages
pub fn audio_content(url : String) -> AudioContent {
  AudioContent::{
    type_: "input_audio",
    input_audio: audio_input(url),
  }
}

///| Default audio captioner model
pub let default_model : String = "qwen3-omni-30b-a3b-captioner"
