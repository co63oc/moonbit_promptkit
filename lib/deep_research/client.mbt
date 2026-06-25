///|
/// Deep research API for Qwen-Deep-Research
///

///|
/// Default deep research model
pub let deep_research_default_model : String = "qwen-deep-research"

///|
/// DashScope API endpoint
let dashscope_url : String = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation"

///| Start deep research with streaming output

///| Returns the complete research report

///|
/// Note: This is a simplified version that collects all streamed output
pub async fn research(
  config : @lib.ClientConfig,
  question : String,
  on_progress : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(question)]
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{
    model: deep_research_default_model,
    input,
    parameters: None,
  }
  let (response, body) = @http.post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard response.code is (200..=299) else {
    fail("Research request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_progress(body_text)
  body_text
}

///|
/// Research with specific model
pub async fn research_with_model(
  config : @lib.ClientConfig,
  question : String,
  model : String,
  on_progress : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(question)]
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{ model, input, parameters: None }
  let (response, body) = @http.post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard response.code is (200..=299) else {
    fail("Research request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_progress(body_text)
  body_text
}

///|
/// Research with custom message history (for multi-turn conversations)
pub async fn research_with_messages(
  config : @lib.ClientConfig,
  messages : Array[@lib.Message],
  on_progress : (String) -> Unit,
) -> String {
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{
    model: deep_research_default_model,
    input,
    parameters: None,
  }
  let (response, body) = @http.post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard response.code is (200..=299) else {
    fail("Research request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_progress(body_text)
  body_text
}
