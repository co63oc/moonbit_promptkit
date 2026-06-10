///|
/// Qwen-Deep-Research 深度研究模型示例
/// 自动完成复杂研究课题，生成结构化研究报告
///
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== Qwen-Deep-Research 深度研究模型示例 ===\n")

  // Demo 1: 基础研究
  println("--- Demo 1: 基础研究 ---")
  let question1 = "研究一下人工智能在教育中的应用"
  println("研究问题: " + question1)
  println("开始研究...")
  @deep_research.research(config, question1, fn(progress) { println(progress) })
  |> ignore
  println("\n研究完成!")
  println("")

  // Demo 2: 使用指定模型
  println("--- Demo 2: 指定模型 (qwen-deep-research) ---")
  let question2 = "分析2024年中国新能源汽车市场发展趋势"
  println("研究问题: " + question2)
  @deep_research.research_with_model(config, question2, "qwen-deep-research", fn(
    progress,
  ) {
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
