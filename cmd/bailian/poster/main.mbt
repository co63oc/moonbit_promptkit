///|
/// Poster generation example (海报生成示例)
/// Demonstrates creative poster generation API
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 百炼创意海报生成示例 ===\n")

  // Demo 1: 简单海报生成
  println("--- Demo 1: 简单海报生成 ---")
  try {
    let urls = @lib_poster.generate_poster(
      config,
      @lib_poster.default_model,
      "人工智能未来",
      sub_title="AI赋能千行百业",
      prompt_text_zh="科技感、未来感、蓝色调",
      wh_ratios="竖版",
      generate_num=1,
    )
    println("海报生成完成！")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("海报生成失败: \{e}")
  }
  println("")

  // Demo 2: 使用便捷函数
  println("--- Demo 2: 便捷函数生成海报 ---")
  try {
    let urls = @lib_poster.poster_easy(
      config,
      "夏日清凉特惠",
      "清凉一夏，限时优惠",
      lora_name="2D插画1",
    )
    println("海报生成完成！")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("海报生成失败: \{e}")
  }
  println("")

  println("=== 可用海报风格 ===")
  for style in @lib_poster.poster_styles {
    println("  - \{style}")
  }
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
