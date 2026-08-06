///|
/// 简单对话示例（MiniMax）
///
/// 运行命令: moon run cmd/minimax/chat
/// 接口文档: https://www.minimaxi.com/document/guides/chat-model/pro
///
/// 环境变量要求:
/// - MINIMAX_API_KEY: MiniMax API Key
/// - MINIMAX_BASE_URL: API Base URL（默认: https://api.minimax.chat/v1）
///

///|
let mock_body = "{\"model\":\"MiniMax-M1\",\"choices\":[{\"message\":{\"content\":\"你好！我是 MiniMax-M1，一个擅长长文本处理和角色扮演的大语言模型。我能进行多轮对话、创意写作和知识问答。有什么我可以帮助你的吗？\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("MINIMAX_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "MINIMAX_BASE_URL",
    Some("https://api.minimax.chat/v1"),
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
  let response = @lib.chat(config, "MiniMax-M1", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
