///|
/// Streaming chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 演示1：流式输出（图片理解）===")
  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20241022/emyrja/dog_and_girl.jpeg"
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content("图中描绘的是什么景象？"),
    ]),
  ]
  println("用户: 图中描绘的是什么景象？")
  println("助手: ")
  let full_text1 = @lib.chat_stream(config, "qwen3-vl-plus", messages1, fn(
    text,
  ) {
    println(text)
  })
  println("完整回复: \{full_text1}")

  println("\n=== 演示2：流式输出（纯文本对话）===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "请用3句话介绍一下人工智能的发展历史",
    ),
  ]
  println("用户: 请用3句话介绍一下人工智能的发展历史")
  println("助手: ")
  let full_text2 = @lib.chat_stream(config, "qwen3.6-plus", messages2, fn(
    text,
  ) {
    println(text)
  })
  println("完整回复: \{full_text2}")

  println("\n=== 演示3：非流式输出 ===")
  let messages3 : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  println("用户: 你好，请简单介绍一下你自己")
  let response3 = @lib.chat(config, "qwen3.6-plus", messages3)
  println("助手: \{@lib.extract_text_from_content(response3.content)}")
}
