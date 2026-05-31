///|
/// Common types for Moonbit Bailian SDK
///

///|
pub struct ImageUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Content {
  text : String?
  image_url : ImageUrl?
  type_ : String
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub struct Message {
  role : String
  content : Json
  partial : Bool?
  tool_calls : Array[ToolCall]?
  tool_call_id : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Function {
  name : String
  arguments : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct ToolCall {
  id : String
  function : Function
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct StreamOptions {
  include_usage : Bool
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Parameters {
  type_ : String
  properties : Map[String, Json]
  required : Array[String]
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub struct FunctionDef {
  name : String
  description : String
  parameters : Parameters
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Tool {
  type_ : String
  function : FunctionDef
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub struct Request {
  model : String
  messages : Array[Message]
  stream : Bool?
  stream_options : StreamOptions?
  tools : Json?
  extra_body : Json?
  enable_search : Bool?
} derive(ToJson)

///|
pub struct Choice {
  message : Message
} derive(ToJson, @json.FromJson)

///|
pub struct Response {
  choices : Array[Choice]
  usage : Json?
} derive(ToJson, @json.FromJson)

///|
pub struct StreamChoice {
  delta : Message
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct StreamResponse {
  choices : Array[StreamChoice]
  usage : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - input parameters
pub struct ImageGenInput {
  prompt : String
  negative_prompt : String?
  ref_img : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - processing parameters
pub struct ImageGenParameters {
  style : String?
  size : String?
  n : Int?
  seed : Int?
  ref_strength : Float?
  ref_mode : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - request body
pub struct ImageGenRequest {
  model : String
  input : ImageGenInput
  parameters : ImageGenParameters?
} derive(Debug, ToJson)

///|
/// Image generation - single result
pub struct ImageGenResult {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - task metrics
pub struct ImageGenTaskMetrics {
  total : Int
  succeeded : Int
  failed : Int
} derive (
  Debug,
  ToJson(
    fields(
      total(rename="TOTAL"),
      succeeded(rename="SUCCEEDED"),
      failed(rename="FAILED"),
    ),
  ),
  @json.FromJson,
)

///|
/// Image generation - output info
pub struct ImageGenOutput {
  task_id : String
  task_status : String
  results : Array[ImageGenResult]?
  task_metrics : ImageGenTaskMetrics?
  submit_time : String?
  scheduled_time : String?
  end_time : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - usage info
pub struct ImageGenUsage {
  image_count : Int
} derive(Debug, ToJson, @json.FromJson)

///|
/// Image generation - response
pub struct ImageGenResponse {
  output : ImageGenOutput
  usage : ImageGenUsage?
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)
