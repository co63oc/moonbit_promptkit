///|
/// 自定义参数示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/params
/// 接口文档: https://help.aliyun.com/zh/model-studio/text-generation
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
/// - BAILIAN_MODEL: 使用的模型（默认: qwen3.7-plus）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
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
