///|
/// 数学推理示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/qwen_math
/// 接口文档: https://help.aliyun.com/zh/model-studio/math-language-model
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
async fn main {
  let mock_body = @lib.read_file("cmd/bailian/qwen_math/mocks/demo1.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  println("=== Qwen-Math 数学模型示例 ===\n")

  // Demo 1: 一元二次方程求根公式推导
  println("--- Demo 1: 求根公式推导 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "Derive a universal solution for the quadratic equation $Ax^2+Bx+C=0$",
    ),
  ]
  let result1 = @lib.chat(config, "qwen-math-plus", messages1)
  println(@lib.extract_text_from_content(result1.content))
  println("")

  // Demo 2: 积分计算
  println("--- Demo 2: 定积分计算 ---")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "Evaluate the definite integral $\\int_0^1 x^2 e^x dx$",
    ),
  ]
  let result2 = @lib.chat(config, "qwen-math-plus", messages2)
  println(@lib.extract_text_from_content(result2.content))
  println("")

  // Demo 3: 使用 turbo 模型（更快）
  println("--- Demo 3: qwen-math-turbo ---")
  let messages3 : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "Find all real roots of $x^3 - 6x^2 + 11x - 6 = 0$",
    ),
  ]
  let result3 = @lib.chat(config, "qwen-math-turbo", messages3)
  println(@lib.extract_text_from_content(result3.content))
  println("")

  println("=== 可用模型 ===")
  println("  qwen-math-plus  - 高质量数学推理")
  println("  qwen-math-turbo - 快速数学推理")
}
