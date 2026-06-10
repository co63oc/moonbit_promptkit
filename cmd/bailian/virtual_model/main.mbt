///|
/// Virtual model generation example (虚拟模特生成示例)
/// Demonstrates virtual model and shoe model generation APIs
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_clothing_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/clothing.png"

///|
let sample_template_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/shoe_template.png"

///|
let sample_shoe_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/shoe.png"

///|
async fn main {
  println("=== 百炼虚拟模特生成示例 ===\n")

  // Demo 1: 虚拟模特生成
  println("--- Demo 1: 虚拟模特生成 (Virtual Model) ---")
  try {
    let urls = @lib_virtual_model.generate_virtual_model(
      config,
      @lib_virtual_model.default_model,
      sample_clothing_url,
      prompt="一位优雅的女性模特，白色背景",
      n=1,
    )
    println("虚拟模特生成完成！")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("虚拟模特生成失败: \{e}")
  }
  println("")

  // Demo 2: 鞋靴模特生成
  println("--- Demo 2: 鞋靴模特生成 (Shoe Model) ---")
  try {
    let urls = @lib_virtual_model.generate_shoe_model(
      config,
      sample_template_url,
      [sample_shoe_url],
      n=1,
    )
    println("鞋靴模特生成完成！")
    for url in urls {
      println("  - \{url}")
    }
  } catch {
    e => println("鞋靴模特生成失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("虚拟模特生成为异步任务，需要轮询等待完成")
  println("可用模型：")
  println("  - virtualmodel-v2 (虚拟模特 V2)")
  println("  - shoemodel-v1 (鞋靴模特)")
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
