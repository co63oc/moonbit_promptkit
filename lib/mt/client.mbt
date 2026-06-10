///|
/// Qwen-MT Translation API client functions
///

///|
/// Qwen-MT default model: best balance of quality, speed and cost
pub let translate_default_model : String = "qwen-mt-flash"

///| Translate text using Qwen-MT model

///| - source_lang: "Chinese", "English", "Japanese", "Korean", "French", "German", etc. or "auto"

///| - target_lang: same language names as source_lang

///|
/// - model: "qwen-mt-flash" (default), "qwen-mt-plus", "qwen-mt-turbo", "qwen-mt-lite"
pub async fn translate(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
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
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///|
/// Translate with specific model
pub async fn translate_with_model(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  model : String,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
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
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with terminology intervention (术语干预)

///|
/// terms: array of TranslationTerm { source, target } for consistent translation
pub async fn translate_with_terms(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  terms : Array[TranslationTerm],
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: Some(terms),
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
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
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with domain hint for better specialized translation

///|
/// domain: e.g. "legal", "medical", "technical", "social"
pub async fn translate_with_domain(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  domain : String,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: Some(domain),
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
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
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with streaming output (incremental)

///|
/// Only qwen-mt-flash and qwen-mt-lite support streaming
pub async fn translate_stream(
  config : @lib.ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  on_delta : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: Some(true),
    stream_options: Some(@lib.stream_options(true)),
    translation_options,
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
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  body_text
}
