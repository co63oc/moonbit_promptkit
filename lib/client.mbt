///|
/// Core client functions for Moonbit Bailian SDK
///

///|
pub async fn generate(config : ClientConfig, request : Request) -> Response {
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
pub async fn chat(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_with_search(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: Some(true),
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_with_tools(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  tools : Json,
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: Some(tools),
    extra_body: Some(@json.parse("{\"enable_thinking\": false}")),
    enable_search: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
pub async fn chat_stream(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  on_delta : (String) -> Unit,
) -> String {
  let request = Request::{
    model,
    messages,
    stream: Some(true),
    stream_options: Some(StreamOptions::{ include_usage: true }),
    tools: None,
    extra_body: None,
    enable_search: None,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  body_text
}

///|
/// 创建图像生成任务
pub async fn create_image_gen_task(
  config : ClientConfig,
  model : String,
  prompt : String,
  negative_prompt : String?,
  style : String?,
  size : String?,
  n : Int?,
) -> ImageGenResponse {
  let input = ImageGenInput::{ prompt, negative_prompt, ref_img: None }
  let parameters = ImageGenParameters::{
    style,
    size,
    n,
    seed: None,
    ref_strength: None,
    ref_mode: None,
  }
  let request = ImageGenRequest::{ model, input, parameters: Some(parameters) }
  let (response, body) = @http.post(
    "https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
      "X-DashScope-Async": "enable",
    },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// 查询图像生成任务结果
pub async fn get_image_gen_result(
  config : ClientConfig,
  task_id : String,
) -> ImageGenResponse {
  let (response, body) = @http.get(
    "https://dashscope.aliyuncs.com/api/v1/tasks/\{task_id}",
    headers={ "Authorization": "Bearer \{config.api_key}" },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Simplified image generation function - create task and poll for completion
pub async fn generate_image(
  config : ClientConfig,
  prompt : String,
) -> Array[String] {
  // Create task
  let task_response = create_image_gen_task(
    config,
    "wanx-v1",
    prompt,
    None,
    Some("<auto>"),
    Some("1024*1024"),
    Some(1),
  )

  let task_id = task_response.output.task_id
  println("Task created: " + task_id)

  // Poll for task completion in loop
  let max_attempts = 20
  let interval_ms = 2000
  let mut attempt = 1
  let mut final_status = ""

  while attempt <= max_attempts {
    // Wait before checking
    @async.sleep(interval_ms)

    // Check status
    let response = get_image_gen_result(config, task_id)
    let status = response.output.task_status
    println("Attempt " + attempt.to_string() + ": Task status - " + status)

    // Check if task is complete
    if status == "SUCCEEDED" {
      println("Task completed successfully!")
      final_status = status
      break
    } else if status == "FAILED" {
      println("Task failed.")
      final_status = status
      break
    }

    // Increment attempt counter
    attempt = attempt + 1
  }

  // Check if we timed out
  if attempt > max_attempts && final_status == "" {
    println("Task timeout after " + max_attempts.to_string() + " attempts")
    final_status = "TIMEOUT"
  }

  // Return task info and status
  [task_id, final_status]
}
