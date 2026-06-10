///|
/// 图像处理 API：实例分割、擦除补全、局部重绘、涂鸦作画
/// 端点：/services/aigc/image2image/image-synthesis（异步）
///
/// 模型：
///   - image-instance-segmentation（实例分割）
///   - image-erase-completion（擦除补全）
///   - wanx-x-painting（局部重绘）
///   - wanx-sketch-to-image-lite（涂鸦作画）
///

///|
/// 默认实例分割模型
pub let default_segmentation_model : String = "image-instance-segmentation"

///|
/// 默认擦除补全模型
pub let default_erase_model : String = "image-erase-completion"

///|
/// 默认局部重绘模型
pub let default_repaint_model : String = "wanx-x-painting"

///|
/// 默认涂鸦作画模型
pub let default_sketch_model : String = "wanx-sketch-to-image-lite"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

// ==== 实例分割 API ====

///|
/// 提交实例分割异步任务，返回 task_id
pub async fn submit_segmentation(
  config : @lib.ClientConfig,
  image_url : String,
) -> String {
  let request = Json::object(
    Map::Map(
      [
        ("model", default_segmentation_model.to_json()),
        (
          "input",
          Json::object(Map::Map([("image_url", image_url.to_json())].view())),
        ),
        ("parameters", Json::object(Map::Map([].view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2image/image-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Segmentation submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 实例分割：提交并轮询等待完成，返回图像 URL 列表
pub async fn segment_image(
  config : @lib.ClientConfig,
  image_url : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_segmentation(config, image_url)
  let interval = poll_interval_ms.unwrap_or(5000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Segmentation task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Segmentation task timeout: \{task_id}")
}

// ==== 擦除补全 API ====

///|
/// 提交擦除补全异步任务，返回 task_id
pub async fn submit_erase(
  config : @lib.ClientConfig,
  image_url : String,
  mask_url? : String,
  foreground_url? : String,
  dilate_flag? : Bool,
  fast_mode? : Bool,
) -> String {
  let input_fields : Array[(String, Json)] = [
    ("image_url", image_url.to_json()),
  ]
  match mask_url {
    Some(v) => input_fields.push(("mask_url", v.to_json()))
    None => ()
  }
  match foreground_url {
    Some(v) => input_fields.push(("foreground_url", v.to_json()))
    None => ()
  }
  let params_fields : Array[(String, Json)] = []
  match dilate_flag {
    Some(v) => params_fields.push(("dilate_flag", v.to_json()))
    None => ()
  }
  match fast_mode {
    Some(v) => params_fields.push(("fast_mode", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", default_erase_model.to_json()),
        ("input", Json::object(Map::Map(input_fields.view()))),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2image/image-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Erase submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 擦除补全：提交并轮询等待完成，返回图像 URL 列表
pub async fn erase_image(
  config : @lib.ClientConfig,
  image_url : String,
  mask_url? : String,
  foreground_url? : String,
  dilate_flag? : Bool,
  fast_mode? : Bool,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_erase(
    config,
    image_url,
    mask_url?,
    foreground_url?,
    dilate_flag?,
    fast_mode?,
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
      fail("Erase task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Erase task timeout: \{task_id}")
}

///|
/// 便捷函数：使用 mask 擦除
pub async fn erase_easy(
  config : @lib.ClientConfig,
  image_url : String,
  mask_url : String,
) -> Array[String] {
  erase_image(config, image_url, mask_url~, dilate_flag=true)
}

// ==== 局部重绘 API ====

///|
/// 提交局部重绘异步任务，返回 task_id
pub async fn submit_repaint(
  config : @lib.ClientConfig,
  prompt : String,
  base_image_url : String,
  mask_image_url : String,
  size? : String,
  n? : Int,
) -> String {
  let input_json = Json::object(
    Map::Map(
      [
        ("prompt", prompt.to_json()),
        ("base_image_url", base_image_url.to_json()),
        ("mask_image_url", mask_image_url.to_json()),
      ].view(),
    ),
  )
  let params_fields : Array[(String, Json)] = []
  match size {
    Some(v) => params_fields.push(("size", v.to_json()))
    None => ()
  }
  match n {
    Some(v) => params_fields.push(("n", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", default_repaint_model.to_json()),
        ("input", input_json),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2image/image-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Repaint submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 局部重绘：提交并轮询等待完成，返回图像 URL 列表
pub async fn repaint_image(
  config : @lib.ClientConfig,
  prompt : String,
  base_image_url : String,
  mask_image_url : String,
  size? : String,
  n? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_repaint(
    config,
    prompt,
    base_image_url,
    mask_image_url,
    size?,
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
      fail("Repaint task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Repaint task timeout: \{task_id}")
}

///|
/// 便捷函数：局部重绘
pub async fn repaint_easy(
  config : @lib.ClientConfig,
  prompt : String,
  base_image_url : String,
  mask_image_url : String,
) -> Array[String] {
  repaint_image(
    config,
    prompt,
    base_image_url,
    mask_image_url,
    size="1024*1024",
    n=1,
  )
}

// ==== 涂鸦作画 API ====

///|
/// 可用涂鸦风格
pub let sketch_styles : Array[String] = [
  "<flat>", "<oil>", "<anime>", "<3d>", "<watercolor>",
]

///|
/// 提交涂鸦作画异步任务，返回 task_id
pub async fn submit_sketch(
  config : @lib.ClientConfig,
  sketch_image_url : String,
  prompt : String,
  size? : String,
  n? : Int,
  sketch_weight? : Int,
  style? : String,
) -> String {
  let input_json = Json::object(
    Map::Map(
      [
        ("sketch_image_url", sketch_image_url.to_json()),
        ("prompt", prompt.to_json()),
      ].view(),
    ),
  )
  let params_fields : Array[(String, Json)] = []
  match size {
    Some(v) => params_fields.push(("size", v.to_json()))
    None => ()
  }
  match n {
    Some(v) => params_fields.push(("n", v.to_json()))
    None => ()
  }
  match sketch_weight {
    Some(v) => params_fields.push(("sketch_weight", v.to_json()))
    None => ()
  }
  match style {
    Some(v) => params_fields.push(("style", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", default_sketch_model.to_json()),
        ("input", input_json),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2image/image-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Sketch submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 涂鸦作画：提交并轮询等待完成，返回图像 URL 列表
pub async fn sketch_to_image(
  config : @lib.ClientConfig,
  sketch_image_url : String,
  prompt : String,
  size? : String,
  n? : Int,
  sketch_weight? : Int,
  style? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_sketch(
    config,
    sketch_image_url,
    prompt,
    size?,
    n?,
    sketch_weight?,
    style?,
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
      fail("Sketch task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Sketch task timeout: \{task_id}")
}

///|
/// 便捷函数：涂鸦作画（水彩风格）
pub async fn sketch_easy(
  config : @lib.ClientConfig,
  sketch_image_url : String,
  prompt : String,
  style? : String,
) -> Array[String] {
  sketch_to_image(
    config,
    sketch_image_url,
    prompt,
    size="768*768",
    n=2,
    sketch_weight=3,
    style=style.unwrap_or("<watercolor>"),
  )
}

// ==== 共享异步任务查询 ====

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
