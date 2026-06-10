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
