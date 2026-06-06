///|
/// Kimi (Moonshot AI) chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONSHOT_API_KEY",
  "MOONSHOT_BASE_URL",
  "https://api.moonshot.cn/v1",
)

///|
async fn main {
  let user_question = "你好，请介绍一下你自己"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  // 使用 Kimi 模型
  let response = @lib.chat(config, "kimi-latest", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
