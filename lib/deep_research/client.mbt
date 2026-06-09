///|
/// Deep research API for Qwen-Deep-Research
///

///| Default deep research model
pub let deep_research_default_model : String = "qwen-deep-research"

///| Start deep research with streaming output
///| Returns the complete research report
///| Note: This is a simplified version that collects all streamed output
pub async fn research(
  config : @lib.ClientConfig,
  question : String,
  on_progress : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(question),
  ]
  let request = DeepResearchRequest::{
    model: deep_research_default_model,
    messages,
    stream: true,
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
    fail("Research request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_progress(body_text)
  body_text
}

///| Research with specific model
pub async fn research_with_model(
  config : @lib.ClientConfig,
  question : String,
  model : String,
  on_progress : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(question),
  ]
  let request = DeepResearchRequest::{
    model,
    messages,
    stream: true,
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
    fail("Research request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_progress(body_text)
  body_text
}
