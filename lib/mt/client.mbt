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
  match @lib.try_mock(config) {
    Some(body) => {
      let resp : @lib.Response = @json.from_json(@json.parse(body))
      if resp.choices.length() == 0 {
        fail("No translation result")
      } else {
        return @lib.extract_text_from_content(resp.choices[0].message.content)
      }
    }
    None => ignore(())
  }
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
  match @lib.try_mock(config) {
    Some(body) => {
      let resp : @lib.Response = @json.from_json(@json.parse(body))
      if resp.choices.length() == 0 {
        fail("No translation result")
      } else {
        return @lib.extract_text_from_content(resp.choices[0].message.content)
      }
    }
    None => ignore(())
  }
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
  match @lib.try_mock(config) {
    Some(body) => {
      let resp : @lib.Response = @json.from_json(@json.parse(body))
      if resp.choices.length() == 0 {
        fail("No translation result")
      } else {
        return @lib.extract_text_from_content(resp.choices[0].message.content)
      }
    }
    None => ignore(())
  }
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
  match @lib.try_mock(config) {
    Some(body) => {
      let resp : @lib.Response = @json.from_json(@json.parse(body))
      if resp.choices.length() == 0 {
        fail("No translation result")
      } else {
        return @lib.extract_text_from_content(resp.choices[0].message.content)
      }
    }
    None => ignore(())
  }
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
  match @lib.try_mock(config) {
    Some(body) => {
      let resp : @lib.Response = @json.from_json(@json.parse(body))
      if resp.choices.length() == 0 {
        fail("No translation result")
      } else {
        let content = @lib.extract_text_from_content(
          resp.choices[0].message.content,
        )
        on_delta(content)
        return content
      }
    }
    None => ignore(())
  }
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
  let client = @http.post_stream("\{config.base_url}/chat/completions", headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  client.write(request.to_json().stringify())
  let response = client.end_request()
  guard response.code is (200..=299) else {
    client.close()
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let content = @lib.parse_sse_stream_raw(client, on_delta)
  client.close()
  content
}
