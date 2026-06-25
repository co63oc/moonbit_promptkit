///|
/// 流式输出示例（OpenRouter）
///
/// 运行命令: moon run cmd/openrouter/stream
///
/// 环境变量要求:
/// - OPENROUTER_API_KEY: OpenRouter API Key
/// - OPENROUTER_BASE_URL: API Base URL（默认: https://openrouter.ai/api/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "OPENROUTER_API_KEY", "OPENROUTER_BASE_URL", "https://openrouter.ai/api/v1",
)

///|
async fn main {
  println("=== Demo 1: Streaming output ===")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text("Describe the history of AI in 3 sentences."),
  ]
  println("User: Describe the history of AI in 3 sentences.")
  println("Assistant: ")
  let full_text1 = @lib.chat_stream(
    config,
    "google/gemma-4-31b-it:free",
    messages1,
    fn(text) { println(text) },
  )
  println("\nFull reply: \{full_text1}")

  println("\n=== Demo 2: Non-streaming output ===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("Hello, introduce yourself briefly."),
  ]
  println("User: Hello, introduce yourself briefly.")
  let response2 = @lib.chat(config, "google/gemma-4-31b-it:free", messages2)
  println("Assistant: \{@lib.extract_text_from_content(response2.content)}")
}
