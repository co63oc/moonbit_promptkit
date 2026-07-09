///|
/// 多轮对话示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/multi_chat
/// 接口文档: https://help.aliyun.com/zh/model-studio/multi-round-conversation
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
async fn main {
  let mock_body = @lib.read_file("cmd/bailian/multi_chat/mocks/round1.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20251031/ownrof/f26d201b1e3f4e62ab4a1fc82dd5c9bb.png"

  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content("请问图片展现了哪些商品?"),
    ]),
  ]

  println("=== 第一轮对话===")
  println("用户: 请问图片展现了哪些商品?")
  let response1 = if api_key != "" {
    @lib.chat(config, "qwen3-vl-plus", messages)
  } else {
    let mock_resp = @lib.read_file("cmd/bailian/multi_chat/mocks/round1.json")
    let resp : @lib.Response = @json.parse(mock_resp) |> @json.from_json()
    resp.choices[0].message
  }
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
  let response2 = if api_key != "" {
    @lib.chat(config, "qwen3-vl-plus", messages)
  } else {
    let mock_resp = @lib.read_file("cmd/bailian/multi_chat/mocks/round2.json")
    let resp : @lib.Response = @json.parse(mock_resp) |> @json.from_json()
    resp.choices[0].message
  }
  let messages = messages + [response2]
  println("助手: \{@lib.extract_text_from_content(response2.content)}")

  println("\n=== 演示：使用纯文本消息===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  let response3 = if api_key != "" {
    @lib.chat(config, "qwen3.7-plus", messages2)
  } else {
    let mock_resp = @lib.read_file("cmd/bailian/multi_chat/mocks/round3.json")
    let resp : @lib.Response = @json.parse(mock_resp) |> @json.from_json()
    resp.choices[0].message
  }
  println("用户: 你好，请简单介绍一下你自己")
  println("助手: \{@lib.extract_text_from_content(response3.content)}")

  println("\n=== 完整对话历史===")
  println(messages.to_json().stringify())
}
