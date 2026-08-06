///|
/// 简单对话示例（讯飞星火）
///
/// 运行命令: moon run cmd/spark/chat
/// 接口文档: https://www.xfyun.cn/doc/spark/HTTP%E8%B0%83%E7%94%A8%E6%96%87%E6%A1%A3.html
///
/// 环境变量要求:
/// - SPARK_API_KEY: 讯飞星火 APIPassword
/// - SPARK_BASE_URL: API Base URL（默认: https://spark-api-open.xf-yun.com/v1）
///

///|
let mock_body = "{\"model\":\"generalv3.5\",\"choices\":[{\"message\":{\"content\":\"你好！我是讯飞星火认知大模型，由科大讯飞研发。我擅长中文理解、知识问答、逻辑推理和代码生成等任务，在教育、办公等场景有广泛应用。有什么我可以帮助你的吗？\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("SPARK_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "SPARK_BASE_URL",
    Some("https://spark-api-open.xf-yun.com/v1"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "你好，请介绍一下你自己"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  let response = @lib.chat(config, "generalv3.5", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
