///|
/// Video Editing API (视频编辑)
/// Wan Video Editing - 视频风格迁移、增强
/// Endpoint: /services/aigc/video-editing/generation (异步)
///

///|
/// Default video editing model
pub let default_model : String = "wan2.7-videoedit"

///|
/// Video editing request input
struct VideoEditInput {
  video_url : String
  prompt : String
} derive(ToJson)

///|
/// Video editing request parameters
struct VideoEditParams {
  resolution : String?
  duration : Int?
} derive(ToJson)

///|
/// Video editing request
struct VideoEditRequest {
  model : String
  input : VideoEditInput
  parameters : VideoEditParams?
} derive(ToJson)

///|
/// Submit video editing task
pub async fn submit_video_edit(
  config : @lib.ClientConfig,
  video_url : String,
  prompt : String,
  resolution? : String,
  duration? : Int,
) -> String {
  let input = VideoEditInput::{ video_url, prompt }
  let parameters = VideoEditParams::{ resolution, duration }
  let request = VideoEditRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/video-editing/generation"
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
      "Video edit submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Edit video and wait for completion
/// Returns video URL
pub async fn edit_video(
  config : @lib.ClientConfig,
  video_url : String,
  prompt : String,
  resolution? : String,
  duration? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_video_edit(config, video_url, prompt, resolution?, duration?)
  let interval = poll_interval_ms.unwrap_or(10000)
  let max = max_attempts.unwrap_or(120)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, result_url) = query_video_edit_task(config, task_id)
    if status == "SUCCEEDED" {
      return result_url
    } else if status == "FAILED" {
      fail("Video edit task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Video edit task timeout: \{task_id}")
}

///|
/// Query video editing task status
pub async fn query_video_edit_task(
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
    let video_url = extract_video_url(resp)
    (status, video_url)
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

fn extract_video_url(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("video_url") {
            Some(Json::String(u)) => u
            _ => ""
          }
        _ => ""
      }
    _ => ""
  }
}
