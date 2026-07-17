///|
/// Types for image editing APIs (Qwen Image Edit + Wan Image Edit)
///

///|
/// Text content item
pub struct TextItem {
  text : String
} derive(ToJson)

///|
pub extend TextItem with ToJson::{to_json}

///|
/// Image content item
pub struct ImageItem {
  image : String
} derive(ToJson)

///|
pub extend ImageItem with ToJson::{to_json}

///|
/// Message for image edit requests
pub struct EditMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
pub extend EditMessage with ToJson::{to_json}

///|
/// Parameters for image edit
pub struct EditParams {
  n : Int?
  size : String?
  prompt_extend : Bool?
} derive(ToJson)

///|
pub extend EditParams with ToJson::{to_json}

///|
/// Input for image edit
pub struct EditInput {
  messages : Array[EditMessage]
} derive(ToJson)

///|
pub extend EditInput with ToJson::{to_json}

///|
/// Full request for image edit (multimodal-generation)
pub struct EditRequest {
  model : String
  input : EditInput
  parameters : EditParams?
} derive(ToJson)

///|
pub extend EditRequest with ToJson::{to_json}

///|
/// Response: single image content
pub struct EditImageContent {
  image : String?
} derive(Debug, @json.FromJson)

///|
pub extend EditImageContent with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EditImageContent with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Response: message
pub struct EditMessage2 {
  role : String?
  content : Array[EditImageContent]
} derive(Debug, @json.FromJson)

///|
pub extend EditMessage2 with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EditMessage2 with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Response: choice
pub struct EditChoice {
  finish_reason : String?
  message : EditMessage2
} derive(Debug, @json.FromJson)

///|
pub extend EditChoice with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EditChoice with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Response: output
pub struct EditOutput {
  choices : Array[EditChoice]?
} derive(Debug, @json.FromJson)

///|
pub extend EditOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EditOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Response: usage
pub struct EditUsage {
  image_count : Int?
  input_tokens : Int?
  output_tokens : Int?
  total_tokens : Int?
} derive(Debug, @json.FromJson)

///|
pub extend EditUsage with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EditUsage with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Full response
pub struct EditResponse {
  request_id : String?
  output : EditOutput
  usage : EditUsage?
  code : String?
  message : String?
} derive(Debug, @json.FromJson)

///|
pub extend EditResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EditResponse with @moonbitlang/core/debug.Debug::{to_repr}
