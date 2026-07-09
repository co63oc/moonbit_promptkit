///|
/// 流式输出示例（OpenRouter）
///
/// 运行命令: moon run cmd/openrouter/stream
/// 接口文档: https://openrouter.ai/docs/api-reference/chat-completion
///
/// 环境变量要求:
/// - OPENROUTER_API_KEY: OpenRouter API Key
/// - OPENROUTER_BASE_URL: API Base URL（默认: https://openrouter.ai/api/v1）
///

///|
async fn main {
  let api_key = @lib.get_env_var("OPENROUTER_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "OPENROUTER_BASE_URL",
    Some("https://openrouter.ai/api/v1"),
  )
  // 从文件读取 mock 数据
  let mock_body = @lib.read_file("cmd/openrouter/stream/mocks/response.txt")
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "What is the history of AI?"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  println("Assistant: ")
  let full_text = @lib.chat_stream(
    config,
    "tencent/hy3:free",
    messages,
    fn(text) { println(text) },
  )
  println("\n\nFull reply length: \{full_text.length()} chars")
}
