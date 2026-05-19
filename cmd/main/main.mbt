///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.

///|
let env : Map[String, String] = @sys.get_env_vars()

///|
fn get_env_var(name : String, default : String?) -> String {
  match env.get(name) {
    Some(value) => value
    None =>
      match default {
        Some(value) => value
        None => {
          println("Please set \{name} environment variable")
          panic()
        }
      }
  }
}

///|
let api_key : String = get_env_var("MOONBIT_API_KEY", None)

///|
let base_url : String = get_env_var(
  "MOONBIT_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"),
)

///|
struct ImageUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
struct Content {
  text : String?
  image_url : ImageUrl?
  type_ : String
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
struct Message {
  role : String
  content : Json
  partial : Bool?
  tool_calls : Array[ToolCall]?
  tool_call_id : String?
} derive(Debug, ToJson, @json.FromJson)

///|
struct Function {
  name : String
  arguments : String
} derive(Debug, ToJson, @json.FromJson)

///|
struct ToolCall {
  id : String
  function : Function
} derive(Debug, ToJson, @json.FromJson)

///|
struct StreamOptions {
  include_usage : Bool
} derive(Debug, ToJson, @json.FromJson)

///|
struct Request {
  model : String
  messages : Array[Message]
  stream : Bool?
  stream_options : StreamOptions?
  tools : Json?
  extra_body : Json?
  enable_search : Bool?
} derive(ToJson)

///|
struct Choice {
  message : Message
} derive(ToJson, @json.FromJson)

///|
struct Response {
  choices : Array[Choice]
  usage : Json?
} derive(ToJson, @json.FromJson)

///|
fn user_message_with_text(text : String) -> Message {
  Message::{
    role: "user",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
  }
}



///|
async fn generate(request : Request) -> Response {
  let (response, body) = @http.post("\{base_url}", request.to_json(), headers={
    "Authorization": "Bearer \{api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
fn extract_text_from_content(content : Json) -> String {
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
async fn chat(model : String, messages : Array[Message]) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
  }
  let response = generate(request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
async fn chat_with_search(model : String, messages : Array[Message]) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: Some(true),
  }
  let response = generate(request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
fn get_current_weather(location : String) -> String {
  let weather_conditions : Array[String] = ["晴天", "多云", "雨天"]
  let index = location.length() % weather_conditions.length()
  let random_weather = weather_conditions[index]
  "\{location}今天是\{random_weather}。"
}

///|
async fn chat_stream(
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
  let (response, body) = @http.post("\{base_url}", request.to_json(), headers={
    "Authorization": "Bearer \{api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  body_text
}

///|
fn system_message(text : String) -> Message {
  Message::{
    role: "system",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
  }
}

///|
async fn main {
  println("=== 联网搜索演示 ===")
  let user_question = "杭州明天天气如何"
  let messages : Array[Message] = [
    system_message("You are a helpful assistant."),
    user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")
  println("正在使用联网搜索...")
  let response = chat_with_search("qwen-plus", messages)
  println("助手: \{extract_text_from_content(response.content)}")
}
