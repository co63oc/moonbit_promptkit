///|
/// 文生图 API：支持 Qwen-Image、Wan2.7 等模型
/// 分为两种调用模式：
///   1. 同步模式 (multimodal-generation)：Qwen-Image 系列、Wan2.7 同步
///   2. 异步模式 (text2image/image-synthesis)：Wanx-v1 等传统模型
///

///|
/// 默认文生图模型
pub let default_model : String = "wan2.7-image-pro"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///| 同步文生图：使用 multimodal-generation 端点（Qwen-Image / Wan2.7 同步）

///|
/// 返回生成的图像 URL 列表
pub async fn generate_sync(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  n? : Int,
  size? : String,
  negative_prompt? : String,
  watermark? : Bool,
  prompt_extend? : Bool,
) -> Array[String] {
  let text_item = TextContent::{ text: prompt }
  let message = ImageGenMessage::{
    role: "user",
    content: [text_item.to_json()],
  }
  let params = SyncImageGenParams::{
    n,
    size,
    negative_prompt,
    watermark,
    prompt_extend,
  }
  let request = SyncImageGenRequest::{
    model,
    input: SyncImageGenInput::{ messages: [message] },
    parameters: Some(params),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/multimodal-generation/generation",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Image gen request failed: \{response.code} \{response.reason}")
  }
  let resp : ImageGenResponse = @json.from_json(resp_body.json())
  match resp.code {
    Some(code) if code != "" =>
      fail("Image gen error: \{code} \{resp.message.unwrap_or("")}")
    _ => ()
  }
  extract_image_urls(resp)
}

///| 异步文生图：提交任务（传统 text2image 端点）

///|
/// 返回任务 ID
pub async fn submit_async_task(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  n? : Int,
  size? : String,
  style? : String,
  negative_prompt? : String,
) -> String {
  let request = AsyncImageGenRequest::{
    model,
    input: AsyncImageGenInput::{ prompt, negative_prompt, style },
    parameters: Some(AsyncImageGenParams::{ n, size }),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/text2image/image-synthesis",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Async image gen submit failed: \{response.code} \{response.reason}")
  }
  let resp : AsyncTaskResponse = @json.from_json(resp_body.json())
  extract_task_id(resp.output)
}

///| 查询异步任务结果

///|
/// 返回 (状态, 图像 URL 列表)
pub async fn query_async_task(
  config : @lib.ClientConfig,
  task_id : String,
) -> (String, Array[String]) {
  let (response, resp_body) = @http.get("\{dashscope_base}/tasks/\{task_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("Async task query failed: \{response.code} \{response.reason}")
  }
  let resp : AsyncTaskResult = @json.from_json(resp_body.json())
  let status = extract_task_status(resp.output)
  if status == "SUCCEEDED" {
    (status, extract_result_urls(resp.output))
  } else {
    (status, [])
  }
}

///| 异步文生图：提交任务并轮询等待完成

///|
/// 返回图像 URL 列表
pub async fn generate_async(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  n? : Int,
  size? : String,
  style? : String,
  negative_prompt? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_async_task(
    config,
    model,
    prompt,
    n?,
    size?,
    style?,
    negative_prompt?,
  )
  let interval = poll_interval_ms.unwrap_or(3000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_async_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Async image gen task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Async image gen task timeout: \{task_id}")
}

///|
/// 便捷函数：同步文生图（使用默认模型）
pub async fn text_to_image(
  config : @lib.ClientConfig,
  prompt : String,
  n? : Int,
  size? : String,
) -> Array[String] {
  generate_sync(config, default_model, prompt, n?, size?)
}

///|
/// 便捷函数：异步文生图并等待（使用 wanx-v1）
pub async fn text_to_image_async(
  config : @lib.ClientConfig,
  prompt : String,
  n? : Int,
  size? : String,
) -> Array[String] {
  generate_async(config, "wanx-v1", prompt, n?, size?)
}

// ---- Internal helpers ----

///|
fn extract_image_urls(resp : ImageGenResponse) -> Array[String] {
  let urls : Array[String] = []
  match resp.output.choices {
    Some(choices) =>
      for choice in choices {
        for item in choice.message.content {
          match item.image {
            Some(url) => urls.push(url)
            None => ()
          }
        }
      }
    None => ()
  }
  urls
}

///|
fn extract_task_id(output : Json) -> String {
  match output {
    Json::Object(obj) =>
      match obj.get("task_id") {
        Some(Json::String(id)) => id
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}

///|
fn extract_task_status(output : Json) -> String {
  match output {
    Json::Object(obj) =>
      match obj.get("task_status") {
        Some(Json::String(s)) => s
        _ => "UNKNOWN"
      }
    _ => "UNKNOWN"
  }
}

///|
fn extract_result_urls(output : Json) -> Array[String] {
  let urls : Array[String] = []
  match output {
    Json::Object(obj) =>
      // Pattern 1: results array (text2image)
      match obj.get("results") {
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
          // Pattern 2: output_image_url (image2image)
          match obj.get("output_image_url") {
            Some(Json::String(u)) => urls.push(u)
            _ => ()
          }
      }
    _ => ()
  }
  urls
}
