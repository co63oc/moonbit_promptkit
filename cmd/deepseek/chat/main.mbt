///|
/// 简单对话示例（DeepSeek）
///
/// 运行命令: moon run cmd/deepseek/chat
/// 接口文档: https://api-docs.deepseek.com/zh-cn/api/create-chat-completion
///
/// 环境变量要求:
/// - DEEPSEEK_API_KEY: DeepSeek API Key
/// - DEEPSEEK_BASE_URL: API Base URL（默认: https://api.deepseek.com）
///

///|
let mock_body = "{\"model\":\"deepseek-chat\",\"choices\":[{\"message\":{\"content\":\"你好！我是 DeepSeek-V3，一个高性能的开源大语言模型。我擅长数学、编程和自然语言理解，同时具备极高的性价比。有什么我可以帮助你的吗？\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("DEEPSEEK_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "DEEPSEEK_BASE_URL",
    Some("https://api.deepseek.com"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "你好，请介绍一下你自己"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  let response = @lib.chat(config, "deepseek-chat", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
