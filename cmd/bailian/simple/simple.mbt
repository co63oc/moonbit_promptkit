///|
/// Simple chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = @lib.get_env_var("MOONBIT_MODEL", Some("qwen3.6-plus"))

///|
async fn main {
  let messages = [@lib.user_message_with_text("你好!")]
  let response = @lib.chat(config, model, messages)
  println(response.to_json().stringify())
}
