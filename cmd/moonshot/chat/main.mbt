///|
/// 简单对话示例（Moonshot）
///
/// 运行命令: moon run cmd/moonshot/chat
/// 接口文档: https://platform.moonshot.cn/docs/api/chat
///
/// 环境变量要求:
/// - MOONSHOT_API_KEY: Moonshot AI API Key
/// - MOONSHOT_BASE_URL: API Base URL（默认: https://api.moonshot.cn/v1）
///

///|
let mock_body = "{\"model\":\"kimi-latest\",\"choices\":[{\"message\":{\"content\":\"你好！我是Kimi，由Moonshot AI开发的智能助手。我能回答问题、创作文字、编程、处理长文档，支持超长上下文（最高128k）。有什么我可以帮助你的吗？😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("MOONSHOT_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "MOONSHOT_BASE_URL",
    Some("https://api.moonshot.cn/v1"),
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
  let response = @lib.chat(config, "kimi-latest", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
