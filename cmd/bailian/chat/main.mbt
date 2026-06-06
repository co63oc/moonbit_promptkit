///|
/// Simple chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen3.7-plus"))

///|
async fn main {
  let messages = [@lib.user_message_with_text("你好!")]
  let response = @lib.chat(config, model, messages)
  println(response.to_json().stringify())
}
