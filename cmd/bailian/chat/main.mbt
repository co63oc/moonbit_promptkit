///|
/// 简单对话示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/chat
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
/// - BAILIAN_MODEL: 使用的模型（默认: qwen3.7-plus）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
pub let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen3.7-plus"))

///|
async fn main {
  let messages = [@lib.user_message_with_text("你好!")]
  let response = @lib.chat(config, model, messages)
  println(response.to_json().stringify())
}
