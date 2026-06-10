///|
/// Music Generation API (音乐生成)
/// FunMusic - 百聆音乐生成大模型
/// Endpoint: /services/aigc/music-generation/generation (异步)
///

///|
/// Default music generation model
pub let default_model : String = "funmusic-v1"

///|
/// Music generation request input
struct MusicInput {
  prompt : String
  duration : Int?
} derive(ToJson)

///|
/// Music generation request
struct MusicRequest {
  model : String
  input : MusicInput
} derive(ToJson)

///|
/// Submit music generation task
pub async fn submit_music_generation(
  config : @lib.ClientConfig,
  prompt : String,
  duration? : Int,
) -> String {
  let input = MusicInput::{ prompt, duration }
  let request = MusicRequest::{ model: default_model, input }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/music-generation/generation"
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
      "Music generation submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Generate music and wait for completion
/// Returns audio URL
pub async fn generate_music(
  config : @lib.ClientConfig,
  prompt : String,
  duration? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_music_generation(config, prompt, duration?)
  let interval = poll_interval_ms.unwrap_or(10000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, audio_url) = query_music_task(config, task_id)
    if status == "SUCCEEDED" {
      return audio_url
    } else if status == "FAILED" {
      fail("Music generation task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Music generation task timeout: \{task_id}")
}

///|
/// Query music generation task status
pub async fn query_music_task(
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
    let audio_url = extract_audio_url(resp)
    (status, audio_url)
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

fn extract_audio_url(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("audio_url") {
            Some(Json::String(u)) => u
            _ => ""
          }
        _ => ""
      }
    _ => ""
  }
}
