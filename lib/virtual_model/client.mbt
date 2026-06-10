///|
/// 虚拟模特生成 API
/// - virtualmodel-v2 / wanx-virtualmodel（虚拟模特 V1/V2）
/// - shoemodel-v1（鞋靴模特）
/// 端点：/services/aigc/virtualmodel/generation（异步）
///

///|
/// 默认虚拟模特模型（V2）
pub let default_model : String = "virtualmodel-v2"

///|
/// 鞋靴模特默认模型
pub let default_shoe_model : String = "shoemodel-v1"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///|
/// 虚拟模特请求 input
struct VirtualModelInput {
  base_image_url : String
  mask_image_url : String?
  prompt : String?
  face_prompt : String?
  background_image_url : String?
} derive(ToJson)

///|
/// 虚拟模特请求 parameters
struct VirtualModelParams {
  short_side_size : String?
  n : Int?
  aspect_ratio : String?
} derive(ToJson)

///|
/// 虚拟模特完整请求
struct VirtualModelRequest {
  model : String
  input : VirtualModelInput
  parameters : VirtualModelParams?
} derive(ToJson)

///|
/// 鞋靴模特请求 input
struct ShoeModelInput {
  template_image_url : String
  shoe_image_url : Array[String]
} derive(ToJson)

///|
/// 鞋靴模特请求 parameters
struct ShoeModelParams {
  n : Int?
} derive(ToJson)

///|
/// 鞋靴模特完整请求
struct ShoeModelRequest {
  model : String
  input : ShoeModelInput
  parameters : ShoeModelParams?
} derive(ToJson)

///|
/// 提交虚拟模特生成异步任务，返回 task_id
pub async fn submit_virtual_model(
  config : @lib.ClientConfig,
  model : String,
  base_image_url : String,
  mask_image_url? : String,
  prompt? : String,
  face_prompt? : String,
  background_image_url? : String,
  short_side_size? : String,
  n? : Int,
  aspect_ratio? : String,
) -> String {
  let request = VirtualModelRequest::{
    model,
    input: VirtualModelInput::{
      base_image_url,
      mask_image_url,
      prompt,
      face_prompt,
      background_image_url,
    },
    parameters: Some(VirtualModelParams::{ short_side_size, n, aspect_ratio }),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/virtualmodel/generation",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Virtual model submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 虚拟模特生成：提交并轮询等待完成，返回图像 URL 列表
pub async fn generate_virtual_model(
  config : @lib.ClientConfig,
  model : String,
  base_image_url : String,
  mask_image_url? : String,
  prompt? : String,
  face_prompt? : String,
  background_image_url? : String,
  short_side_size? : String,
  n? : Int,
  aspect_ratio? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_virtual_model(
    config,
    model,
    base_image_url,
    mask_image_url?,
    prompt?,
    face_prompt?,
    background_image_url?,
    short_side_size?,
    n?,
    aspect_ratio?,
  )
  let interval = poll_interval_ms.unwrap_or(5000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Virtual model task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Virtual model task timeout: \{task_id}")
}

///|
/// 便捷函数：使用默认 V2 模型
pub async fn virtual_model_easy(
  config : @lib.ClientConfig,
  base_image_url : String,
  mask_image_url? : String,
  prompt? : String,
  face_prompt? : String,
) -> Array[String] {
  generate_virtual_model(
    config,
    default_model,
    base_image_url,
    mask_image_url?,
    prompt?,
    face_prompt?,
    short_side_size="1024",
    n=1,
  )
}

///|
/// 提交鞋靴模特异步任务，返回 task_id
pub async fn submit_shoe_model(
  config : @lib.ClientConfig,
  template_image_url : String,
  shoe_image_url : Array[String],
  n? : Int,
) -> String {
  let request = ShoeModelRequest::{
    model: default_shoe_model,
    input: ShoeModelInput::{ template_image_url, shoe_image_url },
    parameters: Some(ShoeModelParams::{ n, }),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/virtualmodel/generation",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Shoe model submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 鞋靴模特生成：提交并轮询等待完成，返回图像 URL 列表
pub async fn generate_shoe_model(
  config : @lib.ClientConfig,
  template_image_url : String,
  shoe_image_url : Array[String],
  n? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_shoe_model(
    config,
    template_image_url,
    shoe_image_url,
    n?,
  )
  let interval = poll_interval_ms.unwrap_or(5000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Shoe model task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Shoe model task timeout: \{task_id}")
}

///|
/// 便捷函数：鞋靴模特生成
pub async fn shoe_model_easy(
  config : @lib.ClientConfig,
  template_image_url : String,
  shoe_image_url : String,
) -> Array[String] {
  generate_shoe_model(config, template_image_url, [shoe_image_url], n=1)
}

///|
/// 查询异步任务结果，返回 (状态, URL 列表)
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
