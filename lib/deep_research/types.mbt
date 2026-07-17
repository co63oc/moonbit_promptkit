///|
/// Deep research request for Qwen-Deep-Research
///

///|
/// Deep research request structure (DashScope native format)
pub struct DeepResearchRequest {
  model : String
  input : DeepResearchInput
  parameters : String?
} derive(ToJson)

///|
pub extend DeepResearchRequest with ToJson::{to_json}

///|
/// Input structure
pub struct DeepResearchInput {
  messages : Array[@lib.Message]
} derive(ToJson)

///|
pub extend DeepResearchInput with ToJson::{to_json}
