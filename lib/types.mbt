///|
/// Common types for Moonbit Promptkit SDK
///

///|
/// The CacheControl type.
pub struct CacheControl {
  type_ : String
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub extend CacheControl with ToJson::{to_json}

///|
pub extend CacheControl with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend CacheControl with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// The ImageUrl type.
pub struct ImageUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ImageUrl with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageUrl with ToJson::{to_json}

///|
pub extend ImageUrl with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// The VideoUrl type.
pub struct VideoUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend VideoUrl with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VideoUrl with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VideoUrl with ToJson::{to_json}

///|
/// The AudioUrl type.
pub struct AudioUrl {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend AudioUrl with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend AudioUrl with ToJson::{to_json}

///|
pub extend AudioUrl with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// The Content type.
pub struct Content {
  text : String?
  image_url : ImageUrl?
  video_url : VideoUrl?
  audio_url : AudioUrl?
  type_ : String
  cache_control : CacheControl?
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub extend Content with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Content with ToJson::{to_json}

///|
pub extend Content with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The Message type.
pub struct Message {
  role : String
  content : Json
  partial : Bool?
  tool_calls : Array[ToolCall]?
  tool_call_id : String?
  reasoning_content : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Message with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Message with ToJson::{to_json}

///|
pub extend Message with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The Function type.
pub struct Function {
  name : String
  arguments : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Function with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Function with ToJson::{to_json}

///|
pub extend Function with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The ToolCall type.
pub struct ToolCall {
  id : String
  function : Function
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ToolCall with ToJson::{to_json}

///|
pub extend ToolCall with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Tool with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Tool with ToJson::{to_json}

///|
pub extend Tool with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ToolCall with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// The StreamOptions type.
pub struct StreamOptions {
  include_usage : Bool
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend StreamOptions with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend StreamOptions with ToJson::{to_json}

///|
pub extend StreamOptions with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The Parameters type.
pub struct Parameters {
  type_ : String
  properties : Map[String, Json]
  required : Array[String]
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub extend Parameters with ToJson::{to_json}

///|
pub extend Parameters with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Parameters with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The FunctionDef type.
pub struct FunctionDef {
  name : String
  description : String
  parameters : Parameters
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend FunctionDef with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend FunctionDef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend FunctionDef with ToJson::{to_json}

///|
/// The Tool type.
pub struct Tool {
  type_ : String
  function : FunctionDef
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
/// The SearchOptions type.
pub struct SearchOptions {
  search_strategy : String?
} derive(ToJson)

///|
pub extend SearchOptions with ToJson::{to_json}

///|
/// The Request type.
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
pub extend Request with ToJson::{to_json}

///|
/// The Choice type.
pub struct Choice {
  message : Message
} derive(ToJson, @json.FromJson)

///|
pub extend Choice with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Choice with ToJson::{to_json}

///|
/// The PromptTokensDetails type.
pub struct PromptTokensDetails {
  cached_tokens : Int?
  text_tokens : Int?
  cache_type : String?
  cache_creation_input_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend PromptTokensDetails with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend PromptTokensDetails with ToJson::{to_json}

///|
pub extend PromptTokensDetails with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The CompletionTokensDetails type.
pub struct CompletionTokensDetails {
  reasoning_tokens : Int?
  text_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend CompletionTokensDetails with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CompletionTokensDetails with @moonbitlang/core/json.FromJson::{
  from_json,
}

///|
pub extend CompletionTokensDetails with ToJson::{to_json}

///|
/// The Usage type.
pub struct Usage {
  prompt_tokens : Int?
  completion_tokens : Int?
  total_tokens : Int?
  prompt_tokens_details : PromptTokensDetails?
  completion_tokens_details : CompletionTokensDetails?
} derive (
  Debug,
  ToJson(
    fields(
      prompt_tokens_details(rename="prompt_tokens_details"),
      completion_tokens_details(rename="completion_tokens_details"),
    ),
  ),
  @json.FromJson,
)

///|
/// The Response type.
pub struct Response {
  choices : Array[Choice]
  usage : Json?
} derive(ToJson, @json.FromJson)

///|
pub extend Response with ToJson::{to_json}

///|
pub extend Usage with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Response with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Usage with ToJson::{to_json}

///|
/// The StreamChoice type.
pub struct StreamChoice {
  delta : Message
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend StreamChoice with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Usage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend StreamChoice with ToJson::{to_json}

///|
pub extend StreamChoice with @moonbitlang/core/json.FromJson::{from_json}

///|
/// The StreamResponse type.
pub struct StreamResponse {
  choices : Array[StreamChoice]
  usage : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend StreamResponse with ToJson::{to_json}

///|
pub extend StreamResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend StreamResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Image generation - input parameters
pub struct ImageGenInput {
  prompt : String
  negative_prompt : String?
  ref_img : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ImageGenInput with ToJson::{to_json}

///|
pub extend ImageGenInput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenInput with @moonbitlang/core/debug.Debug::{to_repr}

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
pub extend ImageGenParameters with ToJson::{to_json}

///|
pub extend ImageGenParameters with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenParameters with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Image generation - request body
pub struct ImageGenRequest {
  model : String
  input : ImageGenInput
  parameters : ImageGenParameters?
} derive(Debug, ToJson)

///|
pub extend ImageGenRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenRequest with ToJson::{to_json}

///|
/// Image generation - single result
pub struct ImageGenResult {
  url : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ImageGenResult with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenResult with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenResult with ToJson::{to_json}

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
pub extend ImageGenOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenTaskMetrics with ToJson::{to_json}

///|
pub extend ImageGenOutput with ToJson::{to_json}

///|
pub extend ImageGenTaskMetrics with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenTaskMetrics with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Image generation - usage info
pub struct ImageGenUsage {
  image_count : Int
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ImageGenUsage with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenUsage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenUsage with ToJson::{to_json}

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
pub extend ImageGenResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ImageGenResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ImageGenResponse with ToJson::{to_json}

///|
/// Video generation - media item for reference
pub struct VideoMediaItem {
  type_ : String
  url : String
  reference_voice : String?
} derive(Debug, ToJson(fields(type_(rename="type"))), @json.FromJson)

///|
pub extend VideoMediaItem with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VideoMediaItem with ToJson::{to_json}

///|
pub extend VideoMediaItem with @moonbitlang/core/debug.Debug::{to_repr}

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
pub extend VideoGenInput with ToJson::{to_json}

///|
pub extend VideoGenInput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VideoGenInput with @moonbitlang/core/debug.Debug::{to_repr}

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
pub extend VideoGenParameters with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VideoGenParameters with ToJson::{to_json}

///|
pub extend VideoGenParameters with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Video generation - request body
pub struct VideoGenRequest {
  model : String
  input : VideoGenInput
  parameters : VideoGenParameters?
} derive(Debug, ToJson)

///|
pub extend VideoGenRequest with ToJson::{to_json}

///|
pub extend VideoGenRequest with @moonbitlang/core/debug.Debug::{to_repr}

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
pub extend VideoGenOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend VideoGenOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VideoGenOutput with ToJson::{to_json}

///|
/// Video generation - response
pub struct VideoGenResponse {
  output : VideoGenOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend VideoGenResponse with ToJson::{to_json}

///|
pub extend VideoGenResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VideoGenResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// 3D generation - single result
pub struct Gen3DResult {
  pbr_model_url : String?
  base_model_url : String?
  rendered_image_url : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Gen3DResult with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Gen3DResult with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Gen3DResult with ToJson::{to_json}

///|
/// 3D generation - output info
pub struct Gen3DOutput {
  task_id : String
  task_status : String
  results : Array[Gen3DResult]?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Gen3DOutput with ToJson::{to_json}

///|
pub extend Gen3DOutput with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Gen3DOutput with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// 3D generation - response
pub struct Gen3DResponse {
  output : Gen3DOutput
  request_id : String
  code : String?
  message : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Gen3DResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Gen3DResponse with ToJson::{to_json}

///|
pub extend Gen3DResponse with @moonbitlang/core/json.FromJson::{from_json}

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
pub extend BatchFile with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Batch with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Batch with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchFile with ToJson::{to_json}

///|
pub extend Batch with ToJson::{to_json}

///|
pub extend BatchFile with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Batch Error info
pub struct BatchError {
  code : String?
  message : String?
  param : String?
  line : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend BatchError with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend BatchError with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchError with ToJson::{to_json}

///|
/// Batch Request - create batch task
pub struct BatchCreateRequest {
  input_file_id : String
  endpoint : String
  completion_window : String
  metadata : Map[String, String]?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend BatchCreateRequest with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend BatchCreateRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchCreateRequest with ToJson::{to_json}

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
pub extend BatchRequestCounts with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchRequestCounts with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend BatchRequestCounts with ToJson::{to_json}

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
pub extend BatchListResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchListResponse with ToJson::{to_json}

///|
pub extend BatchListResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Batch input item - for JSONL input file
pub struct BatchInputItem {
  custom_id : String
  method_ : String
  url : String
  body : Json
} derive(Debug, ToJson(fields(method_(rename="method"))), @json.FromJson)

///|
pub extend BatchInputItem with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend BatchInputItem with ToJson::{to_json}

///|
pub extend BatchInputItem with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Batch output item - for JSONL output file
pub struct BatchOutputItem {
  id : String?
  custom_id : String
  response : BatchOutputResponse?
  error : BatchError?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend BatchOutputItem with ToJson::{to_json}

///|
pub extend BatchOutputItem with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchOutputItem with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Batch Output Response
pub struct BatchOutputResponse {
  status_code : Int?
  request_id : String?
  body : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend BatchOutputResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BatchOutputResponse with ToJson::{to_json}

///|
pub extend BatchOutputResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Embedding request body
pub struct EmbeddingRequest {
  model : String
  input : Json
  encoding_format : String?
  dimensions : Int?
} derive(ToJson)

///|
pub extend EmbeddingRequest with ToJson::{to_json}

///|
/// Embedding data item
pub struct EmbeddingData {
  object : String?
  embedding : Array[Float]
  index : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend EmbeddingData with ToJson::{to_json}

///|
pub extend EmbeddingData with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EmbeddingData with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Embedding usage
pub struct EmbeddingUsage {
  prompt_tokens : Int?
  total_tokens : Int?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend EmbeddingUsage with ToJson::{to_json}

///|
pub extend EmbeddingUsage with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EmbeddingUsage with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Embedding response
pub struct EmbeddingResponse {
  object : String?
  data : Array[EmbeddingData]
  model : String?
  usage : EmbeddingUsage?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend EmbeddingResponse with ToJson::{to_json}

///|
pub extend EmbeddingResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EmbeddingResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Model info - for List Models API
pub struct Model {
  id : String
  object : String?
  created : Int?
  owned_by : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend Model with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend Model with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Model with ToJson::{to_json}

///|
/// Model list response - for List Models API
pub struct ModelListResponse {
  object : String?
  data : Array[Model]
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend ModelListResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend ModelListResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ModelListResponse with ToJson::{to_json}
