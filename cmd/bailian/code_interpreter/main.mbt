///|
/// 代码解释器示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/code_interpreter
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 代码解释器示例 (Code Interpreter) ===\n")

  // 示例1: 数学计算
  println("【示例1: 数学计算】")
  let question1 = "123的21次方是多少？"
  let messages1 : Array[@lib.Message] = [@lib.user_message_with_text(question1)]
  println("用户: \{question1}")
  println("\n助手: ")

  let result1 = @lib.chat_code_interpreter_stream_thinking(
    config,
    "qwen3.7-plus",
    messages1,
    fn(reasoning) {
      println("=== 思考过程 ===")
      println(reasoning)
    },
    fn(answer) {
      println("\n=== 最终回答 ===")
      println(answer)
    },
  )

  println("\n\n--- 统计信息 ---")
  println("思考过程长度: \{result1.reasoning.length()} 字符")
  println("回答长度: \{result1.answer.length()} 字符")

  // 示例2: 数据分析
  println("\n\n【示例2: 数据分析】")
  let question2 = "请生成一个斐波那契数列的前20项，并计算它们的总和"
  let messages2 : Array[@lib.Message] = [@lib.user_message_with_text(question2)]
  println("用户: \{question2}")
  println("\n助手: ")

  let answer2 = @lib.chat_code_interpreter_stream(
    config,
    "qwen3.7-plus",
    messages2,
    fn(text) { println(text) },
  )

  println("\n\n=== 完整回复 ===")
  println(answer2)
}
