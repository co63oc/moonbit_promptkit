///|
/// Message builders for Moonbit Promptkit SDK
///

///|
pub fn text_content(text : String) -> Content {
  Content::{
    type_: "text",
    text: Some(text),
    image_url: None,
    video_url: None,
    audio_url: None,
    cache_control: None,
  }
}

///|
pub fn text_content_with_cache(text : String) -> Content {
  Content::{
    type_: "text",
    text: Some(text),
    image_url: None,
    video_url: None,
    audio_url: None,
    cache_control: Some(CacheControl::{ type_: "ephemeral" }),
  }
}

///|
pub fn content_with_cache(content : Content) -> Content {
  Content::{
    ..content,
    cache_control: Some(CacheControl::{ type_: "ephemeral" }),
  }
}

///|
pub fn image_content(url : String) -> Content {
  Content::{
    type_: "image_url",
    text: None,
    image_url: Some(ImageUrl::{ url, }),
    video_url: None,
    audio_url: None,
    cache_control: None,
  }
}

///|
pub fn video_content(url : String) -> Content {
  Content::{
    type_: "video_url",
    text: None,
    image_url: None,
    video_url: Some(VideoUrl::{ url, }),
    audio_url: None,
    cache_control: None,
  }
}

///|
pub fn audio_content(url : String) -> Content {
  Content::{
    type_: "audio_url",
    text: None,
    image_url: None,
    video_url: None,
    audio_url: Some(AudioUrl::{ url, }),
    cache_control: None,
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

///|
pub fn system_message_with_cache(text : String) -> Message {
  Message::{
    role: "system",
    content: [text_content_with_cache(text)].to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn user_message_with_cache(text : String) -> Message {
  Message::{
    role: "user",
    content: [text_content_with_cache(text)].to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
pub fn extract_usage(response : Response) -> Usage? {
  match response.usage {
    Some(json) => Some(@json.from_json(json)) catch { _ => None }
    None => None
  }
}

///|
pub fn get_total_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.total_tokens {
        Some(n) => n
        None => 0
      }
    None => 0
  }
}

///|
pub fn get_prompt_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.prompt_tokens {
        Some(n) => n
        None => 0
      }
    None => 0
  }
}

///|
pub fn get_completion_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.completion_tokens {
        Some(n) => n
        None => 0
      }
    None => 0
  }
}

///|
pub fn get_cache_creation_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.cache_creation_input_tokens {
        Some(n) => n
        None => 0
      }
    None => 0
  }
}

///|
pub fn get_cache_read_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.cache_read_input_tokens {
        Some(n) => n
        None => 0
      }
    None => 0
  }
}

///|
pub fn get_cached_tokens(response : Response) -> Int {
  match extract_usage(response) {
    Some(usage) =>
      match usage.prompt_tokens_details {
        Some(details) =>
          match details.cached_tokens {
            Some(n) => n
            None => 0
          }
        None => 0
      }
    None => 0
  }
}

///|
/// Create StreamOptions for streaming requests
pub fn stream_options(include_usage : Bool) -> StreamOptions {
  StreamOptions::{ include_usage, }
}
