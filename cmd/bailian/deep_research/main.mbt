///|
/// 深度研究示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/deep_research
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== Qwen-Deep-Research 深度研究模型示例 ===\n")

  // Demo 1: 两步式深度研究（模型反问确认）
  println("--- Demo 1: 两步式深度研究 ---")
  let initial_question = "研究一下人工智能在教育中的应用"
  println("初始问题: " + initial_question)
  println("\n第一步：模型反问确认")

  // 第一步：发送初始问题，获取模型的反问
  println("开始研究...")
  @lib_dr.research(config, initial_question, fn(progress) { println(progress) })
  |> ignore

  // 第二步：带上完整对话历史继续研究
  println("\n第二步：深入研究")
  let user_answer = "我主要关注个性化学习方面"
  println("用户回答: " + user_answer)

  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(initial_question),
    @lib.assistant_message(
      "请告诉我您希望重点研究人工智能在教育中的哪些具体应用场景？",
    ),
    @lib.user_message_with_text(user_answer),
  ]
  @lib_dr.research_with_messages(config, messages, fn(progress) {
    println(progress)
  })
  |> ignore
  println("\n研究完成!")
  println("")

  println("=== 可用模型 ===")
  println(
    "  qwen-deep-research - 深度研究模型（自动规划、搜索、生成报告）",
  )
  println("")
  println("=== 工作流程 ===")
  println("  1. 理解问题并制定研究计划")
  println("  2. 自动执行多轮网络搜索")
  println("  3. 整合信息并生成结构化报告")
  println("")
  println("=== 使用场景 ===")
  println("  - 行业分析报告")
  println("  - 技术调研")
  println("  - 市场研究")
  println("  - 学术研究辅助")
  println("")
  println("提示：使用前请设置 BAILIAN_API_KEY 环境变量")
}
