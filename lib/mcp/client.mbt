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
pub fn mcp_tool(
  name : String,
  description : String,
  parameters : Json,
) -> McpTool {
  let function = McpFunction::{ name, description, parameters }
  { type_: "function", function }
}

///|
/// Chat with MCP tools
/// Returns the model's response message (which may contain tool_calls)
pub async fn chat_with_mcp(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
  tools : Array[McpTool],
) -> @lib.Message {
  let request = McpRequest::{
    model,
    messages,
    tools,
    stream: None,
    stream_options: None,
  }

  let url = "\{config.base_url}/chat/completions"

  // Mock mode: when api_key is empty and mock_body is configured,
  // return the canned response without making a real HTTP call.
  let body_text = match @lib.try_mock(config) {
    Some(mock) => mock
    None => {
      let (response, body) = @http.post(url, request.to_json(), headers={
        "Authorization": "Bearer \{config.api_key}",
        "Content-Type": "application/json",
      })
      guard response.code is (200..=299) else {
        let error_text = body.text()
        fail(
          "MCP chat request failed: \{response.code} \{response.reason}\n\{error_text}",
        )
      }
      body.text()
    }
  }

  let resp : @lib.Response = @json.parse(body_text) |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No response from model")
  } else {
    resp.choices[0].message
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
