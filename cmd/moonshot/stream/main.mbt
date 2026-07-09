///|
/// 流式输出示例（Moonshot）
///
/// 运行命令: moon run cmd/moonshot/stream
/// 接口文档: https://platform.moonshot.cn/docs/api/chat
///
/// 环境变量要求:
/// - MOONSHOT_API_KEY: Moonshot AI API Key
/// - MOONSHOT_BASE_URL: API Base URL（默认: https://api.moonshot.cn/v1）
///

///|
let mock_body = "data: {\"choices\":[{\"delta\":{\"content\":\"人工智能的发展历史可以概括为三个阶段：\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"content\":\"第一阶段是1950-1970年代的诞生与早期探索，\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"content\":\"图灵测试和达特茅斯会议开启了AI研究；\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"content\":\"第二阶段是1980年代专家系统的兴起；\"},\"index\":0}]}\n\ndata: {\"choices\":[{\"delta\":{\"content\":\"第三阶段是2010年代至今的深度学习革命，大数据和GPU算力推动AI爆发式发展。\"},\"index\":0}]}\n\ndata: [DONE]\n\n"

///|
async fn main {
  let api_key = @lib.get_env_var("MOONSHOT_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "MOONSHOT_BASE_URL",
    Some("https://api.moonshot.cn/v1"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  println("=== 演示1：流式输出 ===")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "请用3句话介绍一下人工智能的发展历史",
    ),
  ]
  println("User: 请用3句话介绍一下人工智能的发展历史")
  println("Assistant: ")
  let full_text1 = @lib.chat_stream(config, "kimi-latest", messages1, fn(text) {
    println(text)
  })
  println("\nFull reply: \{full_text1}")

  println("\n=== 演示2：非流式输出 ===")
  if api_key != "" {
    let messages2 : Array[@lib.Message] = [
      @lib.user_message_with_text("你好，请简单介绍一下你自己"),
    ]
    println("User: 你好，请简单介绍一下你自己")
    let response2 = @lib.chat(config, "kimi-latest", messages2)
    println("Assistant: \{@lib.extract_text_from_content(response2.content)}")
  } else {
    println("(非流式 Demo 需要有效的 API Key，跳过)")
  }
}
