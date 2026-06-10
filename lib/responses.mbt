///|
/// Responses API types and client functions
/// 用于支持文搜图、图搜图等仅支持 Responses API 的接口
///

///|
/// Response API - Tool definition
pub struct ResponseTool {
  type_ : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Response API - Input text content
pub struct InputText {
  type_ : String
  text : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Response API - Input image content
pub struct InputImage {
  type_ : String
  image_url : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Response API - Input audio content
pub struct InputAudio {
  type_ : String
  audio_url : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Response API - Input video content
pub struct InputVideo {
  type_ : String
  video_url : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Response API - Input content item (union type simulation)
pub enum InputContent {
  Text(InputText)
  Image(InputImage)
  Audio(InputAudio)
  Video(InputVideo)
}

impl ToJson for InputContent with fn to_json(self : InputContent) -> Json {
  match self {
    Text(t) => t.to_json()
    Image(i) => i.to_json()
    Audio(a) => a.to_json()
    Video(v) => v.to_json()
  }
}

///|
/// Response API - Input message
pub struct ResponseInputMessage {
  role : String
  content : Array[InputContent]
}

impl ToJson for ResponseInputMessage with fn to_json(self : ResponseInputMessage) -> Json {
  let content_json = self.content.map(fn(c) { c.to_json() })
  Json::object({
    "role": Json::string(self.role),
    "content": Json::array(content_json),
  })
}

///|
/// Response API - Request body
pub struct ResponsesRequest {
  model : String
  input : Array[ResponseInputMessage]
  tools : Array[ResponseTool]?
  stream : Bool?
} derive(ToJson)

///|
/// Response API - Output item
pub struct ResponseOutputItem {
  type_ : String?
  status : String?
  output : String?
  content : Json?
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
/// Response API - Usage x_tools info
pub struct XToolsInfo {
  count : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Response API - Usage
pub struct ResponsesUsage {
  input_tokens : Int?
  output_tokens : Int?
  total_tokens : Int?
  x_tools : Map[String, XToolsInfo]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Response API - Response
pub struct ResponsesResponse {
  output : Array[ResponseOutputItem]
  output_text : String?
  usage : ResponsesUsage?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Create a web_search_image tool
pub fn web_search_image_tool() -> ResponseTool {
  ResponseTool::{ type_: "web_search_image" }
}

///|
/// Create an image_search tool
pub fn image_search_tool() -> ResponseTool {
  ResponseTool::{ type_: "image_search" }
}

///|
/// Create a file_search tool
pub fn file_search_tool() -> ResponseTool {
  ResponseTool::{ type_: "file_search" }
}

///|
/// Create a response input message
pub fn response_message(role : String, content : Array[InputContent]) -> ResponseInputMessage {
  ResponseInputMessage::{ role, content }
}

///|
/// Create input text content
pub fn input_text(text : String) -> InputContent {
  InputContent::Text(InputText::{ type_: "input_text", text })
}

///|
/// Create input image content
pub fn input_image(image_url : String) -> InputContent {
  InputContent::Image(InputImage::{ type_: "input_image", image_url })
}

///|
/// Create input audio content
pub fn input_audio(audio_url : String) -> InputContent {
  InputContent::Audio(InputAudio::{ type_: "input_audio", audio_url })
}

///|
/// Create input video content
pub fn input_video(video_url : String) -> InputContent {
  InputContent::Video(InputVideo::{ type_: "input_video", video_url })
}

///|
/// Build input content array to JSON
pub fn build_input_content(contents : Array[InputContent]) -> Json {
  let json_array = contents.map(fn(c) { c.to_json() })
  Json::array(json_array)
}

///|
/// Build input messages array
pub fn build_input_messages(messages : Array[ResponseInputMessage]) -> Json {
  let json_array = messages.map(fn(m) { m.to_json() })
  Json::array(json_array)
}

///|
/// Call Responses API (non-streaming)
pub async fn responses_create(
  config : ClientConfig,
  model : String,
  input : Array[ResponseInputMessage],
  tools : Array[ResponseTool]?,
) -> ResponsesResponse {
  let request = ResponsesRequest::{
    model,
    input,
    tools,
    stream: Some(false),
  }
  let (response, body) = @http.post(
    "\{config.base_url}/responses",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Web search image (文搜图) - search images by text description
pub async fn web_search_image(
  config : ClientConfig,
  model : String,
  query : String,
) -> ResponsesResponse {
  let messages = [
    ResponseInputMessage::{
      role: "user",
      content: [input_text(query)],
    }
  ]
  responses_create(config, model, messages, Some([web_search_image_tool()]))
}

///|
/// Image search (图搜图) - search similar images by image
pub async fn image_search(
  config : ClientConfig,
  model : String,
  image_url : String,
  query : String?,
) -> ResponsesResponse {
  let contents : Array[InputContent] = []
  match query {
    Some(text) => contents.push(input_text(text))
    None => ignore(())
  }
  contents.push(input_image(image_url))
  
  let messages = [
    ResponseInputMessage::{
      role: "user",
      content: contents,
    }
  ]
  responses_create(config, model, messages, Some([image_search_tool()]))
}

///|
/// Extract web search image call results from response
pub fn extract_web_search_images(response : ResponsesResponse) -> Array[Json] {
  let results : Array[Json] = []
  for item in response.output {
    match item.output {
      Some(output_str) => {
        try {
          let parsed = @json.parse(output_str)
          match parsed {
            Json::Array(arr) => for x in arr { results.push(x) }
            _ => ignore(())
          }
        } catch {
          _ => ignore(())
        }
      }
      None => ignore(())
    }
  }
  results
}

///|
/// Extract image search results from response
pub fn extract_image_search_results(response : ResponsesResponse) -> Array[Json] {
  let results : Array[Json] = []
  for item in response.output {
    match item.output {
      Some(output_str) => {
        try {
          let parsed = @json.parse(output_str)
          match parsed {
            Json::Array(arr) => for x in arr { results.push(x) }
            _ => ignore(())
          }
        } catch {
          _ => ignore(())
        }
      }
      None => ignore(())
    }
  }
  results
}
