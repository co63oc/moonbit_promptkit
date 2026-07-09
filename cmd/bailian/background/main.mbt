///|
/// 背景生成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/background
/// 接口文档: https://help.aliyun.com/zh/model-studio/image-background-generation
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"request_id\":\"8a31d092-2eb4-9b06-acbf-50c83a4dea46\",\"output\":{\"task_id\":\"dc77909b-0f34-4c13-b5a8-2e639f8f71bf\",\"task_status\":\"SUCCEEDED\",\"results\":[{\"url\":\"https://example.com/mock-bg.png\"}]}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
  println("=== 背景生成 Demo ===")
  println("")

  let base_url = "https://help-static-aliyun-doc.aliyuncs.com/assets/img/zh-CN/9461437371/p904092.png"

  // Demo 1: 带提示词的背景生成
  println("1. 带提示词的背景生成")
  let prompt = "海边日落，金色阳光洒在海面上"
  println("前景图: \{base_url}")
  println("提示词: \{prompt}")
  try {
    let urls = @lib_bg.background_easy(config, base_url, ref_prompt=prompt)
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 使用参考图生成背景
  println("2. 使用参考图生成背景")
  let ref_url = "https://dashscope.oss-cn-beijing.aliyuncs.com/images/dog_and_girl.jpeg"
  println("前景图: \{base_url}")
  println("参考图: \{ref_url}")
  try {
    let urls = @lib_bg.generate_background(
      config,
      @lib_bg.default_model,
      base_url,
      ref_image_url=ref_url,
      size="1024*1024",
      poll_interval_ms=5000,
      max_attempts=20,
    )
    for url in urls {
      println("  URL: \{url}")
    }
  } catch {
    e => println("生成失败: \{e.to_string()}")
  }
}
