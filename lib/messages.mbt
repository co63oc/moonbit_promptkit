///|
/// Message builders for Moonbit Promptkit SDK
///

///|
pub fn text_content(text : String) -> Content {
  Content::{ type_: "text", text: Some(text), image_url: None }
}

///|
pub fn image_content(url : String) -> Content {
  Content::{
    type_: "image_url",
    text: None,
    image_url: Some(ImageUrl::{ url, }),
  }
}

///|
pub fn user_message_with_text(text : String) -> Message {
  Message::{
    role: "user",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn user_message_with_contents(contents : Array[Content]) -> Message {
  Message::{
    role: "user",
    content: contents.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn assistant_message(text : String) -> Message {
  Message::{
    role: "assistant",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn assistant_message_partial(text : String) -> Message {
  Message::{
    role: "assistant",
    content: text.to_json(),
    partial: Some(true),
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn tool_message(tool_call_id : String, content : String) -> Message {
  Message::{
    role: "tool",
    content: content.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: Some(tool_call_id),
    reasoning_content: None,
  }
}

///|
pub fn system_message(text : String) -> Message {
  Message::{
    role: "system",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn extract_text_from_content(content : Json) -> String {
  match content {
    Json::String(s) => s
    Json::Array(arr) =>
      if arr.length() > 0 {
        let item = arr[0]
        match item {
          Json::Object(obj) =>
            match obj.get("text") {
              Some(Json::String(s)) => s
              _ => "(无文本回复)"
            }
          _ => "(无文本回复)"
        }
      } else {
        "(无回复)"
      }
    _ => "(无文本回复)"
  }
}
