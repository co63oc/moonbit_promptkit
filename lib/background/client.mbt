///|
/// 背景生成 API：wanx-background-generation-v2
/// 使用 DashScope image-generation 异步端点
///

///|
/// 默认背景生成模型
pub let default_model : String = "wanx-background-generation-v2"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///| 提交背景生成异步任务

///|
/// 返回任务 ID
pub async fn submit_background(
  config : @lib.ClientConfig,
  model : String,
  base_image_url : String,
  ref_prompt? : String,
  ref_image_url? : String,
  n? : Int,
  size? : String,
) -> String {
  // 手动构建 input JSON，避免 None 字段被序列化为 null
  let input_fields : Array[(String, Json)] = [
    ("base_image_url", base_image_url.to_json()),
  ]
  match ref_prompt {
    Some(v) => input_fields.push(("ref_prompt", v.to_json()))
    None => ()
  }
  match ref_image_url {
    Some(v) => input_fields.push(("ref_image_url", v.to_json()))
    None => ()
  }
  let input_json = Json::object(Map::Map(input_fields.view()))

  // 手动构建 parameters JSON
  let param_fields : Array[(String, Json)] = [("model_version", "v3".to_json())]
  match n {
    Some(v) => param_fields.push(("n", v.to_json()))
    None => ()
  }
  match size {
    Some(v) => param_fields.push(("size", v.to_json()))
    None => ()
  }
  let parameters_json = if param_fields.length() > 0 {
    Some(Json::object(Map::Map(param_fields.view())))
  } else {
    None
  }

  // 构建请求 JSON
  let request_fields : Array[(String, Json)] = [
    ("model", model.to_json()),
    ("input", input_json),
  ]
  match parameters_json {
    Some(v) => request_fields.push(("parameters", v))
    None => ()
  }
  let request = Json::object(Map::Map(request_fields.view()))

  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/background-generation/generation",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    let error_body = resp_body.text()
    fail(
      "Background gen submit failed: \{response.code} \{response.reason}\n\{error_body}",
    )
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

///| 背景生成：提交并轮询等待完成

///|
/// 返回图像 URL 列表
pub async fn generate_background(
  config : @lib.ClientConfig,
  model : String,
  base_image_url : String,
  ref_prompt? : String,
  ref_image_url? : String,
  n? : Int,
  size? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_background(
    config,
    model,
    base_image_url,
    ref_prompt?,
    ref_image_url?,
    n?,
    size?,
  )
  let interval = poll_interval_ms.unwrap_or(3000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Background gen task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Background gen task timeout: \{task_id}")
}

///|
/// 便捷函数（使用默认模型）
pub async fn background_easy(
  config : @lib.ClientConfig,
  base_image_url : String,
  ref_prompt? : String,
) -> Array[String] {
  generate_background(config, default_model, base_image_url, ref_prompt?)
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
            _ => ()
          }
        _ => ()
      }
    _ => ()
  }
  urls
}
