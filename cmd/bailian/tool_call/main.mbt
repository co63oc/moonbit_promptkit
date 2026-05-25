///|
/// Tool calling example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
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
    config, "qwen3.6-plus", messages, tools,
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
                config, "qwen3.6-plus", messages, tools,
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
