///|
/// Deep research request for Qwen-Deep-Research
///

///|
/// Deep research request structure
pub struct DeepResearchRequest {
  model : String
  messages : Array[@lib.Message]
  stream : Bool
} derive(ToJson)
