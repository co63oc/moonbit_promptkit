///|
/// Style repaint example
/// 演示风格重绘（wanx-style-repaint-v1）
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 风格重绘 Demo ===")
  println("")

  // Demo 1: 风格重绘（油画风格）
  println("1. 油画风格重绘 (style_index=7)")
  let image_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"
  println("原图: \{image_url}")
  println("风格: 油画")
  println("重绘中...")

  try {
    let urls = @lib_sr.style_repaint(
      config,
      @lib_sr.default_model,
      image_url,
      7,
      poll_interval_ms=5000,
      max_attempts=20,
    )
    println("重绘成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("重绘失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 便捷函数（卡通风格）
  println("2. 便捷函数 style_repaint_easy (style_index=1)")
  println("风格: 卡通")
  try {
    let urls = @lib_sr.style_repaint_easy(config, image_url, 1)
    println("重绘成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("重绘失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 显示可用风格列表
  println("3. 可用风格列表")
  let styles = @lib_sr.style_names
  println("共 \{styles.length()} 种风格:")
  for i, style in styles.iter() {
    println("  \{i}: \{style}")
  }
}
