///|
/// 工具调用示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/tool_call
/// 接口文档: https://help.aliyun.com/zh/model-studio/qwen-function-calling
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
fn get_current_weather(location : String) -> String {
  let weather_conditions : Array[String] = ["晴天", "多云", "雨天"]
  let index = location.length() % weather_conditions.length()
  let random_weather = weather_conditions[index]
  "\{location}今天是\{random_weather}。"
}

///|
async fn main {
  let user_question = "北京天气咋样"
  let tools = @json.parse(
    "[{\"type\": \"function\", \"function\": {\"name\": \"get_current_weather\", \"description\": \"当你想查询指定城市的天气时非常有用。\", \"parameters\": {\"type\": \"object\", \"properties\": {\"location\": {\"type\": \"string\", \"description\": \"城市或县区，比如北京市、杭州市、余杭区等。\"}}, \"required\": [\"location\"]}}}]",
  )

  let mut messages : Array[@lib.Message] = [
    @lib.user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")

  let mut response = @lib.chat_with_tools(
    config, "qwen3.7-plus", messages, tools,
  )
  messages = messages + [response]

  match response.tool_calls {
    None =>
      println(
        "无需调用天气查询工具，直接回复：\{@lib.extract_text_from_content(response.content)}",
      )
    Some(_) => {
      let mut continue_loop = true
      while continue_loop {
        match response.tool_calls {
          None => continue_loop = false
          Some(tool_calls) =>
            if tool_calls.length() > 0 {
              let tool_call = tool_calls[0]
              let tool_call_id = tool_call.id
              let func_name = tool_call.function.name
              let arguments = tool_call.function.arguments
              println(
                "正在调用工具 [\{func_name}]，参数：\{arguments}",
              )
              let location = "北京"
              let tool_result = get_current_weather(location)
              println("工具返回：\{tool_result}")
              messages = messages +
                [@lib.tool_message(tool_call_id, tool_result)]
              response = @lib.chat_with_tools(
                config, "qwen3.7-plus", messages, tools,
              )
              messages = messages + [response]
            } else {
              continue_loop = false
            }
        }
      }
      println(
        "助手最终回复：\{@lib.extract_text_from_content(response.content)}",
      )
    }
  }
}
