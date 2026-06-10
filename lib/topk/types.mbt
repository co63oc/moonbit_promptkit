///|
/// TopK-enabled chat request for dialogue analysis models
///

///| Chat request with top_k parameter

///|
/// Used for dialogue analysis models that require deterministic output
pub struct TopKRequest {
  model : String
  messages : Array[@lib.Message]
  stream : Bool?
  stream_options : @lib.StreamOptions?
  temperature : Float?
  top_k : Int?
} derive(ToJson)
