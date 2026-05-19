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
struct Request {
  model : String
  messages : Array[Message]
} derive(ToJson)

///|
struct Choice {
  message : Message
} derive(ToJson, @json.FromJson)

///|
struct Response {
  choices : Array[Choice]
} derive(ToJson, @json.FromJson)

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
async fn chat(model : String, messages : Array[Message]) -> Message {
  let request = Request::{ model, messages }
  let response = generate(request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
async fn main {
  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20251031/ownrof/f26d201b1e3f4e62ab4a1fc82dd5c9bb.png"

  let messages : Array[Message] = [
    user_message_with_contents([
      image_content(image_url),
      text_content("请问图片展现了有哪些商品？"),
    ]),
  ]

  println("=== 第一轮对话 ===")
  println("用户: 请问图片展现了有哪些商品？")
  let response1 = chat("qwen3-vl-plus", messages)
  let messages = messages + [response1]
  println("助手: \{extract_text_from_content(response1.content)}")

  let messages = messages +
    [user_message_with_contents([text_content("它们属于什么风格？")])]

  println("\n=== 第二轮对话 ===")
  println("用户: 它们属于什么风格？")
  let response2 = chat("qwen3-vl-plus", messages)
  let messages = messages + [response2]
  println("助手: \{extract_text_from_content(response2.content)}")

  println("\n=== 演示：使用纯文本消息 ===")
  let messages2 : Array[Message] = [
    user_message_with_text("你好，请介绍一下你自己"),
  ]
  let response3 = chat("qwen3.6-plus", messages2)
  println("用户: 你好，请介绍一下你自己")
  println("助手: \{extract_text_from_content(response3.content)}")

  println("\n=== 完整对话历史 ===")
  println(messages.to_json().stringify(indent=2))
}
