///|
/// Tripo 3D Generation example (3D模型生成示例)
/// Demonstrates text-to-3D and image-to-3D generation
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_image_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/cat.png"

///|
async fn main {
  println("=== Tripo 3D 模型生成示例 ===\n")

  // Demo 1: 文本生成3D
  println("--- Demo 1: 文本生成3D模型 ---")
  try {
    let model_url = @lib_tripo_3d.text_to_3d(
      config,
      "一只可爱的卡通猫咪，圆润的身体，大眼睛",
    )
    println("3D模型生成完成！")
    println("模型URL (GLB格式): \{model_url}")
  } catch {
    e => println("3D生成失败: \{e}")
  }
  println("")

  // Demo 2: 图像生成3D
  println("--- Demo 2: 图像生成3D模型 ---")
  try {
    let model_url = @lib_tripo_3d.image_to_3d(
      config,
      sample_image_url,
    )
    println("3D模型生成完成！")
    println("模型URL (GLB格式): \{model_url}")
  } catch {
    e => println("3D生成失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("3D生成为异步任务，通常需要 2-5 分钟")
  println("可用模型:")
  println("  - \{@lib_tripo_3d.default_model} (快速预览，2万面)")
  println("  - \{@lib_tripo_3d.high_quality_model} (高精度，200万面)")
  println("输出格式: GLB (可直接在3D软件中打开)")
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
