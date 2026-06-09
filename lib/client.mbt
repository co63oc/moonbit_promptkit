///|
/// Core client functions for Moonbit Promptkit SDK
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
    enable_thinking: None,
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
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
    enable_thinking: None,
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
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
    extra_body: None,
    enable_search: None,
    enable_thinking: Some(false),
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
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
    enable_thinking: None,
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
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
/// Deep thinking stream result: reasoning + answer
pub struct ThinkingResult {
  reasoning : String
  answer : String
}

///|
/// Parse SSE stream data, extract reasoning_content and content
fn parse_thinking_sse(body_text : String) -> ThinkingResult {
  let mut reasoning = ""
  let mut answer = ""
  let lines = body_text.split("\n")
  for line in lines {
    let trimmed = line.trim()
    if trimmed.has_prefix("data: ") && !trimmed.has_suffix("[DONE]") {
      // "data: " is 6 chars, extract JSON from index 6
      let json_str = trimmed.to_owned()[6:]
      try {
        let json = @json.parse(json_str)
        match json {
          Json::Object(obj) =>
            match obj.get("choices") {
              Some(Json::Array(choices)) =>
                if choices.length() > 0 {
                  match choices[0] {
                    Json::Object(choice_obj) =>
                      match choice_obj.get("delta") {
                        Some(Json::Object(delta_obj)) => {
                          // Extract reasoning_content
                          match delta_obj.get("reasoning_content") {
                            Some(Json::String(s)) => reasoning = reasoning + s
                            _ => ignore(())
                          }
                          // Extract content
                          match delta_obj.get("content") {
                            Some(Json::String(s)) => answer = answer + s
                            _ => ignore(())
                          }
                        }
                        _ => ignore(())
                      }
                    _ => ignore(())
                  }
                }
              _ => ignore(())
            }
          _ => ignore(())
        }
      } catch {
        _ => ignore(())
      }
    }
  }
  ThinkingResult::{ reasoning, answer }
}

///|
/// Chat with deep thinking enabled (streaming)
/// Returns ThinkingResult with both reasoning process and final answer
pub async fn chat_stream_thinking(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> ThinkingResult {
  let request = Request::{
    model,
    messages,
    stream: Some(true),
    stream_options: Some(StreamOptions::{ include_usage: true }),
    tools: None,
    extra_body: None,
    enable_search: None,
    enable_thinking: Some(true),
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
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
  // Parse SSE stream and separate reasoning from answer
  let result = parse_thinking_sse(body_text)
  // Call callbacks with final content
  if result.reasoning.length() > 0 {
    on_reasoning_delta(result.reasoning)
  }
  if result.answer.length() > 0 {
    on_answer_delta(result.answer)
  }
  result
}

///|
/// Chat with deep thinking enabled (non-streaming)
pub async fn chat_thinking(
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
    enable_thinking: Some(true),
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
/// Chat with optional generation parameters
pub async fn chat_with_params(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  temperature : Float?,
  top_p : Float?,
  max_tokens : Int?,
  seed : Int?,
) -> Message {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
    enable_thinking: None,
    top_p,
    temperature,
    presence_penalty: None,
    n: None,
    max_tokens,
    seed,
    stop: None,
  }
  let response = generate(config, request)
  if response.choices.length() == 0 {
    fail("No response from model")
  } else {
    response.choices[0].message
  }
}

///|
/// Chat and return full response (including usage info for cache statistics)
pub async fn chat_full(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Response {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
    enable_thinking: None,
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
  }
  generate(config, request)
}

///|
/// Chat with parameters and return full response (including usage info)
pub async fn chat_full_with_params(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  temperature : Float?,
  top_p : Float?,
  max_tokens : Int?,
  seed : Int?,
) -> Response {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
    enable_thinking: None,
    top_p,
    temperature,
    presence_penalty: None,
    n: None,
    max_tokens,
    seed,
    stop: None,
  }
  generate(config, request)
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

///|
/// Batch Chat - synchronous batch chat completion
/// Uses the batch endpoint which is 50% cheaper but has longer latency
pub async fn batch_chat(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  chat(to_batch_config(config), model, messages)
}

///|
/// Batch Chat with parameters
pub async fn batch_chat_with_params(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  temperature : Float?,
  top_p : Float?,
  max_tokens : Int?,
  seed : Int?,
) -> Message {
  chat_with_params(
    to_batch_config(config),
    model,
    messages,
    temperature,
    top_p,
    max_tokens,
    seed,
  )
}

///|
/// Batch Chat with full response (including usage info)
pub async fn batch_chat_full(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Response {
  chat_full(to_batch_config(config), model, messages)
}

///|
/// Batch Chat with full response and parameters
pub async fn batch_chat_full_with_params(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  temperature : Float?,
  top_p : Float?,
  max_tokens : Int?,
  seed : Int?,
) -> Response {
  chat_full_with_params(
    to_batch_config(config),
    model,
    messages,
    temperature,
    top_p,
    max_tokens,
    seed,
  )
}

///|
/// Batch Chat with web search
pub async fn batch_chat_with_search(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  chat_with_search(to_batch_config(config), model, messages)
}

///|
/// Batch Chat with tools/function calling
pub async fn batch_chat_with_tools(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
  tools : Json,
) -> Message {
  chat_with_tools(to_batch_config(config), model, messages, tools)
}

///|
/// Batch Chat with thinking/reasoning
pub async fn batch_chat_thinking(
  config : ClientConfig,
  model : String,
  messages : Array[Message],
) -> Message {
  chat_thinking(to_batch_config(config), model, messages)
}

///|
/// Create a batch task from input file
pub async fn create_batch(
  config : ClientConfig,
  input_file_id : String,
  endpoint : String,
  completion_window : String,
) -> Batch {
  let request = BatchCreateRequest::{
    input_file_id,
    endpoint,
    completion_window,
    metadata: None,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/batches",
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
/// Get batch task status by ID
pub async fn get_batch(config : ClientConfig, batch_id : String) -> Batch {
  let (response, body) = @http.get("\{config.base_url}/batches/\{batch_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// List batch tasks
pub async fn list_batches(
  config : ClientConfig,
  limit : Int?,
  after : String?,
) -> BatchListResponse {
  let mut url = "\{config.base_url}/batches"
  let mut has_query = false
  match limit {
    Some(n) => {
      url = url + (if has_query { "&" } else { "?" }) + "limit=" + n.to_string()
      has_query = true
    }
    None => ignore(())
  }
  match after {
    Some(a) => {
      url = url + (if has_query { "&" } else { "?" }) + "after=" + a
      has_query = true
    }
    None => ignore(())
  }
  let (response, body) = @http.get(url, headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Cancel a batch task
pub async fn cancel_batch(config : ClientConfig, batch_id : String) -> Batch {
  let (response, body) = @http.post(
    "\{config.base_url}/batches/\{batch_id}/cancel",
    ().to_json(),
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
/// Get file content by file ID
pub async fn get_file_content(
  config : ClientConfig,
  file_id : String,
) -> String {
  let (response, body) = @http.get(
    "\{config.base_url}/files/\{file_id}/content",
    headers={ "Authorization": "Bearer \{config.api_key}" },
  )
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.text()
}

///|
/// Get file info by file ID
pub async fn get_file_info(
  config : ClientConfig,
  file_id : String,
) -> BatchFile {
  let (response, body) = @http.get("\{config.base_url}/files/\{file_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Check if batch status is terminal
fn is_terminal_status(status : String) -> Bool {
  status == "completed" ||
  status == "failed" ||
  status == "expired" ||
  status == "cancelled"
}

///|
/// Wait for a batch task to complete (polling)
/// Returns the completed batch task
pub async fn wait_for_batch(
  config : ClientConfig,
  batch_id : String,
  poll_interval_ms : Int,
  max_attempts : Int,
) -> Batch {
  let mut attempt = 0
  let mut batch = get_batch(config, batch_id)
  while attempt < max_attempts && !is_terminal_status(batch.status) {
    @async.sleep(poll_interval_ms)
    batch = get_batch(config, batch_id)
    attempt = attempt + 1
  }
  batch
}

///|
/// Parse JSONL content into array of batch output items
pub fn parse_batch_output(jsonl_text : String) -> Array[BatchOutputItem] {
  let results : Array[BatchOutputItem] = []
  let lines = jsonl_text.split("\n")
  for line in lines {
    let trimmed = line.trim()
    if trimmed.length() > 0 {
      try {
        let json = @json.parse(trimmed)
        let item : BatchOutputItem = @json.from_json(json)
        results.push(item)
      } catch {
        _ => ignore(())
      }
    }
  }
  results
}

///|
/// Build batch input item for chat completion
pub fn build_chat_batch_input(
  custom_id : String,
  model : String,
  messages : Array[Message],
) -> BatchInputItem {
  let request = Request::{
    model,
    messages,
    stream: None,
    stream_options: None,
    tools: None,
    extra_body: None,
    enable_search: None,
    enable_thinking: None,
    top_p: None,
    temperature: None,
    presence_penalty: None,
    n: None,
    max_tokens: None,
    seed: None,
    stop: None,
  }
  BatchInputItem::{
    custom_id,
    method_: "POST",
    url: "/v1/chat/completions",
    body: request.to_json(),
  }
}

///|
/// Build JSONL string from batch input items
pub fn build_batch_input_jsonl(items : Array[BatchInputItem]) -> String {
  let lines : Array[String] = []
  for item in items {
    lines.push(item.to_json().stringify())
  }
  lines.join("\n")
}

///|
/// List all available models
pub async fn list_models(config : ClientConfig) -> ModelListResponse {
  let (response, body) = @http.get("\{config.base_url}/models", headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Get a specific model by ID
pub async fn get_model(config : ClientConfig, model_id : String) -> Model {
  let (response, body) = @http.get("\{config.base_url}/models/\{model_id}", headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    fail("HTTP request failed: \{response.code} \{response.reason}")
  }
  body.json() |> @json.from_json()
}

///|
/// Get model names from model list response
pub fn get_model_names(models : ModelListResponse) -> Array[String] {
  let names : Array[String] = []
  for model in models.data {
    names.push(model.id)
  }
  names
}

///|
/// Describe an image - send an image URL and get a description
/// Uses qwen-vl-plus model by default
pub async fn describe_image(
  config : ClientConfig,
  image_url : String,
  prompt : String,
) -> String {
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: [
        Content::{
          type_: "image_url",
          text: None,
          image_url: Some(ImageUrl::{ url: image_url }),
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "text",
          text: Some(prompt),
          image_url: None,
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
      ].to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  let response = chat(config, "qwen-vl-plus", messages)
  match response.content {
    Json::String(s) => s
    _ => "(无法解析响应)"
  }
}

///|
/// Describe an image with specific model
pub async fn describe_image_with_model(
  config : ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
) -> String {
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: [
        Content::{
          type_: "image_url",
          text: None,
          image_url: Some(ImageUrl::{ url: image_url }),
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "text",
          text: Some(prompt),
          image_url: None,
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
      ].to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  let response = chat(config, model, messages)
  match response.content {
    Json::String(s) => s
    _ => "(无法解析响应)"
  }
}

///|
/// OCR - extract text from an image
pub async fn ocr_image(config : ClientConfig, image_url : String) -> String {
  describe_image(
    config, image_url, "请识别并提取图片中的所有文字，按原文格式输出。",
  )
}

///|
/// OCR with specific model
pub async fn ocr_image_with_model(
  config : ClientConfig,
  model : String,
  image_url : String,
) -> String {
  describe_image_with_model(
    config, model, image_url, "请识别并提取图片中的所有文字，按原文格式输出。",
  )
}

///|
/// Analyze a video - send a video URL and get analysis
/// Uses qwen-vl-max model by default for better video understanding
pub async fn analyze_video(
  config : ClientConfig,
  video_url : String,
  prompt : String,
) -> String {
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: [
        Content::{
          type_: "video_url",
          text: None,
          image_url: None,
          video_url: Some(VideoUrl::{ url: video_url }),
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "text",
          text: Some(prompt),
          image_url: None,
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
      ].to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  let response = chat(config, "qwen-vl-max", messages)
  match response.content {
    Json::String(s) => s
    _ => "(无法解析响应)"
  }
}

///|
/// Analyze a video with specific model
pub async fn analyze_video_with_model(
  config : ClientConfig,
  model : String,
  video_url : String,
  prompt : String,
) -> String {
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: [
        Content::{
          type_: "video_url",
          text: None,
          image_url: None,
          video_url: Some(VideoUrl::{ url: video_url }),
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "text",
          text: Some(prompt),
          image_url: None,
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
      ].to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  let response = chat(config, model, messages)
  match response.content {
    Json::String(s) => s
    _ => "(无法解析响应)"
  }
}

///|
/// Compare two images - describe their similarities and differences
pub async fn compare_images(
  config : ClientConfig,
  image_url1 : String,
  image_url2 : String,
  prompt : String,
) -> String {
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: [
        Content::{
          type_: "image_url",
          text: None,
          image_url: Some(ImageUrl::{ url: image_url1 }),
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "image_url",
          text: None,
          image_url: Some(ImageUrl::{ url: image_url2 }),
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
        Content::{
          type_: "text",
          text: Some(prompt),
          image_url: None,
          video_url: None,
          audio_url: None,
          cache_control: None,
        },
      ].to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  let response = chat(config, "qwen-vl-plus", messages)
  match response.content {
    Json::String(s) => s
    _ => "(无法解析响应)"
  }
}

///|
/// Multi-image understanding with full response
pub async fn multi_image_chat_full(
  config : ClientConfig,
  model : String,
  image_urls : Array[String],
  prompt : String,
) -> Response {
  let contents : Array[Content] = []
  for url in image_urls {
    contents.push(Content::{
      type_: "image_url",
      text: None,
      image_url: Some(ImageUrl::{ url, }),
      video_url: None,
      audio_url: None,
      cache_control: None,
    })
  }
  contents.push(Content::{
    type_: "text",
    text: Some(prompt),
    image_url: None,
    video_url: None,
    audio_url: None,
    cache_control: None,
  })
  let messages : Array[Message] = [
    Message::{
      role: "user",
      content: contents.to_json(),
      partial: None,
      tool_calls: None,
      tool_call_id: None,
      reasoning_content: None,
    },
  ]
  chat_full(config, model, messages)
}

// ============================================================================
// Qwen-MT Translation API
// ============================================================================

///| Qwen-MT default model: best balance of quality, speed and cost
pub let translate_default_model : String = "qwen-mt-flash"

///| Translate text using Qwen-MT model
///| - source_lang: "Chinese", "English", "Japanese", "Korean", "French", "German", etc. or "auto"
///| - target_lang: same language names as source_lang
///| - model: "qwen-mt-flash" (default), "qwen-mt-plus", "qwen-mt-turbo", "qwen-mt-lite"
pub async fn translate(
  config : ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
) -> String {
  let messages : Array[Message] = [user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer\{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with specific model
pub async fn translate_with_model(
  config : ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  model : String,
) -> String {
  let messages : Array[Message] = [user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer\{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with terminology intervention (术语干预)
///| terms: array of TranslationTerm { source, target } for consistent translation
pub async fn translate_with_terms(
  config : ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  terms : Array[TranslationTerm],
) -> String {
  let messages : Array[Message] = [user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: Some(terms),
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer\{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with domain hint for better specialized translation
///| domain: e.g. "legal", "medical", "technical", "social"
pub async fn translate_with_domain(
  config : ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  domain : String,
) -> String {
  let messages : Array[Message] = [user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: Some(domain),
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: None,
    stream_options: None,
    translation_options,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer\{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let resp : Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No translation result")
  } else {
    extract_text_from_content(resp.choices[0].message.content)
  }
}

///| Translate with streaming output (incremental)
///| Only qwen-mt-flash and qwen-mt-lite support streaming
pub async fn translate_stream(
  config : ClientConfig,
  text : String,
  source_lang : String,
  target_lang : String,
  on_delta : (String) -> Unit,
) -> String {
  let messages : Array[Message] = [user_message_with_text(text)]
  let translation_options = TranslationOptions::{
    source_lang,
    target_lang,
    terms: None,
    domain: None,
  }
  let request = TranslateRequest::{
    model: translate_default_model,
    messages,
    stream: Some(true),
    stream_options: Some(StreamOptions::{ include_usage: true }),
    translation_options,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer\{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Translation request failed: \{response.code} \{response.reason}")
  }
  let body_text = body.text()
  on_delta(body_text)
  body_text
}
