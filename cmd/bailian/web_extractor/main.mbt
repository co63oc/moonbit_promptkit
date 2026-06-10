///|
/// Web Extractor example (网页提取示例)
/// Demonstrates web page content extraction using search_strategy=agent_max
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 网页提取示例 (Web Extractor) ===\n")

  // 示例1: 提取并总结网页内容
  println("【示例1: 提取并总结网页内容】")
  let question1 = "请访问阿里云百炼代码解释器部分的官方文档，并总结主要内容"
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text(question1),
  ]
  println("用户: \{question1}")
  println("\n助手: ")

  let result1 = @lib.chat_web_extractor_stream_thinking(
    config,
    "qwen3.7-max",
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

  // 示例2: 提取特定网页信息
  println("\n\n【示例2: 提取特定网页信息】")
  let question2 = "请访问 https://help.aliyun.com/zh/model-studio/ 获取百炼平台的最新功能介绍"
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text(question2),
  ]
  println("用户: \{question2}")
  println("\n助手: ")

  let answer2 = @lib.chat_web_extractor_stream(
    config,
    "qwen3.7-max",
    messages2,
    fn(text) {
      println(text)
    },
  )

  println("\n\n=== 完整回复 ===")
  println(answer2)
}
