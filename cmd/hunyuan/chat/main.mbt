///|
/// 简单对话示例（腾讯混元）
///
/// 运行命令: moon run cmd/hunyuan/chat
///
/// 环境变量要求:
/// - HUNYUAN_API_KEY: 腾讯混元 API Key
/// - HUNYUAN_BASE_URL: API Base URL（默认: https://tokenhub.tencentmaas.com/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "HUNYUAN_API_KEY", "HUNYUAN_BASE_URL", "https://tokenhub.tencentmaas.com/v1",
)

///|
async fn main {
  let user_question = "杭州明天天气如何"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")
  let response = @lib.chat(config, "hy3-preview", messages)
  println("助手: \{@lib.extract_text_from_content(response.content)}")
}
