///|
/// 简单对话示例（智谱AI GLM）
///
/// 运行命令: moon run cmd/zhipu/chat
/// 接口文档: https://open.bigmodel.cn/dev/api/normal-model/glm-4
///
/// 环境变量要求:
/// - ZHIPU_API_KEY: 智谱AI API Key
/// - ZHIPU_BASE_URL: API Base URL（默认: https://open.bigmodel.cn/api/paas/v4）
///

///|
let mock_body = "{\"model\":\"glm-4\",\"choices\":[{\"message\":{\"content\":\"你好！我是智谱AI开发的 GLM-4 大语言模型。我擅长中文理解、知识问答、逻辑推理和代码生成等任务。有什么我可以帮助你的吗？\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("ZHIPU_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "ZHIPU_BASE_URL",
    Some("https://open.bigmodel.cn/api/paas/v4"),
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
  let response = @lib.chat(config, "glm-4", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
