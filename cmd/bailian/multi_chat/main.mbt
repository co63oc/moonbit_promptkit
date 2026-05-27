///|
/// Multi-turn chat example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20251031/ownrof/f26d201b1e3f4e62ab4a1fc82dd5c9bb.png"

  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content("请问图片展现了哪些商品?"),
    ]),
  ]

  println("=== 第一轮对话===")
  println("用户: 请问图片展现了哪些商品?")
  let response1 = @lib.chat(config, "qwen3-vl-plus", messages)
  let messages = messages + [response1]
  println("助手: \{@lib.extract_text_from_content(response1.content)}")

  let messages = messages +
    [
      @lib.user_message_with_contents([
        @lib.text_content("它们属于什么风格?"),
      ]),
    ]

  println("\n=== 第二轮对话===")
  println("用户: 它们属于什么风格?")
  let response2 = @lib.chat(config, "qwen3-vl-plus", messages)
  let messages = messages + [response2]
  println("助手: \{@lib.extract_text_from_content(response2.content)}")

  println("\n=== 演示：使用纯文本消息===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  let response3 = @lib.chat(config, "qwen3.6-plus", messages2)
  println("用户: 你好，请简单介绍一下你自己")
  println("助手: \{@lib.extract_text_from_content(response3.content)}")

  println("\n=== 完整对话历史===")
  println(messages.to_json().stringify())
}
