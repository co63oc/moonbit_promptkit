///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.

///|
let env : Map[String, String] = @sys.get_env_vars()

///|
fn get_env_var(name : String) -> String {
  guard env.get(name) is Some(value) else {
    println("Please set \{name} environment variable")
    panic()
  }
  value
}

///|
let api_key : String = get_env_var("MOONBIT_API_KEY")

///|
let base_url : String = get_env_var("MOONBIT_BASE_URL")

///|
let model : String = get_env_var("MOONBIT_MODEL")

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
  messages : Array[Json]
  tools : Array[String] // 在下一节中定义
} derive(ToJson)

///|
struct Choice {
  message : Json
} derive(ToJson, @json.FromJson)

///|
struct Response {
  choices : Array[Choice]
} derive(ToJson, @json.FromJson)

///|
async fn generate(request : Request) -> Response {
  let (response, body) = @http.post(
    "\{base_url}",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{api_key}",
      "Content-Type": "application/json",
      //"Connection": "close",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
async fn main {
  let request = Request::{
    model,
    messages: [{ "role": "user", "content": "你好!" }],
    tools: [],
  }
  println(generate(request).to_json().stringify(indent=2))
}
