///|
/// 流式输出示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/stream
/// 接口文档: https://help.aliyun.com/zh/model-studio/stream
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
let mock_body = "data: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null,\"choices\":[{\"logprobs\":null,\"index\":0,\"delta\":{\"content\":\"\",\"role\":\"assistant\"},\"finish_reason\":null}]}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"你好\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"！我是通\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"义千问\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"（Qwen\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"），阿里巴巴集团旗下的超\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"大规模语言模型，能够回答\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"问题、创作文字（\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"如写故事、公\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"文、邮件、剧本等\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"）、进行逻辑推理、\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"编程，还能表达观点，\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"甚至玩游戏，支持\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"多种语言，随时\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"为你提供帮助！\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"😊\"},\"index\":0,\"finish_reason\":null,\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[{\"delta\":{\"content\":\"\"},\"index\":0,\"finish_reason\":\"stop\",\"logprobs\":null}],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":null}\n\ndata: {\"model\":\"qwen-plus\",\"id\":\"chatcmpl-ef2163be-c382-9eea-bb28-776f62d453d5\",\"choices\":[],\"created\":1783500960,\"object\":\"chat.completion.chunk\",\"usage\":{\"total_tokens\":77,\"completion_tokens\":61,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}\n\ndata: [DONE]\n\n"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
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
  let full_text2 = @lib.chat_stream(config, "qwen3.7-plus", messages2, fn(
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
  let response3 = @lib.chat(config, "qwen3.7-plus", messages3)
  println("助手: \{@lib.extract_text_from_content(response3.content)}")
}
