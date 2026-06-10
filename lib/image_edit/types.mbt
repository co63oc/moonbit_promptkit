///|
/// Types for image editing APIs (Qwen Image Edit + Wan Image Edit)
///

///|
/// Text content item
pub struct TextItem {
  text : String
} derive(ToJson)

///|
/// Image content item
pub struct ImageItem {
  image : String
} derive(ToJson)

///|
/// Message for image edit requests
pub struct EditMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
/// Parameters for image edit
pub struct EditParams {
  n : Int?
  size : String?
  prompt_extend : Bool?
} derive(ToJson)

///|
/// Input for image edit
pub struct EditInput {
  messages : Array[EditMessage]
} derive(ToJson)

///|
/// Full request for image edit (multimodal-generation)
pub struct EditRequest {
  model : String
  input : EditInput
  parameters : EditParams?
} derive(ToJson)

///|
/// Response: single image content
pub struct EditImageContent {
  image : String?
} derive(Debug, @json.FromJson)

///|
/// Response: message
pub struct EditMessage2 {
  role : String?
  content : Array[EditImageContent]
} derive(Debug, @json.FromJson)

///|
/// Response: choice
pub struct EditChoice {
  finish_reason : String?
  message : EditMessage2
} derive(Debug, @json.FromJson)

///|
/// Response: output
pub struct EditOutput {
  choices : Array[EditChoice]?
} derive(Debug, @json.FromJson)

///|
/// Response: usage
pub struct EditUsage {
  image_count : Int?
  input_tokens : Int?
  output_tokens : Int?
  total_tokens : Int?
} derive(Debug, @json.FromJson)

///|
/// Full response
pub struct EditResponse {
  request_id : String?
  output : EditOutput
  usage : EditUsage?
  code : String?
  message : String?
} derive(Debug, @json.FromJson)
