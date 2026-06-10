///|
/// Types for image generation APIs
///

///|
/// Text content item for multimodal-generation messages
pub struct TextContent {
  text : String
} derive(ToJson)

///|
/// Message for multimodal-generation requests
pub struct ImageGenMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
/// Parameters for sync image generation (multimodal-generation endpoint)
pub struct SyncImageGenParams {
  n : Int?
  size : String?
  negative_prompt : String?
  watermark : Bool?
  prompt_extend : Bool?
} derive(ToJson)

///|
/// Input for sync image generation
pub struct SyncImageGenInput {
  messages : Array[ImageGenMessage]
} derive(ToJson)

///|
/// Full request for sync image generation (multimodal-generation)
pub struct SyncImageGenRequest {
  model : String
  input : SyncImageGenInput
  parameters : SyncImageGenParams?
} derive(ToJson)

///|
/// Input for async text2image tasks
pub struct AsyncImageGenInput {
  prompt : String
  negative_prompt : String?
  style : String?
} derive(ToJson)

///|
/// Parameters for async text2image tasks
pub struct AsyncImageGenParams {
  n : Int?
  size : String?
} derive(ToJson)

///|
/// Full request for async text2image tasks
pub struct AsyncImageGenRequest {
  model : String
  input : AsyncImageGenInput
  parameters : AsyncImageGenParams?
} derive(ToJson)

///|
/// Sync response: single image content in message
pub struct ImageContent {
  image : String?
  type_ : String?
} derive(Debug, @json.FromJson)

///|
/// Sync response: message
pub struct ImageMessage {
  role : String?
  content : Array[ImageContent]
} derive(Debug, @json.FromJson)

///|
/// Sync response: choice
pub struct ImageChoice {
  finish_reason : String?
  message : ImageMessage
} derive(Debug, @json.FromJson)

///|
/// Sync response: output
pub struct ImageGenOutput {
  choices : Array[ImageChoice]?
  task_id : String?
  task_status : String?
  finished : Bool?
} derive(Debug, @json.FromJson)

///|
/// Sync response: usage
pub struct ImageGenUsage {
  image_count : Int?
  size : String?
  input_tokens : Int?
  output_tokens : Int?
  total_tokens : Int?
} derive(Debug, @json.FromJson)

///|
/// Sync response
pub struct ImageGenResponse {
  request_id : String?
  output : ImageGenOutput
  usage : ImageGenUsage?
  code : String?
  message : String?
} derive(Debug, @json.FromJson)

///|
/// Async task creation response
pub struct AsyncTaskResponse {
  request_id : String?
  output : Json
  usage : Json?
} derive(Debug, @json.FromJson)

///|
/// Async task query response
pub struct AsyncTaskResult {
  request_id : String?
  output : Json
  usage : Json?
} derive(Debug, @json.FromJson)
