///|
/// Image editing example
/// 演示图像编辑（Qwen-Image-Edit）
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 图像编辑 Demo ===")
  println("")

  // Demo 1: 单图编辑
  println("1. 单图编辑")
  let image_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"
  let prompt = "把图中的狗狗变成一只猫咪"
  println("原图: \{image_url}")
  println("指令: \{prompt}")
  println("编辑中...")

  try {
    let urls = @lib_ie.edit_image(
      config,
      @lib_ie.default_model,
      prompt,
      [image_url],
      n=1,
      size="1024*1024",
    )
    println("编辑成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("编辑失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 便捷函数
  println("2. 便捷函数 edit_easy")
  let prompt2 = "给图片添加一个复古滤镜效果"
  println("指令: \{prompt2}")
  try {
    let urls = @lib_ie.edit_easy(config, prompt2, image_url)
    println("编辑成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("编辑失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 多参考图编辑
  println("3. 多参考图编辑")
  let ref_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"
  let edit_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"
  let prompt3 = "将第一张图的风格应用到第二张图上"
  println("参考图: \{ref_url}")
  println("编辑图: \{edit_url}")
  println("指令: \{prompt3}")
  try {
    let urls = @lib_ie.edit_with_refs(
      config, @lib_ie.default_model, prompt3, ref_url, edit_url,
    )
    println("编辑成功！共 \{urls.length()} 张图片")
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("编辑失败: \{e.to_string()}")
  }
}
