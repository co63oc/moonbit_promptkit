///|
/// Live Translation API (实时翻译)
/// Qwen-LiveTranslate - 流式实时翻译
/// Endpoint: /chat/completions (OpenAI compatible, streaming)
///

///|
/// Default live translate model
pub let default_model : String = "qwen3.5-livetranslate-flash-realtime"

///|
/// Live translate model for non-realtime
pub let translate_model : String = "qwen3-livetranslate-flash"

///|
/// Translation request input
struct TranslationInput {
  text : String
  source_lang : String
  target_lang : String
} derive(ToJson)

///|
/// Translation request
struct TranslationRequest {
  model : String
  input : TranslationInput
} derive(ToJson)

///|
/// Translate text using live translation model
pub async fn translate(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
) -> String {
  let input = TranslationInput::{ text, source_lang, target_lang }
  let request = TranslationRequest::{
    model: translate_model,
    input,
  }

  let url = "\{config.base_url}/chat/completions"
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
      "Translation request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_translation_result(resp)
}

///|
/// Translate with streaming output
pub async fn translate_stream(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  on_delta : (String) -> Unit,
) -> String {
  let input = TranslationInput::{ text, source_lang, target_lang }
  let request = TranslationRequest::{
    model: default_model,
    input,
  }

  let url = "\{config.base_url}/chat/completions"
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
      "Translation stream request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let result = body.text()
  on_delta(result)
  result
}

// Internal helpers
fn extract_translation_result(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("text") {
            Some(Json::String(t)) => t
            _ => ""
          }
        _ => ""
      }
    _ => ""
  }
}
