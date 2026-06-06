///|
/// Vision-Language (图像与视频理解) 示例
/// 展示如何使用百炼多模态模型进行图像理解、OCR、视频分析等
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_image_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20251031/ownrof/f26d201b1e3f4e62ab4a1fc82dd5c9bb.png"

///|
async fn main {
  println("=== 百炼图像与视频理解示例 ===\n")

  // Demo 1: 图像描述
  println("--- Demo 1: 图像描述 ---")
  let description = @lib.describe_image(
    config, sample_image_url, "请用一句话描述这张图片的内容。",
  )
  println("描述: " + description)
  println("")

  // Demo 2: 图像 OCR
  println("--- Demo 2: 图像 OCR (文字识别) ---")
  let ocr_result = @lib.ocr_image(config, sample_image_url)
  println("识别文字: " + ocr_result)
  println("")

  // Demo 3: 多图理解
  println("--- Demo 3: 多图理解 ---")
  let image_urls : Array[String] = [sample_image_url, sample_image_url]
  let multi_result = @lib.multi_image_chat_full(
    config, "qwen-vl-plus", image_urls, "请对比这两张图片的异同。",
  )
  println(
    "多图理解响应状态: " +
    multi_result.choices.length().to_string() +
    " 个选择",
  )
  if multi_result.choices.length() > 0 {
    let msg = multi_result.choices[0].message
    println("回答: " + @lib.extract_text_from_content(msg.content))
  }
  println("")

  // Demo 4: 使用指定模型进行图像理解
  println("--- Demo 4: 指定模型进行图像理解 ---")
  let custom_result = @lib.describe_image_with_model(
    config, "qwen-vl-max", sample_image_url, "请详细描述这张图片中有什么。",
  )
  println("详细描述: " + custom_result)
  println("")

  // 已支持的内容类型
  println("=== 支持的内容类型 ===")
  println("")
  println("【图像】")
  println("  image_content(url) - 创建图像内容")
  println("  describe_image() - 图像描述")
  println("  describe_image_with_model() - 指定模型进行图像描述")
  println("  ocr_image() - 图像文字识别 (OCR)")
  println("  ocr_image_with_model() - 指定模型进行 OCR")
  println("  compare_images() - 图像对比")
  println("  multi_image_chat_full() - 多图对话（完整响应）")
  println("")
  println("【视频】")
  println("  video_content(url) - 创建视频内容")
  println("  analyze_video() - 视频分析")
  println("  analyze_video_with_model() - 指定模型进行视频分析")
  println("")
  println("【音频】")
  println("  audio_content(url) - 创建音频内容")
  println("")
  println("【常用 VL 模型】")
  println("  qwen-vl-plus - 通用视觉语言模型")
  println("  qwen-vl-max - 高性能视觉语言模型（支持视频）")
  println("  qwen3-vl-plus - Qwen3 视觉语言模型")
  println("")
  println("提示：使用前请设置 BAILIAN_API_KEY 环境变量")
}
