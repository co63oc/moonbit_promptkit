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
struct Parameters {
  type_ : String
  properties : Map[String, Json]
  required : Array[String]
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
struct FunctionDef {
  name : String
  description : String
  parameters : Parameters
} derive(Debug, ToJson, @json.FromJson)

///|
struct Tool {
  type_ : String
  function : FunctionDef
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
struct Request {
  model : String
  messages : Array[Message]
  stream : Bool?
  stream_options : StreamOptions?
  tools : Json?
  extra_body : Json?
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
  Message::{
    role: "user",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
  }
}

///|
fn user_message_with_contents(contents : Array[Content]) -> Message {
  Message::{
    role: "user",
    content: contents.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
  }
}

///|
fn assistant_message(text : String) -> Message {
  Message::{
    role: "assistant",
    content: text.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: None,
  }
}

///|
fn assistant_message_partial(text : String) -> Message {
  Message::{
    role: "assistant",
    content: text.to_json(),
    partial: Some(true),
    tool_calls: None,
    tool_call_id: None,
  }
}

///|
fn tool_message(tool_call_id : String, content : String) -> Message {
  Message::{
    role: "tool",
    content: content.to_json(),
    partial: None,
    tool_calls: None,
    tool_call_id: Some(tool_call_id),
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
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
  }
  let response = generate(request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
async fn chat_with_tools(
  model : String,
  messages : Array[Message],
  tools : Json,
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: Some(tools),
    extra_body: Some(@json.parse("{\"enable_thinking\": false}")),
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
  let user_question = "北京天气咋样"
  let tools = @json.parse(
    "[{\"type\": \"function\", \"function\": {\"name\": \"get_current_weather\", \"description\": \"当你想查询指定城市的天气时非常有用。\", \"parameters\": {\"type\": \"object\", \"properties\": {\"location\": {\"type\": \"string\", \"description\": \"城市或县区，比如北京市、杭州市、余杭区等。\"}}, \"required\": [\"location\"]}}}]",
  )

  let mut messages : Array[Message] = [user_message_with_text(user_question)]
  println("用户: \{user_question}")

  let mut response = chat_with_tools("qwen3.6-plus", messages, tools)
  messages = messages + [response]

  match response.tool_calls {
    None =>
      println(
        "无需调用天气查询工具，直接回复：\{extract_text_from_content(response.content)}",
      )
    Some(_) => {
      let mut continue_loop = true
      while continue_loop {
        match response.tool_calls {
          None => continue_loop = false
          Some(tool_calls) =>
            if tool_calls.length() > 0 {
              let tool_call = tool_calls[0]
              let tool_call_id = tool_call.id
              let func_name = tool_call.function.name
              let arguments = tool_call.function.arguments
              println(
                "正在调用工具 [\{func_name}]，参数：\{arguments}",
              )
              let location = "北京"
              let tool_result = get_current_weather(location)
              println("工具返回：\{tool_result}")
              messages = messages + [tool_message(tool_call_id, tool_result)]
              response = chat_with_tools("qwen3.6-plus", messages, tools)
              messages = messages + [response]
            } else {
              continue_loop = false
            }
        }
      }
      println(
        "助手最终回复：\{extract_text_from_content(response.content)}",
      )
    }
  }
}
