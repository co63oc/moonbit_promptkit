///|
/// Image expansion (out-painting) example
/// 接口文档: https://help.aliyun.com/zh/model-studio/image-expansion
/// 演示图像扩展（image-out-painting）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"request_id\":\"0465c8ec-7024-96ff-8a39-1cbe1aa25c2c\",\"output\":{\"task_id\":\"2b0ef10f-ebf5-425a-9c4d-81e81d217312\",\"task_status\":\"SUCCEEDED\",\"results\":[{\"url\":\"https://example.com/mock-expanded.png\"}]}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
  println("=== 图像扩展 Demo ===")
  println("")

  let image_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"

  // Demo 1: 基础图像扩展
  println("1. 基础图像扩展 (2x)")
  println("原图: \{image_url}")
  println("扩展中...")

  try {
    let urls = @lib_ix.expand_image(
      config,
      @lib_ix.default_model,
      image_url,
      x_scale=2.0,
      y_scale=2.0,
      poll_interval_ms=5000,
      max_attempts=20,
    )
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
    let urls = @lib_ix.expand_easy(config, image_url, x_scale=1.5, y_scale=1.5)
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
    let urls = @lib_ix.expand_image(
      config,
      @lib_ix.default_model,
      image_url,
      x_scale=3.0,
      y_scale=3.0,
      poll_interval_ms=5000,
      max_attempts=20,
    )
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("扩展失败: \{e.to_string()}")
  }
}
