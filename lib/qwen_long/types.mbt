///|
/// Qwen-Long file upload response
pub struct FileUploadResult {
  id : String
  object : String?
  bytes : Int?
  created_at : Int?
  filename : String?
  purpose : String?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend FileUploadResult with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend FileUploadResult with ToJson::{to_json}

///|
pub extend FileUploadResult with @moonbitlang/core/debug.Debug::{to_repr}
