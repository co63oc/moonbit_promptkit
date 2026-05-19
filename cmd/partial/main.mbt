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
struct StreamChoice {
  delta : Message
} derive(Debug, ToJson, @json.FromJson)

///|
struct StreamResponse {
  choices : Array[StreamChoice]
  usage : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
fn user_message_with_text(text : String) -> Message {
  Message::{ role: "user", content: text.to_json(), partial: None }
}

///|
fn assistant_message_partial(text : String) -> Message {
  Message::{ role: "assistant", content: text.to_json(), partial: Some(true) }
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
  let request = Request::{ model, messages, stream: None, stream_options: None }
  let response = generate(request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
async fn main {
  println("=== 前缀续写（代码补全）===")
  let partial_code = "def calculate_fibonacci(n):\\n    if n <= 1:\\n        return n\\n    else:\\n"
  let messages : Array[Message] = [
    user_message_with_text(
      "请补全这个斐波那契函数，勿添加其它内容",
    ),
    assistant_message_partial(partial_code),
  ]
  println("用户: 请补全这个斐波那契函数，勿添加其它内容")
  println("前缀: ")
  println(partial_code)
  println("补全结果: ")
  let response = chat("qwen3-coder-plus", messages)
  println(extract_text_from_content(response.content))
}
