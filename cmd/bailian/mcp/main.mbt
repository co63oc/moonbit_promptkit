///|
/// MCP 集成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/mcp
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
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
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text("北京今天天气怎么样？"),
  ]

  try {
    let result = @lib_mcp.chat_with_mcp(config, "qwen3.7-plus", messages, [
      weather_tool,
    ])
    println("模型回复: \{result}")
  } catch {
    e => println("MCP 对话失败: \{e}")
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
