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
fn text_content(text : String) -> Content {
  Content::{ type_: "text", text: Some(text), image_url: None }
}

///|
fn image_content(url : String) -> Content {
  Content::{
    type_: "image_url",
    text: None,
    image_url: Some(ImageUrl::{ url, }),
  }
}

///|
fn user_message_with_text(text : String) -> Message {
  Message::{ role: "user", content: text.to_json() }
}

///|
fn user_message_with_contents(contents : Array[Content]) -> Message {
  Message::{ role: "user", content: contents.to_json() }
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
fn parse_sse_data(line : String) -> String? {
  if line.has_prefix("data: ") {
    Some(line[6:].to_owned())
  } else {
    None
  }
}

///|
fn process_stream_response(
  body_text : String,
  on_delta : (String) -> Unit,
) -> String {
  body_text
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
async fn main {
  println("=== 演示1：流式输出（图片理解）===")
  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20241022/emyrja/dog_and_girl.jpeg"
  let messages1 : Array[Message] = [
    user_message_with_contents([
      image_content(image_url),
      text_content("图中描绘的是什么景象？"),
    ]),
  ]
  println("用户: 图中描绘的是什么景象？")
  println("助手: ")
  let full_text1 = chat_stream("qwen3-vl-plus", messages1, fn(text) {
    println(text)
  })
  println("完整回复: \{full_text1}")

  println("\n=== 演示2：流式输出（纯文本对话）===")
  let messages2 : Array[Message] = [
    user_message_with_text(
      "请用3句话介绍一下人工智能的发展历史",
    ),
  ]
  println("用户: 请用3句话介绍一下人工智能的发展历史")
  println("助手: ")
  let full_text2 = chat_stream("qwen3.6-plus", messages2, fn(text) {
    println(text)
  })
  println("完整回复: \{full_text2}")

  println("\n=== 演示3：非流式输出 ===")
  let messages3 : Array[Message] = [
    user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  println("用户: 你好，请简单介绍一下你自己")
  let response3 = chat("qwen3.6-plus", messages3)
  println("助手: \{extract_text_from_content(response3.content)}")
}
