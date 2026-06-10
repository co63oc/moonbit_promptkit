///|
/// 创意海报生成 API：wanx-poster-generation-v1
/// 端点：/services/aigc/text2image/image-synthesis（异步）
///

///|
/// 默认海报模型
pub let default_model : String = "wanx-poster-generation-v1"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///|
/// 可用海报风格
pub let poster_styles : Array[String] = [
  "中国刺绣", "2D插画1", "浅蓝抽象", "深蓝抽象", "童话油画", "剪纸工艺",
  "浓郁色彩",
]

// ==== API ====

///|
/// 提交创意海报生成异步任务，返回 task_id
pub async fn submit_poster(
  config : @lib.ClientConfig,
  model : String,
  title : String,
  sub_title? : String,
  body_text? : String,
  prompt_text_zh? : String,
  prompt_text_en? : String,
  wh_ratios? : String,
  lora_name? : String,
  lora_weight? : Double,
  ctrl_ratio? : Double,
  ctrl_step? : Double,
  generate_num? : Int,
) -> String {
  let fields : Array[(String, Json)] = [("title", title.to_json())]
  match sub_title {
    Some(v) => fields.push(("sub_title", v.to_json()))
    None => ()
  }
  match body_text {
    Some(v) => fields.push(("body_text", v.to_json()))
    None => ()
  }
  match prompt_text_zh {
    Some(v) => fields.push(("prompt_text_zh", v.to_json()))
    None => ()
  }
  match prompt_text_en {
    Some(v) => fields.push(("prompt_text_en", v.to_json()))
    None => ()
  }
  match wh_ratios {
    Some(v) => fields.push(("wh_ratios", v.to_json()))
    None => ()
  }
  match lora_name {
    Some(v) => fields.push(("lora_name", v.to_json()))
    None => ()
  }
  match lora_weight {
    Some(v) => fields.push(("lora_weight", v.to_json()))
    None => ()
  }
  match ctrl_ratio {
    Some(v) => fields.push(("ctrl_ratio", v.to_json()))
    None => ()
  }
  match ctrl_step {
    Some(v) => fields.push(("ctrl_step", v.to_json()))
    None => ()
  }
  fields.push(("generate_mode", "generate".to_json()))
  match generate_num {
    Some(v) => fields.push(("generate_num", v.to_json()))
    None => ()
  }
  let input_json = Json::object(Map::Map(fields.view()))
  let request = Json::object(
    Map::Map([("model", model.to_json()), ("input", input_json)].view()),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/text2image/image-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Poster submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 创意海报生成：提交并轮询等待完成，返回图像 URL 列表
pub async fn generate_poster(
  config : @lib.ClientConfig,
  model : String,
  title : String,
  sub_title? : String,
  body_text? : String,
  prompt_text_zh? : String,
  prompt_text_en? : String,
  wh_ratios? : String,
  lora_name? : String,
  lora_weight? : Double,
  ctrl_ratio? : Double,
  ctrl_step? : Double,
  generate_num? : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_poster(
    config,
    model,
    title,
    sub_title?,
    body_text?,
    prompt_text_zh?,
    prompt_text_en?,
    wh_ratios?,
    lora_name?,
    lora_weight?,
    ctrl_ratio?,
    ctrl_step?,
    generate_num?,
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
      fail("Poster task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Poster task timeout: \{task_id}")
}

///|
/// 便捷函数：中文提示词海报
pub async fn poster_easy(
  config : @lib.ClientConfig,
  title : String,
  prompt_zh : String,
  lora_name? : String,
  wh_ratios? : String,
) -> Array[String] {
  generate_poster(
    config,
    default_model,
    title,
    prompt_text_zh=prompt_zh,
    lora_name?,
    wh_ratios=wh_ratios.unwrap_or("竖版"),
    lora_weight=0.8,
    ctrl_ratio=0.7,
    ctrl_step=0.7,
    generate_num=1,
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
