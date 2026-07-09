///|
/// MCP 集成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/mcp
/// 接口文档: https://help.aliyun.com/zh/model-studio/mcp
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
/// 模拟天气查询工具
fn get_weather(city : String) -> String {
  "{\"city\": \"\{city}\", \"temperature\": \"25°C\", \"condition\": \"晴朗\", \"humidity\": \"45%\", \"wind\": \"东北风3级\"}"
}

///|
async fn main {
  let mock_body1 = @lib.read_file("cmd/bailian/mcp/mocks/demo1.json")
  let mock_body2 = @lib.read_file("cmd/bailian/mcp/mocks/demo2.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body1),
  )

  println("=== MCP (Model Context Protocol) 示例 ===\n")

  // 定义一个简单的 MCP 工具
  let weather_tool = @lib_mcp.mcp_tool(
    "get_weather",
    "获取指定城市的天气信息",
    Json::object(
      Map::Map(
        [
          ("type", Json::string("object")),
          (
            "properties",
            Json::object(
              Map::Map(
                [
                  (
                    "city",
                    Json::object(
                      Map::Map(
                        [
                          ("type", Json::string("string")),
                          ("description", Json::string("城市名称")),
                        ].view(),
                      ),
                    ),
                  ),
                ].view(),
              ),
            ),
          ),
          ("required", Json::array([Json::string("city")])),
        ].view(),
      ),
    ),
  )

  // Demo 1: 使用 MCP 工具进行对话
  println("--- Demo 1: 使用 MCP 工具 ---")
  let user_question = "北京今天天气怎么样？"
  println("用户: \{user_question}")

  let mut messages : Array[@lib.Message] = [
    @lib.user_message_with_text(user_question),
  ]

  // 第一次调用：模型决定调用工具
  let mut response = @lib_mcp.chat_with_mcp(config, "qwen3.7-plus", messages, [
    weather_tool,
  ])
  messages = messages + [response]

  match response.tool_calls {
    None =>
      println(
        "无需调用工具，直接回复：\{@lib.extract_text_from_content(response.content)}",
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

              // 解析参数并调用工具
              let city = "北京"
              let tool_result = get_weather(city)
              println("工具返回：\{tool_result}")

              messages = messages +
                [@lib.tool_message(tool_call_id, tool_result)]

              // 第二次调用使用 demo2.json（最终回复，无 tool_calls）
              let config2 : @lib.ClientConfig = @lib.make_client_config(
                api_key,
                base_url,
                mock_body=Some(mock_body2),
              )
              response = @lib_mcp.chat_with_mcp(
                config2,
                "qwen3.7-plus",
                messages,
                [weather_tool],
              )
              messages = messages + [response]
            } else {
              continue_loop = false
            }
        }
      }
      println(
        "模型最终回复：\{@lib.extract_text_from_content(response.content)}",
      )
    }
  }
  println("")

  println("=== 提示 ===")
  println("MCP (Model Context Protocol) 允许模型调用外部工具:")
  println("  - 定义工具函数和参数")
  println("  - 模型可以识别并调用工具")
  println("  - 支持复杂的参数结构和多工具组合")
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
