///|
/// Entry point for tokenhub chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "HUNYUAN_API_KEY",
  "HUNYUAN_BASE_URL",
  "https://tokenhub.tencentmaas.com/v1",
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
