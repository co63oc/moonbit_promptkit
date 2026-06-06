///|
/// Kimi (Moonshot AI) streaming chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONSHOT_API_KEY",
  "MOONSHOT_BASE_URL",
  "https://api.moonshot.cn/v1",
)

///|
async fn main {
  println("=== 演示1：流式输出 ===")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "请用3句话介绍一下人工智能的发展历史",
    ),
  ]
  println("User: 请用3句话介绍一下人工智能的发展历史")
  println("Assistant: ")
  let full_text1 = @lib.chat_stream(config, "kimi-latest", messages1, fn(
    text,
  ) {
    println(text)
  })
  println("\nFull reply: \{full_text1}")

  println("\n=== 演示2：非流式输出 ===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  println("User: 你好，请简单介绍一下你自己")
  let response2 = @lib.chat(config, "kimi-latest", messages2)
  println("Assistant: \{@lib.extract_text_from_content(response2.content)}")
}
