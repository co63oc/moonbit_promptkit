///|
/// 视觉推理示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/vision
/// 接口文档: https://help.aliyun.com/zh/model-studio/visual-reasoning
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
/// 示例图片：包含数学题的图片
pub let math_image_url : String = "https://img.alicdn.com/imgextra/i1/O1CN01gDEY8M1W114Hi3XcN_!!6000000002727-0-tps-1024-406.jpg"

///|
async fn main {
  // === Demo 1: QVQ 视觉推理（流式，分离思考过程和最终回答）===
  println("=== Demo 1: QVQ 视觉推理（流式）===")
  println("模型: \{@lib_vs.default_reasoning_model}")
  println("图片: \{math_image_url}")
  println("问题: 这道题怎么解答？")
  println("")

  let mock_body1 = @lib.read_file("cmd/bailian/vision/mocks/demo1.json")
  let config1 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body1),
  )

  let result1 = @lib_vs.visual_reasoning_stream(
    config1,
    @lib_vs.default_reasoning_model,
    math_image_url,
    "这道题怎么解答？",
    fn(s) {
      println("=== 思考过程 ===")
      println(s)
    },
    fn(s) {
      println("")
      println("=== 最终回答 ===")
      println(s)
    },
  )
  println("")
  println("思考过程长度: \{result1.reasoning.length()} 字符")
  println("回答长度: \{result1.answer.length()} 字符")
  println("")

  // === Demo 2: Qwen3-VL 混合思考（开启思考）===
  println("=== Demo 2: Qwen3-VL 混合思考（开启思考）===")
  println("模型: \{@lib_vs.default_qwen3vl_model}")
  println("enable_thinking: true")
  println("")

  let mock_body2 = @lib.read_file("cmd/bailian/vision/mocks/demo2.json")
  let config2 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body2),
  )

  let result2 = @lib_vs.qwen3vl_thinking(
    config2, @lib_vs.default_qwen3vl_model, math_image_url, "请分析图片中的内容",
    true,
  )
  match result2.reasoning_content {
    Some(String(s)) => {
      println("=== 思考内容 ===")
      println(s)
    }
    _ => println("(无思考内容)")
  }
  println("")
  println("=== 最终回答 ===")
  println(@lib.extract_text_from_content(result2.content))
  println("")

  // === Demo 3: Qwen3-VL 混合思考（关闭思考）===
  println("=== Demo 3: Qwen3-VL 混合思考（关闭思考）===")
  println("模型: \{@lib_vs.default_qwen3vl_model}")
  println("enable_thinking: false")
  println("")

  let mock_body3 = @lib.read_file("cmd/bailian/vision/mocks/demo3.json")
  let config3 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body3),
  )

  let result3 = @lib_vs.qwen3vl_thinking(
    config3, @lib_vs.default_qwen3vl_model, math_image_url, "请分析图片中的内容",
    false,
  )
  println("=== 直接回答 ===")
  println(@lib.extract_text_from_content(result3.content))
  println("")

  // === Demo 4: 多轮视觉推理 ===
  println("=== Demo 4: 多轮视觉推理 ===")
  println("")

  let messages : Array[@lib.Message] = [
    @lib.user_message_with_contents([
      @lib.image_content(math_image_url),
      @lib.text_content("请分析图片中的内容"),
    ]),
    @lib.assistant_message(
      "图片中包含一个数学问题，涉及长方体和正方体的表面积和体积计算。",
    ),
    @lib.user_message_with_text("请详细解答第一个图形的体积计算"),
  ]

  // Demo 4 复用 Demo 1 的 mock（流式格式）
  let result4 = @lib_vs.visual_reasoning_multi_turn_stream(
    config1,
    @lib_vs.default_reasoning_model,
    messages,
    fn(s) {
      ignore(s)
      println("[思考过程...]")
    },
    fn(s) {
      println("")
      println("=== 多轮回答 ===")
      println(s)
    },
  )
  println("")
  println(
    "思考长度: \{result4.reasoning.length()} | 回答长度: \{result4.answer.length()}",
  )
  println("")

  // === Demo 5: 基础视觉理解（非推理模型）===
  println("=== Demo 5: 基础视觉理解 ===")
  println("模型: \{@lib_vs.default_vision_model}")
  println("")

  let mock_body5 = @lib.read_file("cmd/bailian/vision/mocks/demo5.json")
  let config5 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body5),
  )

  let desc = @lib_vs.analyze_image(
    config5, @lib_vs.default_vision_model, math_image_url, "描述这张图片中的内容",
  )
  println("描述: \{desc}")
  println("")

  // === Demo 6: OCR ===
  println("=== Demo 6: OCR 文字识别 ===")
  println("模型: \{@lib_vs.default_ocr_model}")
  println("")

  let mock_body6 = @lib.read_file("cmd/bailian/vision/mocks/demo6.json")
  let config6 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body6),
  )

  let text = @lib_vs.ocr(config6, @lib_vs.default_ocr_model, math_image_url)
  println("识别结果: \{text}")
  println("")

  // === Demo 7: 图像定位 ===
  println("=== Demo 7: 图像定位 (Grounding) ===")
  // Demo 7 复用 Demo 5 的 mock
  let bbox = @lib_vs.grounding_easy(config5, math_image_url, "数字")
  println("定位结果: \{bbox}")
}
