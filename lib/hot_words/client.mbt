///|
/// Hot Words (Custom Vocabulary) API (自定义热词)
/// 用于提升语音识别中专有名词的识别准确率
/// Endpoint: /services/audio/asr/vocabularies
///

///|
/// Hot word item
struct HotWord {
  text : String
  weight : Int
  lang : String?
} derive(ToJson)

///|
/// Create vocabulary request
struct CreateVocabularyRequest {
  prefix : String
  target_model : String
  vocabulary : Array[HotWord]
} derive(ToJson)

///|
/// Create a hot word vocabulary list
/// Returns vocabulary_id
pub async fn create_vocabulary(
  config : @lib.ClientConfig,
  prefix : String,
  target_model : String,
  vocabulary : Array[HotWord],
) -> String {
  let request = CreateVocabularyRequest::{ prefix, target_model, vocabulary }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/audio/asr/vocabularies"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Create vocabulary failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_vocabulary_id(resp)
}

///|
/// Query vocabulary status
pub async fn query_vocabulary(
  config : @lib.ClientConfig,
  vocabulary_id : String,
) -> String {
  let url = "https://dashscope.aliyuncs.com/api/v1/services/audio/asr/vocabularies/\{vocabulary_id}"
  let (response, body) = @http.get(url, headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("Query vocabulary failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(body.json())
  extract_status(resp)
}

///|
/// Delete a vocabulary
pub async fn delete_vocabulary(
  config : @lib.ClientConfig,
  vocabulary_id : String,
) -> Unit {
  let url = "https://dashscope.aliyuncs.com/api/v1/services/audio/asr/vocabularies/\{vocabulary_id}"
  let (response, _) = @http.post(
    url,
    Json::object({}).to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-HTTP-Method-Override": "DELETE",
    },
  )
  guard response.code is (200..=299) else {
    fail("Delete vocabulary failed: \{response.code} \{response.reason}")
  }
  ignore(())
}

///|
/// List all vocabularies
pub async fn list_vocabularies(
  config : @lib.ClientConfig,
) -> String {
  let url = "https://dashscope.aliyuncs.com/api/v1/services/audio/asr/vocabularies"
  let (response, body) = @http.get(url, headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("List vocabularies failed: \{response.code} \{response.reason}")
  }
  body.text()
}

///|
/// Create a hot word
pub fn hot_word(text : String, weight : Int, lang? : String) -> HotWord {
  HotWord::{ text, weight, lang }
}

// Internal helpers
fn extract_vocabulary_id(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("vocabulary_id") {
        Some(Json::String(id)) => id
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}

fn extract_status(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("status") {
        Some(Json::String(s)) => s
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}
