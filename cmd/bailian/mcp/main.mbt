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
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
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
