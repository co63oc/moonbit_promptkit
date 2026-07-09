///|
/// 网页提取示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/web_extractor
/// 接口文档: https://help.aliyun.com/zh/model-studio/web-extractor
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
async fn main {
  // 读取 mock SSE 数据（数据较大，从文件加载）
  let mock_body = @fs.read_file_to_string(
    "cmd/bailian/web_extractor/mock_sse.txt",
  )

  let config : @lib.ClientConfig = @lib.make_client_config(
    @lib.get_env_var("BAILIAN_API_KEY", Some("")),
    @lib.get_env_var(
      "BAILIAN_BASE_URL",
      Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
    ),
    mock_body=Some(mock_body),
  )

  let model = @lib.get_env_var("BAILIAN_MODEL", Some("qwen-plus"))

  // 示例1: 提取并总结网页内容
  println("=== 网页提取示例 (Web Extractor) ===\n")
  println("【示例1: 提取并总结网页内容】")
  let question1 = "请访问阿里云百炼代码解释器部分的官方文档，并总结主要内容"
  let messages1 : Array[@lib.Message] = [@lib.user_message_with_text(question1)]
  println("用户: \{question1}")
  println("\n助手: ")

  let result1 = @lib.chat_web_extractor_stream_thinking(
    config,
    model,
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
  let messages2 : Array[@lib.Message] = [@lib.user_message_with_text(question2)]
  println("用户: \{question2}")
  println("\n助手: ")

  let answer2 = @lib.chat_web_extractor_stream(config, model, messages2, fn(
    text,
  ) {
    println(text)
  })

  println("\n\n=== 完整回复 ===")
  println(answer2)
}
