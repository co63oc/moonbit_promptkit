///|
/// Qwen-Doc-Turbo 数据挖掘模型示例
/// 专门针对信息抽取、内容审核、分类打标和摘要生成任务
///
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let doc_model : String = "qwen-doc-turbo"

///|
let sample_doc : String = "智能办公产品手册 版本：V2.0 发布日期：2024年1月\n\n1.1 产品概述\nPRO-100 智能打印机，价格 8999 元\nPRO-200 智能扫描仪，价格 12999 元\nSEC-400 智能访客系统，价格 9999 元\nSEC-500 智能停车管理，价格 22999 元"

///|
async fn main {
  println("=== Qwen-Doc-Turbo 数据挖掘模型示例 ===\n")

  // Demo 1: 信息抽取
  println("--- Demo 1: 信息抽取 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.system_message(sample_doc),
    @lib.user_message_with_text(
      "从这份产品手册中，提取所有产品信息，并整理成一个标准的JSON数组。每个对象需要包含：model(产品的型号)、name(产品的名称)、price(价格（去除货币符号和逗号）)",
    ),
  ]
  let result1 = @lib.chat(config, doc_model, messages1)
  println("提取结果:")
  println(@lib.extract_text_from_content(result1.content))
  println("")

  // Demo 2: 流式输出
  println("--- Demo 2: 流式输出 ---")
  let meeting_notes = "会议纪要 2024年3月15日\n参会人员：张三、李四、王五\n议题：新产品发布计划\n结论：4月15日发布PRO-300智能打印机，定价10999元"
  let messages2 : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.system_message(meeting_notes),
    @lib.user_message_with_text(
      "请提取会议纪要中的关键信息，以JSON格式返回",
    ),
  ]
  @lib.chat_stream(config, doc_model, messages2, fn(delta) { println(delta) })
  |> ignore
  println("\n")

  println("=== 可用模型 ===")
  println("  qwen-doc-turbo - 数据挖掘专用模型")
}
