///|
/// 对话分析示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/dialogue_analysis
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
/// Sample dialogue text
pub let sample_dialogue : String = "[1] 客服:您好,欢迎致电AB电商平台,请问有什么可以帮您?" +
  "\n" +
  "[2] 客户:你好,我上周在你们店买了一台料理机,现在运行时有点异响。" +
  "\n" +
  "[3] 客服:很抱歉给您带来困扰,请问异响是在开机后立刻出现还是运行一段时间后出现的呢?" +
  "\n" +
  "[4] 客户:差不多开机几秒钟后就有了,而且声音很尖锐。" +
  "\n" +
  "[5] 客服:了解了,请问您方便拍一段运行过程的视频发给我们技术人员确认吗?" +
  "\n" +
  "[6] 客户:可以,我一会儿拍好发给你们。" +
  "\n" +
  "[7] 客服:好的,我们收到视频后会在两小时内给您回复处理方案。" +
  "\n" +
  "[8] 客户:那如果确定是质量问题,是可以直接换新的吧?" +
  "\n" +
  "[9] 客服:是的,如果检测为质量问题,我们将为您免费更换新机并承担运费。" +
  "\n" +
  "[10] 客户:好的,那我等你们的反馈,谢谢你们的耐心解答。"

///|
async fn main {
  println("=== 通义晓蜜对话分析模型示例 ===\n")

  // Demo 1: 信息抽取
  println("--- Demo 1: 信息抽取 ---")
  let prompt1 = "请帮我提取下面对话中的关键信息,包括:产品名称、问题描述、客户诉求、解决方案。" +
    sample_dialogue
  let messages1 : Array[@lib.Message] = [@lib.user_message_with_text(prompt1)]
  println("抽取结果:")
  println(
    @topk.chat_topk(config, "tongyi-xiaomi-analysis-flash", messages1, 0.0, 1),
  )
  println("")

  // Demo 2: 场景分类
  println("--- Demo 2: 场景分类 ---")
  let prompt2 = "请判断这段对话属于哪个业务场景,并说明原因。" +
    sample_dialogue
  let messages2 : Array[@lib.Message] = [@lib.user_message_with_text(prompt2)]
  println("场景分类:")
  println(
    @topk.chat_topk(config, "tongyi-xiaomi-analysis-flash", messages2, 0.0, 1),
  )
  println("")

  // Demo 3: 满意度挖掘
  println("--- Demo 3: 满意度挖掘 ---")
  let prompt3 = "请根据以下规则判断客户满意度等级(满意/不满意/一般),并提供判定理由:" +
    sample_dialogue
  let messages3 : Array[@lib.Message] = [@lib.user_message_with_text(prompt3)]
  println("满意度判定:")
  println(
    @topk.chat_topk(config, "tongyi-xiaomi-analysis-flash", messages3, 0.0, 1),
  )
  println("")

  // Demo 4: 复杂质检(使用 pro 模型)
  println("--- Demo 4: 复杂质检(tongyi-xiaomi-analysis-pro)---")
  let prompt4 = "请检查客服是否存在以下问题:1) 态度不佳 2) 响应不及时 3) 解决方案不合理 4) 未确认客户理解。" +
    sample_dialogue
  let messages4 : Array[@lib.Message] = [@lib.user_message_with_text(prompt4)]
  println("质检结果:")
  println(
    @topk.chat_topk(config, "tongyi-xiaomi-analysis-pro", messages4, 0.0, 1),
  )
  println("")

  println("=== 可用模型 ===")
  println("  tongyi-xiaomi-analysis-flash - 快速准确,适合在线分析")
  println(
    "  tongyi-xiaomi-analysis-pro   - 更强的推理和理解能力,适合复杂场景",
  )
  println("")
  println("=== 支持的功能 ===")
  println("  - 对话信息抽取")
  println("  - 场景分类")
  println("  - 满意度挖掘")
  println("  - 复杂质检")
  println("  - 多轮对话理解")
  println("  - 深层语义理解")
}
