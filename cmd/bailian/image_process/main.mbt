///|
/// Image Processing examples (图像处理示例)
/// Demonstrates segmentation, erase, repaint, and sketch APIs
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_image_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/rap.png"

///|
let sample_mask_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/rap_mask.png"

///|
let sample_sketch_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/sketch.png"

///|
async fn main {
  println("=== 百炼图像处理示例 ===\n")

  // Demo 1: 实例分割
  println("--- Demo 1: 实例分割 (Image Segmentation) ---")
  try {
    let urls = @lib_image_process.segment_image(config, sample_image_url)
    println("分割完成！结果图片：")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("分割失败: \{e}")
  }
  println("")

  // Demo 2: 擦除补全
  println("--- Demo 2: 擦除补全 (Image Erase) ---")
  try {
    let urls = @lib_image_process.erase_image(
      config,
      sample_image_url,
      mask_url=sample_mask_url,
    )
    println("擦除完成！结果图片：")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("擦除失败: \{e}")
  }
  println("")

  // Demo 3: 局部重绘
  println("--- Demo 3: 局部重绘 (Image Repaint) ---")
  try {
    let urls = @lib_image_process.repaint_image(
      config,
      "一只可爱的猫咪",
      sample_image_url,
      sample_mask_url,
    )
    println("重绘完成！结果图片：")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("重绘失败: \{e}")
  }
  println("")

  // Demo 4: 涂鸦作画
  println("--- Demo 4: 涂鸦作画 (Sketch to Image) ---")
  try {
    let urls = @lib_image_process.sketch_to_image(
      config,
      sample_sketch_url,
      "一座古老的城堡，阳光明媚",
      style="<oil>",
    )
    println("涂鸦完成！结果图片：")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("涂鸦失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("图像处理为异步任务，需要轮询等待完成")
  println("可用模型：")
  println("  - image-instance-segmentation (实例分割)")
  println("  - image-erase-completion (擦除补全)")
  println("  - wanx-x-painting (局部重绘)")
  println("  - wanx-sketch-to-image-lite (涂鸦作画)")
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
