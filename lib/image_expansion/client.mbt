///|
/// 图像扩展 API：image-out-painting
/// 使用 DashScope image2image 异步端点
///

///|
/// 默认图像扩展模型
pub let default_model : String = "image-out-painting"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///|
/// 图像扩展请求体
struct ExpansionInput {
  image_url : String
} derive(ToJson)

///|
struct ExpansionParams {
  x_scale : Double?
  y_scale : Double?
} derive(ToJson)

///|
struct ExpansionRequest {
  model : String
  input : ExpansionInput
  parameters : ExpansionParams?
} derive(ToJson)

///| 提交图像扩展异步任务

///|
/// 返回任务 ID
pub async fn submit_expansion(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  x_scale? : Double,
  y_scale? : Double,
) -> String {
  let request = ExpansionRequest::{
    model,
    input: ExpansionInput::{ image_url, },
    parameters: Some(ExpansionParams::{ x_scale, y_scale }),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2image/out-painting",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Image expansion submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///| 查询异步任务结果

///|
/// 返回 (状态, 图像 URL 列表)
pub async fn query_task(
  config : @lib.ClientConfig,
  task_id : String,
) -> (String, Array[String]) {
  let (response, resp_body) = @http.get("\{dashscope_base}/tasks/\{task_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("Task query failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  let status = extract_status(resp)
  if status == "SUCCEEDED" {
    (status, extract_urls(resp))
  } else {
    (status, [])
  }
}

///| 图像扩展：提交并轮询等待完成

///|
/// 返回图像 URL 列表
pub async fn expand_image(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  x_scale? : Double,
  y_scale? : Double,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_expansion(config, model, image_url, x_scale?, y_scale?)
  let interval = poll_interval_ms.unwrap_or(3000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Image expansion task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Image expansion task timeout: \{task_id}")
}

///|
/// 便捷函数（使用默认模型，等比扩展）
pub async fn expand_easy(
  config : @lib.ClientConfig,
  image_url : String,
  x_scale? : Double,
  y_scale? : Double,
) -> Array[String] {
  expand_image(config, default_model, image_url, x_scale?, y_scale?)
}

// ---- Internal ----

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
fn extract_urls(resp : Json) -> Array[String] {
  let urls : Array[String] = []
  match resp {
    Json::Object(obj) =>
      match obj.get("output") {
        Some(Json::Object(output)) =>
          match output.get("results") {
            Some(Json::Array(results)) =>
              for r in results {
                match r {
                  Json::Object(robj) =>
                    match robj.get("url") {
                      Some(Json::String(u)) => urls.push(u)
                      _ => ()
                    }
                  _ => ()
                }
              }
            _ =>
              // image2image may use output_image_url
              match output.get("output_image_url") {
                Some(Json::String(u)) => urls.push(u)
                _ => ()
              }
          }
        _ => ()
      }
    _ => ()
  }
  urls
}
