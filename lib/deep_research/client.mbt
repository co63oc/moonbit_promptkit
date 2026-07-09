///|
/// Deep research API for Qwen-Deep-Research
///

///|
/// Default deep research model
pub let deep_research_default_model : String = "qwen-deep-research"

///|
/// DashScope API endpoint
let dashscope_url : String = "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation"

///|
/// Extract content from deep research response JSON
pub fn extract_content(response_text : String) -> String {
  try {
    let json = @json.parse(response_text)
    match json {
      Json::Object(obj) =>
        match obj.get("output") {
          Some(Json::Object(output)) =>
            match output.get("message") {
              Some(Json::Object(message)) =>
                match message.get("content") {
                  Some(Json::String(content)) => content
                  _ => response_text
                }
              _ => response_text
            }
          _ => response_text
        }
      _ => response_text
    }
  } catch {
    _ => response_text
  }
}

///| Start deep research with streaming output

///| Returns the complete research report

///|
/// Note: This is a simplified version that collects all streamed output
pub async fn research(
  config : @lib.ClientConfig,
  question : String,
  on_progress : (String) -> Unit,
) -> String {
  match @lib.try_mock(config) {
    Some(body) => {
      let content = extract_content(body)
      on_progress(content)
      return content
    }
    None => ignore(())
  }
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(question)]
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{
    model: deep_research_default_model,
    input,
    parameters: None,
  }
  let (code, reason, text) = @lib.timed_post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard code is (200..=299) else {
    fail("Research request failed: \{code} \{reason}")
  }
  let content = extract_content(text)
  on_progress(content)
  content
}

///|
/// Research with specific model
pub async fn research_with_model(
  config : @lib.ClientConfig,
  question : String,
  model : String,
  on_progress : (String) -> Unit,
) -> String {
  match @lib.try_mock(config) {
    Some(body) => {
      let content = extract_content(body)
      on_progress(content)
      return content
    }
    None => ignore(())
  }
  let messages : Array[@lib.Message] = [@lib.user_message_with_text(question)]
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{ model, input, parameters: None }
  let (code, reason, text) = @lib.timed_post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard code is (200..=299) else {
    fail("Research request failed: \{code} \{reason}")
  }
  let content = extract_content(text)
  on_progress(content)
  content
}

///|
/// Research with custom message history (for multi-turn conversations)
pub async fn research_with_messages(
  config : @lib.ClientConfig,
  messages : Array[@lib.Message],
  on_progress : (String) -> Unit,
) -> String {
  match @lib.try_mock(config) {
    Some(body) => {
      let content = extract_content(body)
      on_progress(content)
      return content
    }
    None => ignore(())
  }
  let input = DeepResearchInput::{ messages, }
  let request = DeepResearchRequest::{
    model: deep_research_default_model,
    input,
    parameters: None,
  }
  let (code, reason, text) = @lib.timed_post(dashscope_url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-SSE": "enable",
  })
  guard code is (200..=299) else {
    fail("Research request failed: \{code} \{reason}")
  }
  let content = extract_content(text)
  on_progress(content)
  content
}
