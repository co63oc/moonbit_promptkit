///|
/// 视频生成 API：文生视频、图生视频、首尾帧生视频
/// 端点：
///   - /services/aigc/video-generation/video-synthesis（文生视频、图生视频）
///   - /services/aigc/image2video/video-synthesis（首尾帧生视频）
///
/// 模型：
///   - wan2.7-t2v-2026-04-25 / wan2.6-t2v（文生视频）
///   - wan2.7-i2v-2026-04-25 / wan2.7-i2v（图生视频）
///   - wan2.2-kf2v-flash（首尾帧生视频）
///

///|
/// 默认文生视频模型
pub let default_t2v_model : String = "wan2.7-t2v-2026-04-25"

///|
/// 默认图生视频模型
pub let default_i2v_model : String = "wan2.7-i2v-2026-04-25"

///|
/// 默认首尾帧生视频模型
pub let default_kf2v_model : String = "wan2.2-kf2v-flash"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

// ==== 文生视频 API ====

///|
/// 提交文生视频异步任务，返回 task_id
pub async fn submit_text_to_video(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  resolution? : String,
  ratio? : String,
  duration? : Int,
  prompt_extend? : Bool,
  watermark? : Bool,
  shot_type? : String,
) -> String {
  let input_json = Json::object(Map::Map([("prompt", prompt.to_json())].view()))
  let params_fields : Array[(String, Json)] = []
  match resolution {
    Some(v) => params_fields.push(("resolution", v.to_json()))
    None => ()
  }
  match ratio {
    Some(v) => params_fields.push(("ratio", v.to_json()))
    None => ()
  }
  match duration {
    Some(v) => params_fields.push(("duration", v.to_json()))
    None => ()
  }
  match prompt_extend {
    Some(v) => params_fields.push(("prompt_extend", v.to_json()))
    None => ()
  }
  match watermark {
    Some(v) => params_fields.push(("watermark", v.to_json()))
    None => ()
  }
  match shot_type {
    Some(v) => params_fields.push(("shot_type", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", model.to_json()),
        ("input", input_json),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/video-generation/video-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("T2V submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 文生视频：提交并轮询等待完成，返回视频 URL
pub async fn text_to_video(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  resolution? : String,
  ratio? : String,
  duration? : Int,
  prompt_extend? : Bool,
  watermark? : Bool,
  shot_type? : String,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_text_to_video(
    config,
    model,
    prompt,
    resolution?,
    ratio?,
    duration?,
    prompt_extend?,
    watermark?,
    shot_type?,
  )
  let interval = poll_interval_ms.unwrap_or(10000)
  let max = max_attempts.unwrap_or(120)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, video_url) = query_video_task(config, task_id)
    if status == "SUCCEEDED" {
      return video_url
    } else if status == "FAILED" {
      fail("T2V task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("T2V task timeout: \{task_id}")
}

///|
/// 便捷函数：文生视频（默认模型）
pub async fn t2v_easy(
  config : @lib.ClientConfig,
  prompt : String,
  resolution? : String,
  duration? : Int,
) -> String {
  text_to_video(
    config,
    default_t2v_model,
    prompt,
    resolution=resolution.unwrap_or("720P"),
    ratio="16:9",
    duration=duration.unwrap_or(5),
    prompt_extend=true,
    watermark=true,
  )
}

// ==== 图生视频 API ====

///|
/// 提交图生视频异步任务，返回 task_id
pub async fn submit_image_to_video(
  config : @lib.ClientConfig,
  model : String,
  media : Array[(String, String)],
  prompt? : String,
  resolution? : String,
  duration? : Int,
  prompt_extend? : Bool,
  watermark? : Bool,
) -> String {
  let media_arr : Array[Json] = []
  for type_, url in media.iter() {
    media_arr.push(
      Json::object(
        Map::Map([("type", type_.to_json()), ("url", url.to_json())].view()),
      ),
    )
  }
  let input_fields : Array[(String, Json)] = [("media", media_arr.to_json())]
  match prompt {
    Some(v) => input_fields.push(("prompt", v.to_json()))
    None => ()
  }
  let params_fields : Array[(String, Json)] = []
  match resolution {
    Some(v) => params_fields.push(("resolution", v.to_json()))
    None => ()
  }
  match duration {
    Some(v) => params_fields.push(("duration", v.to_json()))
    None => ()
  }
  match prompt_extend {
    Some(v) => params_fields.push(("prompt_extend", v.to_json()))
    None => ()
  }
  match watermark {
    Some(v) => params_fields.push(("watermark", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", model.to_json()),
        ("input", Json::object(Map::Map(input_fields.view()))),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/video-generation/video-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("I2V submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 图生视频：提交并轮询等待完成，返回视频 URL
pub async fn image_to_video(
  config : @lib.ClientConfig,
  model : String,
  media : Array[(String, String)],
  prompt? : String,
  resolution? : String,
  duration? : Int,
  prompt_extend? : Bool,
  watermark? : Bool,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_image_to_video(
    config,
    model,
    media,
    prompt?,
    resolution?,
    duration?,
    prompt_extend?,
    watermark?,
  )
  let interval = poll_interval_ms.unwrap_or(10000)
  let max = max_attempts.unwrap_or(120)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, video_url) = query_video_task(config, task_id)
    if status == "SUCCEEDED" {
      return video_url
    } else if status == "FAILED" {
      fail("I2V task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("I2V task timeout: \{task_id}")
}

///|
/// 便捷函数：首帧生视频
pub async fn first_frame_to_video(
  config : @lib.ClientConfig,
  first_frame_url : String,
  prompt? : String,
  resolution? : String,
  duration? : Int,
) -> String {
  let media : Array[(String, String)] = [("first_frame", first_frame_url)]
  image_to_video(
    config,
    default_i2v_model,
    media,
    prompt?,
    resolution=resolution.unwrap_or("720P"),
    duration=duration.unwrap_or(5),
    prompt_extend=true,
    watermark=true,
  )
}

///|
/// 便捷函数：视频续写（首视频片段 + 可选尾帧）
pub async fn video_continuation(
  config : @lib.ClientConfig,
  first_clip_url : String,
  last_frame_url? : String,
  prompt? : String,
  duration? : Int,
) -> String {
  let media : Array[(String, String)] = [("first_clip", first_clip_url)]
  match last_frame_url {
    Some(url) => media.push(("last_frame", url))
    None => ()
  }
  image_to_video(
    config,
    default_i2v_model,
    media,
    prompt?,
    resolution="720P",
    duration=duration.unwrap_or(12),
    prompt_extend=true,
    watermark=true,
  )
}

// ==== 首尾帧生视频 API ====

///|
/// 提交首尾帧生视频异步任务，返回 task_id
pub async fn submit_kf2v(
  config : @lib.ClientConfig,
  model : String,
  first_frame_url : String,
  last_frame_url? : String,
  prompt? : String,
  resolution? : String,
  prompt_extend? : Bool,
  watermark? : Bool,
) -> String {
  let input_fields : Array[(String, Json)] = [
    ("first_frame_url", first_frame_url.to_json()),
  ]
  match last_frame_url {
    Some(v) => input_fields.push(("last_frame_url", v.to_json()))
    None => ()
  }
  match prompt {
    Some(v) => input_fields.push(("prompt", v.to_json()))
    None => ()
  }
  let params_fields : Array[(String, Json)] = []
  match resolution {
    Some(v) => params_fields.push(("resolution", v.to_json()))
    None => ()
  }
  match prompt_extend {
    Some(v) => params_fields.push(("prompt_extend", v.to_json()))
    None => ()
  }
  match watermark {
    Some(v) => params_fields.push(("watermark", v.to_json()))
    None => ()
  }
  let request = Json::object(
    Map::Map(
      [
        ("model", model.to_json()),
        ("input", Json::object(Map::Map(input_fields.view()))),
        ("parameters", Json::object(Map::Map(params_fields.view()))),
      ].view(),
    ),
  )
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/image2video/video-synthesis",
    request,
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("KF2V submit failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  extract_task_id(resp)
}

///|
/// 首尾帧生视频：提交并轮询等待完成，返回视频 URL
pub async fn kf2v_video(
  config : @lib.ClientConfig,
  model : String,
  first_frame_url : String,
  last_frame_url? : String,
  prompt? : String,
  resolution? : String,
  prompt_extend? : Bool,
  watermark? : Bool,
  poll_interval_ms? : Int,
  max_attempts? : Int,
) -> String {
  let task_id = submit_kf2v(
    config,
    model,
    first_frame_url,
    last_frame_url?,
    prompt?,
    resolution?,
    prompt_extend?,
    watermark?,
  )
  let interval = poll_interval_ms.unwrap_or(10000)
  let max = max_attempts.unwrap_or(120)
  let mut attempt = 0
  while attempt < max {
    @async.sleep(interval)
    let (status, video_url) = query_video_task(config, task_id)
    if status == "SUCCEEDED" {
      return video_url
    } else if status == "FAILED" {
      fail("KF2V task failed: \{task_id}")
    }
    attempt = attempt + 1
  }
  fail("KF2V task timeout: \{task_id}")
}

///|
/// 便捷函数：首尾帧生视频（默认模型）
pub async fn kf2v_easy(
  config : @lib.ClientConfig,
  first_frame_url : String,
  last_frame_url : String,
  prompt? : String,
) -> String {
  kf2v_video(
    config,
    default_kf2v_model,
    first_frame_url,
    last_frame_url~,
    prompt?,
    resolution="720P",
    prompt_extend=true,
    watermark=true,
  )
}

// ==== 共享异步任务查询 ====

///|
/// 查询视频异步任务，返回 (状态, video_url)
pub async fn query_video_task(
  config : @lib.ClientConfig,
  task_id : String,
) -> (String, String) {
  let (response, resp_body) = @http.get("\{dashscope_base}/tasks/\{task_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("Task query failed: \{response.code} \{response.reason}")
  }
  let resp : Json = @json.from_json(resp_body.json())
  let status = extract_status(resp)
  if status == "SUCCEEDED" {
    let video_url = extract_video_url(resp)
    (status, video_url)
  } else {
    (status, "")
  }
}

///|
/// 查询异步任务结果（图像类），返回 (状态, URL 列表)
pub async fn query_task(
  config : @lib.ClientConfig,
  task_id : String,
) -> (String, Array[String]) {
  let (status, video_url) = query_video_task(config, task_id)
  if video_url != "" {
    (status, [video_url])
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
