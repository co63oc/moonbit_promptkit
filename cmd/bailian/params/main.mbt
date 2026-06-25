///|
/// 自定义参数示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/params
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
  println("=== 自定义参数示例 ===")

  // Demo 1: 低温度 - 更确定性的回答
  println("\n--- Demo 1: 低温度 (temperature=0.3) ---")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text("请用一句话描述Python语言的特点"),
  ]
  let response1 = @lib.chat_with_params(
    config,
    model,
    messages1,
    Some(0.3),
    None,
    Some(100),
    None,
  )
  println("Assistant: \{@lib.extract_text_from_content(response1.content)}")

  // Demo 2: 高温度 + top_p - 更随机的回答
  println("\n--- Demo 2: 高温度 (temperature=0.9, top_p=0.8) ---")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("请用一句话描述Python语言的特点"),
  ]
  let response2 = @lib.chat_with_params(
    config,
    model,
    messages2,
    Some(0.9),
    Some(0.8),
    Some(100),
    None,
  )
  println("Assistant: \{@lib.extract_text_from_content(response2.content)}")

  // Demo 3: 固定 seed - 可复现的回答
  println("\n--- Demo 3: 固定 seed (seed=42) ---")
  let messages3 : Array[@lib.Message] = [
    @lib.user_message_with_text("请用一句话描述Python语言的特点"),
  ]
  let response3 = @lib.chat_with_params(
    config,
    model,
    messages3,
    Some(0.5),
    None,
    Some(100),
    Some(42),
  )
  println("Assistant: \{@lib.extract_text_from_content(response3.content)}")
}
