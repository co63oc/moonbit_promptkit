///|
/// 深度思考示例（DeepSeek-R1）
///
/// 运行命令: moon run cmd/deepseek/thinking
/// 接口文档: https://api-docs.deepseek.com/zh-cn/guides/reasoning_model
///
/// 环境变量要求:
/// - DEEPSEEK_API_KEY: DeepSeek API Key
/// - DEEPSEEK_BASE_URL: API Base URL（默认: https://api.deepseek.com）
///

///|
let mock_body = "data: {\"choices\":[{\"delta\":{\"reasoning_content\":\"让我来分析这个问题。首先需要理解题意，然后逐步推导。\",\"content\":\"\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"reasoning_content\":\"假设 n=5，我们可以列举所有情况...\",\"content\":\"\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"reasoning_content\":\"\",\"content\":\"经过分析，答案是：\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"reasoning_content\":\"\",\"content\":\"共有 120 种排列方式。\"},\"index\":0}]}\n\ndata: [DONE]\n\n"

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

  println("=== DeepSeek-R1 深度思考模式 ===")
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "请分析 5! 的所有排列方式有多少种？",
    ),
  ]
  println("User: 请分析 5! 的所有排列方式有多少种？")
  println("")

  let result = @lib.chat_stream_thinking(
    config,
    "deepseek-reasoner",
    messages,
    fn(text) { println(text) },
    fn(text) { println(text) },
  )
  println("\n\n--- 思考过程 ---")
  println(result.reasoning)
  println("\n--- 最终回答 ---")
  println(result.answer)
}
