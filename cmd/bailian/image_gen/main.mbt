///|
/// 图像生成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/image_gen
/// 接口文档: https://help.aliyun.com/zh/model-studio/text-to-image
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
let mock_body = "{\"output\":{\"choices\":[{\"finish_reason\":\"stop\",\"message\":{\"content\":[{\"image\":\"https://dashscope-7c2c.oss-accelerate.aliyuncs.com/1d/62/20260708/d689c36f/b90f8f4c-3a0e-4fe0-8ccf-ad904083a3a9_0.png?Expires=1783586358&OSSAccessKeyId=LTAI5tPxpiCM2hjmWrFXrym1&Signature=4ad0zsVAewR1ugHbXrkNkjZ6xW4%3D\",\"type\":\"image\"}],\"role\":\"assistant\"}}],\"finished\":true},\"usage\":{\"image_count\":1,\"input_tokens\":23,\"output_tokens\":2,\"size\":\"1024*1024\",\"total_tokens\":25},\"request_id\":\"250a907d-9b03-9541-bc7f-8e33f25bc657\"}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
  println("=== 文生图 Demo ===")
  println("")

  // Demo 1: 同步文生图（Wan2.7）
  println("1. 同步文生图 (wan2.7-image-pro)")
  let prompt = "一只可爱的橘猫坐在窗台上，阳光从窗外照进来，温馨氛围，摄影风格"
  println("提示词: \{prompt}")
  println("生成中...")

  try {
    let urls = @lib_ig.generate_sync(
      config,
      @lib_ig.default_model,
      prompt,
      n=1,
      size="1024*1024",
    )
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 便捷函数
  println("2. 便捷函数 text_to_image")
  let prompt2 = "赛博朋克风格的城市夜景，霓虹灯，未来感"
  println("提示词: \{prompt2}")
  try {
    let urls = @lib_ig.text_to_image(config, prompt2, size="1024*1024")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
}
