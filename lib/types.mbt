///|
/// Common types for Moonbit Promptkit SDK
///

///|
pub struct CacheControl {
  type_ : String
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub struct ImageUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct VideoUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct AudioUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Content {
  text : String?
  image_url : ImageUrl?
  video_url : VideoUrl?
  audio_url : AudioUrl?
  type_ : String
  cache_control : CacheControl?
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub struct Message {
  role : String
  content : Json
  partial : Bool?
  tool_calls : Array[ToolCall]?
  tool_call_id : String?
  reasoning_content : Json?
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
pub struct SearchOptions {
  search_strategy : String?
} derive(ToJson)

///|
pub struct Request {
  model : String
  messages : Array[Message]
  stream : Bool?
  stream_options : StreamOptions?
  tools : Json?
  extra_body : Json?
  enable_search : Bool?
  enable_thinking : Bool?
  enable_code_interpreter : Bool?
  search_options : SearchOptions?
  top_p : Float?
  temperature : Float?
  presence_penalty : Float?
  n : Int?
  max_tokens : Int?
  seed : Int?
  stop : Json?
} derive(ToJson)

///|
pub struct Choice {
  message : Message
} derive(ToJson, @json.FromJson)

///|
pub struct PromptTokensDetails {
  cached_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub struct Usage {
  prompt_tokens : Int?
  completion_tokens : Int?
  total_tokens : Int?
  prompt_tokens_details : PromptTokensDetails?
  cache_creation_input_tokens : Int?
  cache_read_input_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

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

///|
/// Video generation - media item for reference
pub struct VideoMediaItem {
  type_ : String
  url : String
  reference_voice : String?
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
/// Video generation - input parameters
pub struct VideoGenInput {
  prompt : String?
  img_url : String?
  video_url : String?
  audio_url : String?
  function : String?
  media : Array[VideoMediaItem]?
  ref_images_url : Array[String]?
  image : String?
  images : Array[Json]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Video generation - processing parameters
pub struct VideoGenParameters {
  resolution : String?
  duration : Int?
  shot_type : String?
  prompt_extend : Bool?
  watermark : Bool?
  negative_prompt : String?
  seed : Int?
  ratio : String?
  size : String?
  obj_or_bg : Array[String]?
  control_condition : String?
  strength : Float?
  texture_quality : String?
  geometry_quality : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Video generation - request body
pub struct VideoGenRequest {
  model : String
  input : VideoGenInput
  parameters : VideoGenParameters?
} derive(Debug, ToJson)

///|
/// Video generation - output info
pub struct VideoGenOutput {
  task_id : String
  task_status : String
  video_url : String?
  results : Array[Json]?
  submit_time : String?
  scheduled_time : String?
  end_time : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Video generation - response
pub struct VideoGenResponse {
  output : VideoGenOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// 3D generation - single result
pub struct Gen3DResult {
  pbr_model_url : String?
  base_model_url : String?
  rendered_image_url : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// 3D generation - output info
pub struct Gen3DOutput {
  task_id : String
  task_status : String
  results : Array[Gen3DResult]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// 3D generation - response
pub struct Gen3DResponse {
  output : Gen3DOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch File - uploaded file info
pub struct BatchFile {
  id : String
  object : String?
  bytes : Int?
  created_at : Int?
  filename : String?
  purpose : String?
  status : String?
  status_details : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch Error info
pub struct BatchError {
  code : String?
  message : String?
  param : String?
  line : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch Request - create batch task
pub struct BatchCreateRequest {
  input_file_id : String
  endpoint : String
  completion_window : String
  metadata : Map[String, String]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch - batch task info
pub struct Batch {
  id : String
  object : String?
  endpoint : String?
  status : String
  input_file_id : String?
  output_file_id : String?
  error_file_id : String?
  completion_window : String?
  request_counts : BatchRequestCounts?
  errors : Array[BatchError]?
  created_at : Int?
  in_progress_at : Int?
  completed_at : Int?
  failed_at : Int?
  expires_at : Int?
  cancelling_at : Int?
  cancelled_at : Int?
  metadata : Map[String, String]?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch Request Counts
pub struct BatchRequestCounts {
  total : Int?
  completed : Int?
  failed : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch List Response
pub struct BatchListResponse {
  object : String?
  data : Array[Batch]
  has_more : Bool?
  first_id : String?
  last_id : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch input item - for JSONL input file
pub struct BatchInputItem {
  custom_id : String
  method_ : String
  url : String
  body : Json
} derive(Debug, ToJson(fields(method_(rename="method"))), @json.FromJson)

///|
/// Batch output item - for JSONL output file
pub struct BatchOutputItem {
  id : String?
  custom_id : String
  response : BatchOutputResponse?
  error : BatchError?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Batch Output Response
pub struct BatchOutputResponse {
  status_code : Int?
  request_id : String?
  body : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Embedding request body
pub struct EmbeddingRequest {
  model : String
  input : Json
  encoding_format : String?
  dimensions : Int?
} derive(ToJson)

///|
/// Embedding data item
pub struct EmbeddingData {
  object : String?
  embedding : Array[Float]
  index : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Embedding usage
pub struct EmbeddingUsage {
  prompt_tokens : Int?
  total_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Embedding response
pub struct EmbeddingResponse {
  object : String?
  data : Array[EmbeddingData]
  model : String?
  usage : EmbeddingUsage?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Model info - for List Models API
pub struct Model {
  id : String
  object : String?
  created : Int?
  owned_by : String?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Model list response - for List Models API
pub struct ModelListResponse {
  object : String?
  data : Array[Model]
} derive(Debug, ToJson, @json.FromJson)
