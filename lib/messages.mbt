///|
/// Message builders for Moonbit Promptkit SDK
///

///|
/// The text_content function.
pub fn text_content(text : String) -> Content {
  {
    type_: "text",
    text: Some(text),
    image_url: None,
    video_url: None,
    audio_url: None,
    cache_control: None,
  }
}

///|
/// The text_content_with_cache function.
pub fn text_content_with_cache(text : String) -> Content {
  {
    type_: "text",
    text: Some(text),
    image_url: None,
    video_url: None,
    audio_url: None,
    cache_control: Some({ type_: "ephemeral" }),
  }
}

///|
/// The content_with_cache function.
pub fn content_with_cache(content : Content) -> Content {
  { ..content, cache_control: Some({ type_: "ephemeral" }) }
}

///|
/// The image_content function.
pub fn image_content(url : String) -> Content {
  {
    type_: "image_url",
    text: None,
    image_url: Some({ url, }),
    video_url: None,
    audio_url: None,
    cache_control: None,
  }
}

///|
/// The video_content function.
pub fn video_content(url : String) -> Content {
  {
    type_: "video_url",
    text: None,
    image_url: None,
    video_url: Some({ url, }),
    audio_url: None,
    cache_control: None,
  }
}

///|
/// The audio_content function.
pub fn audio_content(url : String) -> Content {
  {
    type_: "audio_url",
    text: None,
    image_url: None,
    video_url: None,
    audio_url: Some({ url, }),
    cache_control: None,
  }
}

///|
/// The user_message_with_text function.
pub fn user_message_with_text(text : String) -> Message {
  {
    role: "user",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The user_message_with_contents function.
pub fn user_message_with_contents(contents : Array[Content]) -> Message {
  {
    role: "user",
    content: contents.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The assistant_message function.
pub fn assistant_message(text : String) -> Message {
  {
    role: "assistant",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The assistant_message_partial function.
pub fn assistant_message_partial(text : String) -> Message {
  {
    role: "assistant",
    content: text.to_json(),
    partial: Some(true),
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The tool_message function.
pub fn tool_message(tool_call_id : String, content : String) -> Message {
  {
    role: "tool",
    content: content.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: Some(tool_call_id),
    reasoning_content: None,
  }
}

///|
/// The system_message function.
pub fn system_message(text : String) -> Message {
  {
    role: "system",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The extract_text_from_content function.
pub fn extract_text_from_content(content : Json) -> String {
  match content {
    String(s) => s
    Array(arr) =>
      if arr.length() > 0 {
        let item = arr[0]
        match item {
          Object(obj) =>
            match obj.get("text") {
              Some(String(s)) => s
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
/// The system_message_with_cache function.
pub fn system_message_with_cache(text : String) -> Message {
  {
    role: "system",
    content: [text_content_with_cache(text)].to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The user_message_with_cache function.
pub fn user_message_with_cache(text : String) -> Message {
  {
    role: "user",
    content: [text_content_with_cache(text)].to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
    reasoning_content: None,
  }
}

///|
/// The extract_usage function.
pub fn extract_usage(response : Response) -> Usage? {
  match response.usage {
    Some(json) => Some(@json.from_json(json)) catch { _ => None }
    None => None
  }
}

///|
/// The get_total_tokens function.
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
/// The get_prompt_tokens function.
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
/// The get_completion_tokens function.
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
/// The get_cache_creation_tokens function.
pub fn get_cache_creation_tokens(response : Response) -> Int {
  // OpenAI 兼容接口：缓存创建 token 数在 prompt_tokens_details.cache_creation_input_tokens
  match extract_usage(response) {
    Some(usage) =>
      match usage.prompt_tokens_details {
        Some(details) =>
          match details.cache_creation_input_tokens {
            Some(n) => n
            None => 0
          }
        None => 0
      }
    None => 0
  }
}

///|
/// The get_cache_read_tokens function.
pub fn get_cache_read_tokens(response : Response) -> Int {
  // OpenAI 兼容接口：缓存命中 token 数在 prompt_tokens_details.cached_tokens
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
/// The get_cached_tokens function.
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
  { include_usage, }
}
