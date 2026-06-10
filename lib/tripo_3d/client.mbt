///|
/// Tripo 3D Generation API (3D模型生成)
/// Tripo 3D - 文本/图像生成3D模型
/// Endpoint: /services/aigc/3d-generation/generation (异步)
///

///|
/// Default 3D generation model
pub let default_model : String = "Tripo/Tripo-P1.0"

///|
/// High quality 3D model
pub let high_quality_model : String = "Tripo/Tripo-H3.1"

///|
/// Text to 3D request input
struct TextTo3DInput {
  prompt : String
} derive(ToJson)

///|
/// Image to 3D request input
struct ImageTo3DInput {
  image_url : String
} derive(ToJson)

///|
/// 3D generation request parameters
struct Generation3DParams {
  format : String?
  topology : String?
  target_count : Int?
} derive(ToJson)

///|
/// 3D generation request
struct Generation3DRequest {
  model : String
  input : Json
  parameters : Generation3DParams?
} derive(ToJson)

///|
/// Submit text to 3D task
pub async fn submit_text_to_3d(
  config : @lib.ClientConfig,
  prompt : String,
  format? : String,
  topology? : String,
  target_count? : Int,
) -> String {
  let input = TextTo3DInput::{ prompt }
  let parameters = Generation3DParams::{ format, topology, target_count }
  let request = Generation3DRequest::{
    model: default_model,
    input: input.to_json(),
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/3d-generation/generation"
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
      "Text to 3D submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Submit image to 3D task
pub async fn submit_image_to_3d(
  config : @lib.ClientConfig,
  image_url : String,
  format? : String,
  topology? : String,
  target_count? : Int,
) -> String {
  let input = ImageTo3DInput::{ image_url }
  let parameters = Generation3DParams::{ format, topology, target_count }
  let request = Generation3DRequest::{
    model: default_model,
    input: input.to_json(),
    parameters: Some(parameters),
  }

  let url = "https://dashscope.aliyuncs.com/api/v1/services/aigc/3d-generation/generation"
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
      "Image to 3D submit failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : Json = @json.from_json(body.json())
  extract_task_id(resp)
}

///|
/// Generate 3D model from text and wait for completion
/// Returns model URL (GLB format)
pub async fn text_to_3d(
  config : @lib.ClientConfig,
  prompt : String,
  format? : String,
  topology? : String,
  target_count? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_text_to_3d(config, prompt, format?, topology?, target_count?)
  let interval = poll_interval_ms.unwrap_or(15000)
  let max = max_attempts.unwrap_or(40)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, model_url) = query_3d_task(config, task_id)
    if status == "SUCCEEDED" {
      return model_url
    } else if status == "FAILED" {
      fail("3D generation task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("3D generation task timeout: \{task_id}")
}

///|
/// Generate 3D model from image and wait for completion
/// Returns model URL (GLB format)
pub async fn image_to_3d(
  config : @lib.ClientConfig,
  image_url : String,
  format? : String,
  topology? : String,
  target_count? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_image_to_3d(config, image_url, format?, topology?, target_count?)
  let interval = poll_interval_ms.unwrap_or(15000)
  let max = max_attempts.unwrap_or(40)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, model_url) = query_3d_task(config, task_id)
    if status == "SUCCEEDED" {
      return model_url
    } else if status == "FAILED" {
      fail("3D generation task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("3D generation task timeout: \{task_id}")
}

///|
/// Query 3D generation task status
pub async fn query_3d_task(
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
    let model_url = extract_model_url(resp)
    (status, model_url)
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

fn extract_model_url(resp : Json) -> String {
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("results") {
            Some(Json::Array(results)) =>
              if results.length() > 0 {
                match results[0] {
                  Json::Object(r) =>
                    match r.get("model_url") {
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
