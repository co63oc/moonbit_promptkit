///|
/// 风格重绘 API：wanx-style-repaint-v1
/// 使用 DashScope image-generation 异步端点
///

///|
/// 默认风格重绘模型
pub let default_model : String = "wanx-style-repaint-v1"

///| 可用的风格索引

///| 1: 二次元  2: 3D卡通  3: 动漫  4: 插画  5: 水彩

///| 6: 国画  7: 油画  8: 像素风  9: 赛博朋克  10: 蒸汽波

///|
/// 11: 漫画  12: 复古海报  13: 暗黑  14: 扁平插画  15: 3D写实
pub let style_names : Array[String] = [
  "二次元", "3D卡通", "动漫", "插画", "水彩", "国画", "油画", "像素风",
  "赛博朋克", "蒸汽波", "漫画", "复古海报", "暗黑", "扁平插画",
  "3D写实",
]

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///|
/// 风格重绘请求体
struct StyleRepaintInput {
  image_url : String
  style_index : Int
} derive(ToJson)

///|
struct StyleRepaintRequest {
  model : String
  input : StyleRepaintInput
} derive(ToJson)

///| 提交风格重绘异步任务

///|
/// 返回任务 ID
pub async fn submit_style_repaint(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  style_index : Int,
) -> String {
  let request = StyleRepaintRequest::{
    model,
    input: StyleRepaintInput::{ image_url, style_index },
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image-generation/generation",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("Style repaint submit failed: \{response.code} \{response.reason}")
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

///| 风格重绘：提交并轮询等待完成

///|
/// 返回图像 URL 列表
pub async fn style_repaint(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  style_index : Int,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> Array[String] {
  let task_id = submit_style_repaint(config, model, image_url, style_index)
  let interval = poll_interval_ms.unwrap_or(3000)
  let max = max_attempts.unwrap_or(60)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, urls) = query_task(config, task_id)
    if status == "SUCCEEDED" {
      return urls
    } else if status == "FAILED" {
      fail("Style repaint task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("Style repaint task timeout: \{task_id}")
}

///|
/// 便捷函数（使用默认模型）
pub async fn style_repaint_easy(
  config : @lib.ClientConfig,
  image_url : String,
  style_index : Int,
) -> Array[String] {
  style_repaint(config, default_model, image_url, style_index)
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
