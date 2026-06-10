///|
/// Qwen-VL 视觉理解、Qwen-VL-OCR 文字识别、视觉推理 (Visual Reasoning)
/// 统一使用 OpenAI 兼容接口 + image_url content 结构
///

///|
/// 默认视觉模型
pub let default_vision_model : String = "qwen-vl-max"

///|
/// 默认 OCR 模型
pub let default_ocr_model : String = "qwen-vl-ocr"

///|
/// 默认视觉推理模型（QVQ）
pub let default_reasoning_model : String = "qvq-max"

///|
/// 默认 Qwen3-VL 混合思考模型
pub let default_qwen3vl_model : String = "qwen3-vl-plus"

// ============================================================
// 基础视觉理解
// ============================================================

///| 视觉理解：单张图像 + 文本提示（非流式）

///|
/// 支持 Qwen-VL-Plus、Qwen-VL-Max 等模型
pub async fn analyze_image(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
) -> String {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  let resp = @lib.chat(config, model, messages)
  @lib.extract_text_from_content(resp.content)
}

///|
/// 视觉理解：单张图像 + 文本提示（流式）
pub async fn analyze_image_stream(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
  on_delta : (String) -> Unit,
) -> String {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_stream(config, model, messages, on_delta)
}

///|
/// 多图理解：多张图像 + 文本提示
pub async fn analyze_images(
  config : @lib.ClientConfig,
  model : String,
  image_urls : Array[String],
  prompt : String,
) -> String {
  let contents : Array[@lib.Content] = []
  for url in image_urls {
    contents.push(@lib.image_content(url))
  }
  contents.push(@lib.text_content(prompt))
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents(contents),
  ]
  let resp = @lib.chat(config, model, messages)
  @lib.extract_text_from_content(resp.content)
}

///|
/// 视频理解：视频 URL + 文本提示
pub async fn analyze_video(
  config : @lib.ClientConfig,
  model : String,
  video_url : String,
  prompt : String,
) -> String {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.video_content(video_url),
      @lib.text_content(prompt),
    ]),
  ]
  let resp = @lib.chat(config, model, messages)
  @lib.extract_text_from_content(resp.content)
}

// ============================================================
// OCR 文字识别
// ============================================================

///|
/// OCR 文字识别：从图像中提取文字（使用 qwen-vl-ocr）
pub async fn ocr(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
) -> String {
  analyze_image(
    config, model, image_url, "Read all text visible in the image and output it in markdown format.",
  )
}

///|
/// OCR 带自定义提示
pub async fn ocr_with_prompt(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
) -> String {
  analyze_image(config, model, image_url, prompt)
}

///|
/// 便捷 OCR（使用默认模型）
pub async fn ocr_easy(config : @lib.ClientConfig, image_url : String) -> String {
  ocr(config, default_ocr_model, image_url)
}

// ============================================================
// 视觉推理 (Visual Reasoning)
// ============================================================

///| 视觉推理：带思考过程的图像分析（流式）

///| 支持 QVQ、Qwen3-VL 等推理模型

///| 使用 @lib.chat_stream_thinking 分离 reasoning_content 和 content

///| on_reasoning_delta 接收思考过程片段，on_answer_delta 接收最终回答片段

///|
/// 返回 ThinkingResult{ reasoning, answer }
pub async fn visual_reasoning_stream(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> @lib.ThinkingResult {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_stream_thinking(
    config, model, messages, on_reasoning_delta, on_answer_delta,
  )
}

///|
/// 视觉推理：多图 + 思考过程（流式）
pub async fn visual_reasoning_images_stream(
  config : @lib.ClientConfig,
  model : String,
  image_urls : Array[String],
  prompt : String,
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> @lib.ThinkingResult {
  let contents : Array[@lib.Content] = []
  for url in image_urls {
    contents.push(@lib.image_content(url))
  }
  contents.push(@lib.text_content(prompt))
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents(contents),
  ]
  @lib.chat_stream_thinking(
    config, model, messages, on_reasoning_delta, on_answer_delta,
  )
}

///|
/// 视觉推理：视频 + 思考过程（流式）
pub async fn visual_reasoning_video_stream(
  config : @lib.ClientConfig,
  model : String,
  video_url : String,
  prompt : String,
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> @lib.ThinkingResult {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.video_content(video_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_stream_thinking(
    config, model, messages, on_reasoning_delta, on_answer_delta,
  )
}

///|
/// 视觉推理：非流式（返回完整 Message，含 reasoning_content 字段）
pub async fn visual_reasoning(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
) -> @lib.Message {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_thinking(config, model, messages)
}

///|
/// 视觉推理：多图非流式
pub async fn visual_reasoning_images(
  config : @lib.ClientConfig,
  model : String,
  image_urls : Array[String],
  prompt : String,
) -> @lib.Message {
  let contents : Array[@lib.Content] = []
  for url in image_urls {
    contents.push(@lib.image_content(url))
  }
  contents.push(@lib.text_content(prompt))
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents(contents),
  ]
  @lib.chat_thinking(config, model, messages)
}

///| 视觉推理：便捷函数（使用默认 QVQ 模型，流式）

///|
/// 打印思考过程和最终回答到 stdout，返回 ThinkingResult
pub async fn visual_reasoning_easy(
  config : @lib.ClientConfig,
  image_url : String,
  prompt : String,
) -> @lib.ThinkingResult {
  visual_reasoning_stream(
    config,
    default_reasoning_model,
    image_url,
    prompt,
    fn(s) { ignore(s) },
    fn(s) { ignore(s) },
  )
}

// ============================================================
// Qwen3-VL 混合思考（enable_thinking 控制）
// ============================================================

///| Qwen3-VL 混合思考：非流式

///| enable_thinking=true 开启思考，false 关闭思考直接回答

///|
/// 返回完整 Message（含 reasoning_content 和 content）
pub async fn qwen3vl_thinking(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
  enable_thinking : Bool,
) -> @lib.Message {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  if enable_thinking {
    @lib.chat_thinking(config, model, messages)
  } else {
    @lib.chat(config, model, messages)
  }
}

///| Qwen3-VL 混合思考：流式

///|
/// enable_thinking=true 时返回 reasoning + answer，false 时仅返回 answer
pub async fn qwen3vl_thinking_stream(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  prompt : String,
  enable_thinking : Bool,
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> @lib.ThinkingResult {
  ignore(enable_thinking)
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_stream_thinking(
    config, model, messages, on_reasoning_delta, on_answer_delta,
  )
}

// ============================================================
// 多轮对话视觉推理
// ============================================================

///| 多轮视觉推理：传入完整消息历史进行多轮对话

///|
/// 适用于需要追问、澄清、深入分析的场景
pub async fn visual_reasoning_multi_turn(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
) -> @lib.Message {
  @lib.chat_thinking(config, model, messages)
}

///|
/// 多轮视觉推理：流式
pub async fn visual_reasoning_multi_turn_stream(
  config : @lib.ClientConfig,
  model : String,
  messages : Array[@lib.Message],
  on_reasoning_delta : (String) -> Unit,
  on_answer_delta : (String) -> Unit,
) -> @lib.ThinkingResult {
  @lib.chat_stream_thinking(
    config, model, messages, on_reasoning_delta, on_answer_delta,
  )
}

// ============================================================
// 图像定位 (Grounding)
// ============================================================

///|
/// 图像定位（Grounding）：返回目标边界框坐标
pub async fn grounding(
  config : @lib.ClientConfig,
  model : String,
  image_url : String,
  target : String,
) -> String {
  let prompt = "检测图片中的" +
    target +
    "，返回边界框坐标 [x1, y1, x2, y2]，坐标值范围 0-1000"
  analyze_image(config, model, image_url, prompt)
}

///|
/// 图像定位便捷函数（使用默认模型）
pub async fn grounding_easy(
  config : @lib.ClientConfig,
  image_url : String,
  target : String,
) -> String {
  grounding(config, default_vision_model, image_url, target)
}

// ============================================================
// 视频推理
// ============================================================

///|
/// 视频推理：非流式
pub async fn visual_reasoning_video(
  config : @lib.ClientConfig,
  model : String,
  video_url : String,
  prompt : String,
) -> @lib.Message {
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.video_content(video_url),
      @lib.text_content(prompt),
    ]),
  ]
  @lib.chat_thinking(config, model, messages)
}
