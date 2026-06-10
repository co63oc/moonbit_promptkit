///|
/// Image expansion (out-painting) example
/// 演示图像扩展（image-out-painting）
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 图像扩展 Demo ===")
  println("")

  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250717/zfifqo/dog_and_girl.jpeg"

  // Demo 1: 基础图像扩展
  println("1. 基础图像扩展 (2x)")
  println("原图: \{image_url}")
  println("扩展中...")

  try {
    let urls = @image_expansion.expand_image(
      config,
      @image_expansion.default_model,
      image_url,
      x_scale=2.0,
      y_scale=2.0,
      poll_interval_ms=5000,
      max_attempts=20,
    )
    println("扩展成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("扩展失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 便捷函数
  println("2. 便捷函数 expand_easy (1.5x)")
  try {
    let urls = @image_expansion.expand_easy(
      config,
      image_url,
      x_scale=1.5,
      y_scale=1.5,
    )
    println("扩展成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("扩展失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 3倍扩展
  println("3. 3倍扩展")
  try {
    let urls = @image_expansion.expand_image(
      config,
      @image_expansion.default_model,
      image_url,
      x_scale=3.0,
      y_scale=3.0,
      poll_interval_ms=5000,
      max_attempts=20,
    )
    println("扩展成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("扩展失败: \{e.to_string()}")
  }
}
