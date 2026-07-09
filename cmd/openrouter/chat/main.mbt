///|
/// 简单对话示例（OpenRouter）
///
/// 运行命令: moon run cmd/openrouter/chat
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
  let mock_body = @lib.read_file("cmd/openrouter/chat/mocks/response.json")
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "What color is the sky?"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  let response = @lib.chat(config, "tencent/hy3:free", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
