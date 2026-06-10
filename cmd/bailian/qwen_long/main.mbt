///|
/// Qwen-Long 超长文档推理示例
/// 支持上传文件（fileid://）或直接传入文档文本
///
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = @qwen_long.default_model

///|
/// 创建示例文档
fn create_sample_doc() -> String {
  let mut doc = "# MoonBit 语言特性文档\n\n"
  doc = doc + "## 1. 语言简介\n"
  doc = doc +
    "MoonBit 是一种现代化的函数式编程语言，专为云原生和 WebAssembly 设计。"
  doc = doc +
    "它结合了函数式编程的优雅和系统编程的性能。\n\n"
  doc = doc + "## 2. 核心特性\n"
  doc = doc +
    "- **模式匹配**：强大的代数数据类型和模式匹配\n"
  doc = doc + "- **类型推导**：智能的类型推导系统\n"
  doc = doc + "- **异步支持**：内置 async/await 异步编程\n"
  doc = doc + "- **零成本抽象**：编译时优化的零成本抽象\n\n"
  doc = doc + "## 3. 应用场景\n"
  doc = doc + "- WebAssembly 开发\n"
  doc = doc + "- 云原生应用\n"
  doc = doc + "- 边缘计算\n"
  doc = doc + "- AI 推理和模型部署\n\n"
  doc = doc + "## 4. 工具链\n"
  doc = doc + "MoonBit 提供完整的开发工具链：\n"
  doc = doc + "- `moon`：包管理器和构建工具\n"
  doc = doc + "- `moonc`：MoonBit 编译器\n"
  doc = doc + "- IDE 插件支持（VS Code）\n"
  doc
}

///|
async fn main {
  println("=== Qwen-Long 超长文档推理示例 ===\n")

  let doc_text = create_sample_doc()

  // Demo 1: 直接传入文档文本进行问答
  println("--- Demo 1: 直接传入文档文本 ---")
  let question1 = "MoonBit 语言的主要应用场景有哪些？"
  println("文档长度: \{doc_text.length()} 字符")
  println("问题: \{question1}")
  let response1 = @qwen_long.chat_with_text(
    config,
    model,
    doc_text,
    question1,
    None,
  )
  println("回答:")
  println(@lib.extract_text_from_content(response1.content))
  println("")

  // Demo 2: 带系统提示的文档推理
  println("--- Demo 2: 带系统提示的文档推理 ---")
  let system_prompt = "你是一个专业的技术文档分析师。请基于提供的文档内容回答问题，确保回答准确且引用文档中的具体信息。"
  let question2 = "MoonBit 的类型系统有什么特点？"
  println("问题: \{question2}")
  let response2 = @qwen_long.chat_with_text(
    config,
    model,
    doc_text,
    question2,
    Some(system_prompt),
  )
  println("回答:")
  println(@lib.extract_text_from_content(response2.content))
  println("")

  // Demo 3: 流式输出
  println("--- Demo 3: 流式输出 ---")
  let question3 = "请详细解释 MoonBit 的异步编程特性"
  println("问题: \{question3}")
  println("回答 (流式):")
  let _ = @qwen_long.chat_with_text_stream(
    config,
    model,
    doc_text,
    question3,
    fn(chunk) { println(chunk) },
    None,
  )
  println("\n")

  // Demo 4: 上传文件后通过 fileid:// 进行问答
  println("--- Demo 4: 上传文件并使用 fileid ---")
  println("上传示例文档...")
  let upload_result = @qwen_long.upload_file(
    config, "moonbit_doc.txt", doc_text,
  )
  println("文件上传成功!")
  println("File ID: \{upload_result.id}")
  match upload_result.filename {
    Some(name) => println("文件名: \{name}")
    None => ignore(())
  }
  println("")

  let question4 = "请总结 MoonBit 的核心特性，用 3-5 个要点"
  println("问题: \{question4}")
  let response4 = @qwen_long.chat_with_files(
    config,
    model,
    [upload_result.id],
    question4,
    None,
  )
  println("回答:")
  println(@lib.extract_text_from_content(response4.content))
  println("")

  // Demo 5: 上传多个文件并使用 fileid 综合问答
  println("--- Demo 5: 多文件综合问答 ---")
  let doc2 = "## MoonBit 性能优化指南\n\n1. 使用尾递归优化函数调用\n2. 避免不必要的内存分配\n3. 利用模式匹配减少分支\n4. 使用编译器内联优化\n5. 合理使用异步任务调度"
  let upload2 = @qwen_long.upload_file(config, "performance_guide.txt", doc2)
  println("上传第二个文件: \{upload2.id}")
  println("")

  let question5 = "请综合两份文档，说明 MoonBit 如何实现高性能"
  println("问题: \{question5}")
  let response5 = @qwen_long.chat_with_files(
    config,
    model,
    [upload_result.id, upload2.id],
    question5,
    Some("综合多个文档的信息，提供全面的分析。"),
  )
  println("回答:")
  println(@lib.extract_text_from_content(response5.content))
  println("")

  // Demo 6: 流式文件问答
  println("--- Demo 6: 流式文件问答 ---")
  let question6 = "MoonBit 适合哪些开发场景？"
  println("问题: \{question6}")
  println("回答 (流式):")
  let _ = @qwen_long.chat_with_files_stream(
    config,
    model,
    [upload_result.id],
    question6,
    fn(chunk) { println(chunk) },
    None,
  )
  println("\n")

  println("=== Qwen-Long 使用场景 ===")
  println("✓ 超长文档理解和问答")
  println("✓ 多文档综合分析")
  println("✓ 技术文档智能检索")
  println("✓ 知识库构建和查询")
  println("✓ 合同、报告等专业文档处理")
  println("✓ 支持最大 1000 万 Token 的上下文")
}
