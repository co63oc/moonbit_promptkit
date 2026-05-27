///|
/// Core client functions for Moonbit Bailian SDK
///

///|
pub async fn generate(config : ClientConfig, request : Request) -> Response {
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
pub async fn chat(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_with_search(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: Some(true),
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_with_tools(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  tools : Json,
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: Some(tools),
    extra_body: Some(@json.parse("{\"enable_thinking\": false}")),
    enable_search: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_stream(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  on_delta : (String) -> Unit,
) -> String {
  let request = Request::{
    model,
    messages,
    stream: Some(true),
    stream_options: Some(StreamOptions::{ include_usage: true }),
    tools: None,
    extra_body: None,
    enable_search: None,
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
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  body_text
}
