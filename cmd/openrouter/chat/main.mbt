///|
/// OpenRouter chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "OPENROUTER_API_KEY",
  "OPENROUTER_BASE_URL",
  "https://openrouter.ai/api/v1",
)

///|
async fn main {
  let user_question = "What color is the sky?"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  // 使用 OpenRouter 免费模型：Google Gemma 4 31B
  let response = @lib.chat(config, "google/gemma-4-31b-it:free", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
