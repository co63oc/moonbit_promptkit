///|
/// S2S (Speech-to-Speech) API (端到端语音对话)
/// Qwen-S2S - 语音大模型，直接语音输入输出
/// Endpoint: /services/aigc/speech-generation/generation
///

///|
/// Default S2S model
pub let default_model : String = "qwen2.5-s2s"

///|
/// S2S request input
struct S2SInput {
  audio_url : String?
  text : String?
  voice : String?
} derive(ToJson)

///|
/// S2S request parameters
struct S2SParams {
  response_format : String?
  sample_rate : Int?
} derive(ToJson)

///|
/// S2S request
struct S2SRequest {
  model : String
  input : S2SInput
  parameters : S2SParams?
} derive(ToJson)

///|
/// Speech-to-speech: voice input, voice output
/// Returns audio URL
pub async fn speech_to_speech(
  config : @lib.ClientConfig,
  audio_url : String,
  voice? : String,
  response_format? : String,
) -> String {
  let input = S2SInput::{
    audio_url: Some(audio_url),
    text: None,
    voice,
  }
  let parameters = S2SParams::{
    response_format,
    sample_rate: None,
  }
  let request = S2SRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/speech-generation/generation"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "S2S request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_audio_url(resp)
}

///|
/// Text-to-speech using S2S model
/// Returns audio URL
pub async fn text_to_speech_s2s(
  config : @lib.ClientConfig,
  text : String,
  voice? : String,
  response_format? : String,
) -> String {
  let input = S2SInput::{
    audio_url: None,
    text: Some(text),
    voice,
  }
  let parameters = S2SParams::{
    response_format,
    sample_rate: None,
  }
  let request = S2SRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/speech-generation/generation"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "S2S TTS request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_audio_url(resp)
}

// Internal helpers
fn extract_audio_url(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("audio") {
            Some(Json::String(u)) => u
            _ => ""
          }
        _ => ""
      }
    _ => ""
  }
}
