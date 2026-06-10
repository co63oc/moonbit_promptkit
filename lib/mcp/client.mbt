///|
/// MCP (Model Context Protocol) API
/// MCP 集成 - 模型上下文协议
/// Endpoint: /chat/completions (OpenAI compatible)
///

///|
/// MCP tool definition
pub struct McpTool {
  type_ : String
  function : McpFunction
} derive(ToJson(fields(type_(rename="type"))))

///|
/// MCP function definition
pub struct McpFunction {
  name : String
  description : String
  parameters : Json
} derive(ToJson)

///|
/// Create an MCP tool
pub fn mcp_tool(name : String, description : String, parameters : Json) -> McpTool {
  let function = McpFunction::{ name, description, parameters }
  McpTool::{ type_: "function", function }
}

///|
/// Chat with MCP tools
pub async fn chat_with_mcp(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
  tools : Array[McpTool],
) -> String {
  let request = McpRequest::{
    model,
    messages,
    tools,
    stream: None,
    stream_options: None,
  }

  let url = "\{config.base_url}/chat/completions"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "MCP chat request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No response from model")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}

///|
/// MCP request structure
struct McpRequest {
  model : String
  messages : Array[@lib.Message]
  tools : Array[McpTool]
  stream : Bool?
  stream_options : @lib.StreamOptions?
} derive(ToJson)
