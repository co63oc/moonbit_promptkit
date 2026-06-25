///|
/// 图像生成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/image_gen
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
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
    println("生成成功！共 \{urls.length()} 张图片")
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
    println("生成成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
}
