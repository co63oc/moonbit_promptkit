///|
/// Speech Recognition API (语音识别)
/// Paraformer - 非实时语音识别（文件转写）
/// Endpoint: /services/audio/asr/transcription (异步)
///

///|
/// Default speech recognition model
pub let default_model : String = "paraformer-v2"

///|
/// Transcription request input
struct TranscriptionInput {
  file_urls : Array[String]
  language_hints : Array[String]?
} derive(ToJson)

///|
/// Transcription request parameters
struct TranscriptionParams {
  diarization_enabled : Bool?
  speaker_count : Int?
  channel_id : Int?
} derive(ToJson)

///|
/// Transcription request
struct TranscriptionRequest {
  model : String
  input : TranscriptionInput
  parameters : TranscriptionParams?
} derive(ToJson)

///|
/// Submit transcription task (non-realtime, file-based)
pub async fn submit_transcription(
  config : @lib.ClientConfig,
  file_urls : Array[String],
  language_hints? : Array[String],
  diarization_enabled? : Bool,
  speaker_count? : Int,
) -> String {
  let input = TranscriptionInput::{ file_urls, language_hints }
  let parameters = TranscriptionParams::{
    diarization_enabled,
    speaker_count,
    channel_id: None,
  }
  let request = TranscriptionRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/audio/asr/transcription"
  let (response, body) = @http.post(
    url,
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Transcription submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Transcribe audio files and wait for completion
/// Returns transcription result URL
pub async fn transcribe(
  config : @lib.ClientConfig,
  file_urls : Array[String],
  language_hints? : Array[String],
  diarization_enabled? : Bool,
  speaker_count? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_transcription(
    config,
    file_urls,
    language_hints?,
    diarization_enabled?,
    speaker_count?,
  )
  let interval = poll_interval_ms.unwrap_or(5000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, result_url) = query_transcription_task(config, task_id)
    if status == "SUCCEEDED" {
      return result_url
    } else if status == "FAILED" {
      fail("Transcription task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Transcription task timeout: \{task_id}")
}

///|
/// Query transcription task status
pub async fn query_transcription_task(
  config : @lib.ClientConfig,
  task_id : String,
) -> (String, String) {
  let url = "https://dashscope.aliyuncs.com/api/v1/tasks/\{task_id}"
  let (response, body) = @http.get(url, headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("Task query failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(body.json())
  let status = extract_status(resp)
  if status == "SUCCEEDED" {
    let result_url = extract_result_url(resp)
    (status, result_url)
  } else {
    (status, "")
  }
}

// Internal helpers
fn extract_task_id(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("task_id") {
            Some(Json::String(id)) => id
            _ => "UNKNOWN"
          }
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}

fn extract_status(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("task_status") {
            Some(Json::String(s)) => s
            _ => "UNKNOWN"
          }
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}

fn extract_result_url(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("results") {
            Some(Json::Array(results)) =>
              if results.length() > 0 {
                match results[0] {
                  Json::Object(r) =>
                    match r.get("transcription_url") {
                      Some(Json::String(u)) => u
                      _ => ""
                    }
                  _ => ""
                }
              } else {
                ""
              }
            _ => ""
          }
        _ => ""
      }
    _ => ""
  }
}
