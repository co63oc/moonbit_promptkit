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
