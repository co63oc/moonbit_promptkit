///|
/// Search enabled chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 联网搜索演示===")
  let user_question = "杭州明天天气如何"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")
  println("正在使用联网搜索...")
  let response = @lib.chat_with_search(config, "qwen-plus", messages)
  println("助手: \{@lib.extract_text_from_content(response.content)}")
}
