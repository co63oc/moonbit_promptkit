///|
/// Wan VACE Video Editing API (万相通用视频编辑)
/// 支持多图参考、视频重绘、局部编辑、视频延展等
/// Endpoint: /services/aigc/video-generation/video-synthesis (异步)
///

///|
/// Default VACE model
pub let default_model : String = "wanx2.1-vace-plus"

///|
/// Video editing function names
pub let image_reference_fn : String = "image_reference"

///|
pub let video_repainting_fn : String = "video_repainting"

///|
pub let local_editing_fn : String = "local_editing"

///|
pub let video_extension_fn : String = "video_extension"

///|
/// Control condition names
pub let pose_body_face : String = "posebodyface"

///|
pub let pose_body : String = "posebody"

///|
pub let depth_condition : String = "depth"

///|
pub let scribble_condition : String = "scribble"

///|
/// VACE request input
struct VaceInput {
  function : String
  prompt : String
  ref_images_url : Array[String]?
  video_url : String?
  obj_or_bg : Array[String]?
} derive(ToJson)

///|
/// VACE request parameters
struct VaceParams {
  prompt_extend : Bool?
  control_condition : String?
  strength : Float?
  size : String?
} derive(ToJson)

///|
/// VACE request
struct VaceRequest {
  model : String
  input : VaceInput
  parameters : VaceParams?
} derive(ToJson)

///|
/// Submit image reference task (多图参考)
pub async fn submit_image_reference(
  config : @lib.ClientConfig,
  prompt : String,
  ref_images : Array[String],
  obj_or_bg : Array[String],
  size? : String,
) -> String {
  let input = VaceInput::{
    function: image_reference_fn,
    prompt,
    ref_images_url: Some(ref_images),
    video_url: None,
    obj_or_bg: Some(obj_or_bg),
  }
  let parameters = VaceParams::{
    prompt_extend: Some(true),
    control_condition: None,
    strength: None,
    size,
  }
  let request = VaceRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/video-generation/video-synthesis"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-Async": "enable",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Image reference submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Submit video repainting task (视频重绘)
pub async fn submit_video_repainting(
  config : @lib.ClientConfig,
  prompt : String,
  video_url : String,
  control_condition : String,
  strength? : Float,
  ref_image_url? : String,
  size? : String,
) -> String {
  let input = VaceInput::{
    function: video_repainting_fn,
    prompt,
    ref_images_url: match ref_image_url {
      Some(url) => Some([url])
      None => None
    },
    video_url: Some(video_url),
    obj_or_bg: None,
  }
  let parameters = VaceParams::{
    prompt_extend: Some(false),
    control_condition: Some(control_condition),
    strength,
    size,
  }
  let request = VaceRequest::{
    model: default_model,
    input,
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/video-generation/video-synthesis"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
    "X-DashScope-Async": "enable",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Video repainting submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Generate video from image reference and wait for completion
pub async fn image_reference(
  config : @lib.ClientConfig,
  prompt : String,
  ref_images : Array[String],
  obj_or_bg : Array[String],
  size? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_image_reference(
    config,
    prompt,
    ref_images,
    obj_or_bg,
    size?,
  )
  let interval = poll_interval_ms.unwrap_or(15000)
  let max = max_attempts.unwrap_or(40)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, video_url) = query_vace_task(config, task_id)
    if status == "SUCCEEDED" {
      return video_url
    } else if status == "FAILED" {
      fail("VACE task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("VACE task timeout: \{task_id}")
}

///|
/// Repaint video and wait for completion
pub async fn video_repainting(
  config : @lib.ClientConfig,
  prompt : String,
  video_url : String,
  control_condition : String,
  strength? : Float,
  ref_image_url? : String,
  size? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_video_repainting(
    config,
    prompt,
    video_url,
    control_condition,
    strength?,
    ref_image_url?,
    size?,
  )
  let interval = poll_interval_ms.unwrap_or(15000)
  let max = max_attempts.unwrap_or(40)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, video_url) = query_vace_task(config, task_id)
    if status == "SUCCEEDED" {
      return video_url
    } else if status == "FAILED" {
      fail("VACE task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("VACE task timeout: \{task_id}")
}

///|
/// Query VACE task status
pub async fn query_vace_task(
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

///|
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

///|
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

///|
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
