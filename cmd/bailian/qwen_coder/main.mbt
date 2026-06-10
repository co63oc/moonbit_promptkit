///|
/// Qwen-Coder 代码生成模型示例
/// 支持 qwen3-coder-next / qwen-coder-plus 等模型
///
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = "qwen-coder-plus"

///|
let fibonacci_code : String = "def fibonacci(n, memo={}):\n    if n in memo:\n        return memo[n]\n    if n <= 1:\n        return n\n    memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)\n    return memo[n]"

///|
let process_code : String = "def process(data):\n    result = []\n    for i in range(len(data)):\n        if data[i] > 0:\n            result.append(data[i] * 2)\n        elif data[i] == 0:\n            result.append(0)\n        else:\n            result.append(data[i] * -1)\n    return result"

///|
async fn main {
  println("=== Qwen-Coder 代码生成模型示例 ===\n")

  // Demo 1: 代码生成
  println("--- Demo 1: 代码生成 ---")
  println("生成一个快速排序算法 (Python)")
  let response1 = @qwen_coder.code_generate(
    config,
    "Write a quicksort algorithm with detailed comments",
    model,
    Some("Python"),
  )
  println("回答:")
  println(@lib.extract_text_from_content(response1.content))
  println("")

  // Demo 2: 代码解释
  println("--- Demo 2: 代码解释 ---")
  println("代码:")
  println(fibonacci_code)
  let response2 = @qwen_coder.code_explain(config, fibonacci_code, model)
  println("解释:")
  println(@lib.extract_text_from_content(response2.content))
  println("")

  // Demo 3: 代码重构
  println("--- Demo 3: 代码重构 ---")
  println("原始代码:")
  println(process_code)
  let response3 = @qwen_coder.code_refactor(
    config,
    process_code,
    Some("Use list comprehension and improve readability"),
    model,
  )
  println("重构后:")
  println(@lib.extract_text_from_content(response3.content))
  println("")

  // Demo 4: 流式代码生成
  println("--- Demo 4: 流式代码生成 ---")
  println("生成一个 REST API 服务器 (Node.js)")
  let _ = @qwen_coder.code_generate_stream(
    config,
    "Create a simple Express.js REST API with GET and POST endpoints for a todo list",
    fn(chunk) { println(chunk) },
    model,
    Some("JavaScript"),
  )
  println("\n")

  println("=== Qwen-Coder 使用场景 ===")
  println("✓ 代码生成（支持多种编程语言）")
  println("✓ 代码解释和文档生成")
  println("✓ 代码重构和优化")
  println("✓ Bug 修复和调试")
  println("✓ 代码审查")
  println("✓ 算法实现和数据结构设计")
  println("")
  println("=== 支持的模型 ===")
  println("- qwen-coder-plus: 代码专精模型")
  println("- qwen3-coder-next: 最新代码模型")
  println("- qwen-coder-turbo: 快速代码生成")
}
