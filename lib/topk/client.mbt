///|
/// TopK-enabled chat API for dialogue analysis models
///

///| Chat with top_k parameter for deterministic output

///|
/// Recommended: temperature=0.0, top_k=1 for dialogue analysis
pub async fn chat_topk(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
  temperature : Float,
  top_k : Int,
) -> String {
  let request = TopKRequest::{
    model,
    messages,
    stream: None,
    stream_options: None,
    temperature: Some(temperature),
    top_k: Some(top_k),
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
    fail("Chat request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No response from model")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///|
/// Chat with top_k and streaming output
pub async fn chat_topk_stream(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
  temperature : Float,
  top_k : Int,
  on_delta : (String) -> Unit,
) -> String {
  let request = TopKRequest::{
    model,
    messages,
    stream: Some(true),
    stream_options: Some(@lib.stream_options(true)),
    temperature: Some(temperature),
    top_k: Some(top_k),
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
    fail("Chat request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  ""
}
