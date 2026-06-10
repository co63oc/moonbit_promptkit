///|
/// Background generation example
/// 演示背景生成（wanx-background-generation-v2）
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 背景生成 Demo ===")
  println("")

  // Demo 1: 基础背景生成
  println("1. 基础背景生成")
  let base_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250717/zfifqo/dog_and_girl.jpeg"
  println("前景图: \{base_url}")
  println("生成中...")

  try {
    let urls = @background.generate_background(
      config,
      @background.default_model,
      base_url,
      size="1024*1024",
      poll_interval_ms=5000,
      max_attempts=20,
    )
    println("生成成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 带提示词的背景生成
  println("2. 带提示词的背景生成")
  let prompt = "海边日落，金色阳光洒在海面上"
  println("前景图: \{base_url}")
  println("提示词: \{prompt}")
  try {
    let urls = @background.background_easy(
      config, base_url, ref_prompt=prompt,
    )
    println("生成成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 使用参考图生成背景
  println("3. 使用参考图生成背景")
  let ref_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250717/zfifqo/dog_and_girl.jpeg"
  println("前景图: \{base_url}")
  println("参考图: \{ref_url}")
  try {
    let urls = @background.generate_background(
      config,
      @background.default_model,
      base_url,
      ref_image_url=ref_url,
      size="1024*1024",
      poll_interval_ms=5000,
      max_attempts=20,
    )
    println("生成成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
}
