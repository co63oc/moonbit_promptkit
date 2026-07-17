///|
/// Types for image generation APIs
///

///|
/// Text content item for multimodal-generation messages
pub struct TextContent {
  text : String
} derive(ToJson)

///|
pub extend TextContent with ToJson::{to_json}

///|
/// Message for multimodal-generation requests
pub struct ImageGenMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
pub extend ImageGenMessage with ToJson::{to_json}

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
pub extend SyncImageGenParams with ToJson::{to_json}

///|
/// Input for sync image generation
pub struct SyncImageGenInput {
  messages : Array[ImageGenMessage]
} derive(ToJson)

///|
pub extend SyncImageGenInput with ToJson::{to_json}

///|
/// Full request for sync image generation (multimodal-generation)
pub struct SyncImageGenRequest {
  model : String
  input : SyncImageGenInput
  parameters : SyncImageGenParams?
} derive(ToJson)

///|
pub extend SyncImageGenRequest with ToJson::{to_json}

///|
/// Input for async text2image tasks
pub struct AsyncImageGenInput {
  prompt : String
  negative_prompt : String?
  style : String?
} derive(ToJson)

///|
pub extend AsyncImageGenInput with ToJson::{to_json}

///|
/// Parameters for async text2image tasks
pub struct AsyncImageGenParams {
  n : Int?
  size : String?
} derive(ToJson)

///|
pub extend AsyncImageGenParams with ToJson::{to_json}

///|
/// Full request for async text2image tasks
pub struct AsyncImageGenRequest {
  model : String
  input : AsyncImageGenInput
  parameters : AsyncImageGenParams?
} derive(ToJson)

///|
pub extend AsyncImageGenRequest with ToJson::{to_json}

///|
/// Sync response: single image content in message
pub struct ImageContent {
  image : String?
  type_ : String?
} derive(Debug, @json.FromJson)

///|
pub extend ImageContent with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageContent with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Sync response: message
pub struct ImageMessage {
  role : String?
  content : Array[ImageContent]
} derive(Debug, @json.FromJson)

///|
pub extend ImageMessage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageMessage with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Sync response: choice
pub struct ImageChoice {
  finish_reason : String?
  message : ImageMessage
} derive(Debug, @json.FromJson)

///|
pub extend ImageChoice with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageChoice with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Sync response: output
pub struct ImageGenOutput {
  choices : Array[ImageChoice]?
  task_id : String?
  task_status : String?
  finished : Bool?
} derive(Debug, @json.FromJson)

///|
pub extend ImageGenOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenOutput with @moonbitlang/core/json.FromJson::{from_json}

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
pub extend ImageGenUsage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenUsage with @moonbitlang/core/json.FromJson::{from_json}

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
pub extend ImageGenResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Async task creation response
pub struct AsyncTaskResponse {
  request_id : String?
  output : Json
  usage : Json?
} derive(Debug, @json.FromJson)

///|
pub extend AsyncTaskResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AsyncTaskResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Async task query response
pub struct AsyncTaskResult {
  request_id : String?
  output : Json
  usage : Json?
} derive(Debug, @json.FromJson)

///|
pub extend AsyncTaskResult with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AsyncTaskResult with @moonbitlang/core/debug.Debug::{to_repr}
