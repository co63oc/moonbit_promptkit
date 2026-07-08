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
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
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
  let response3 = @lib.chat(config, "qwen3.7-plus", messages2)
  println("用户: 你好，请简单介绍一下你自己")
  println("助手: \{@lib.extract_text_from_content(response3.content)}")

  println("\n=== 完整对话历史===")
  println(messages.to_json().stringify())
}
