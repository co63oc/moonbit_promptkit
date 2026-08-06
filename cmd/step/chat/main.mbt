///|
/// 简单对话示例（阶跃星辰）
///
/// 运行命令: moon run cmd/step/chat
/// 接口文档: https://platform.stepfun.com/docs/reference/overview
///
/// 环境变量要求:
/// - STEP_API_KEY: 阶跃星辰 API Key
/// - STEP_BASE_URL: API Base URL（默认: https://api.stepfun.com/v1）
///

///|
let mock_body = "{\"model\":\"step-2-16k\",\"choices\":[{\"message\":{\"content\":\"你好！我是阶跃星辰开发的 Step-2 大语言模型。我擅长中文理解、知识问答、逻辑推理和代码生成等任务。有什么我可以帮助你的吗？\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}]}"

///|
async fn main {
  let api_key = @lib.get_env_var("STEP_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "STEP_BASE_URL",
    Some("https://api.stepfun.com/v1"),
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
  let response = @lib.chat(config, "step-2-16k", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
