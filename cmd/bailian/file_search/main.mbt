///|
/// 文件搜索示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/file_search
/// 接口文档: https://help.aliyun.com/zh/model-studio/file-search
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
/// - BAILIAN_VECTOR_STORE_ID: 知识库 ID（需在百炼控制台创建）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"output\":[{\"type\":\"message\",\"status\":\"completed\",\"output\":\"[{\\\"type\\\":\\\"file_search_call\\\",\\\"queries\\\":[\\\"知识库主要内容\\\"],\\\"results\\\":[{\\\"file_id\\\":\\\"file-mock-001\\\",\\\"text\\\":\\\"这是知识库中的示例内容。\\\"}]}]\"}],\"output_text\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"usage\":{\"total_tokens\":63,\"input_tokens\":16,\"output_tokens\":47}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
  println("=== 百炼文件搜索示例 (File Search) ===\n")

  // 获取知识库 ID（从环境变量或控制台）
  let vector_store_id = @lib.get_env_var(
    "BAILIAN_VECTOR_STORE_ID",
    Some("vs-mock-test-id"),
  )

  println("知识库 ID: \{vector_store_id}")
  println("")

  // 示例1: 单轮搜索
  println("【示例1: 单轮搜索】")
  let query1 = "请总结知识库中的主要内容"
  println("搜索查询: \{query1}")

  let response1 = @lib_file_search.search_files(
    config,
    "qwen3.7-plus",
    query1,
    [vector_store_id],
  )

  // 输出搜索结果
  println("\n=== 搜索结果 ===")
  let results1 = @lib_file_search.extract_file_search_results(response1)
  println("找到 \{results1.length()} 条检索结果")

  // 输出模型回复
  match response1.output_text {
    Some(text) => {
      println("\n=== 模型回复 ===")
      println(text)
    }
    None => ignore(())
  }

  // 输出 Token 使用情况
  match response1.usage {
    Some(usage) => {
      println("\n=== Token 使用情况 ===")
      match usage.input_tokens {
        Some(tokens) => println("输入 tokens: \{tokens}")
        None => ignore(())
      }
      match usage.output_tokens {
        Some(tokens) => println("输出 tokens: \{tokens}")
        None => ignore(())
      }
      match usage.total_tokens {
        Some(tokens) => println("总计 tokens: \{tokens}")
        None => ignore(())
      }
    }
    None => ignore(())
  }

  // 示例2: 多轮追问搜索
  println("\n\n【示例2: 多轮追问搜索】")
  let queries = [
    "知识库中提到了哪些关键技术？", "这些技术的优势是什么？",
  ]
  let mut idx = 0
  while idx < queries.length() {
    let query = queries[idx]
    println("\n--- 追问 \{idx + 1}: \{query} ---")
    let response = @lib_file_search.search_files(
      config,
      "qwen3.7-plus",
      query,
      [vector_store_id],
    )
    match response.output_text {
      Some(text) => println("回复: \{text}")
      None => println("(无回复)")
    }
    idx = idx + 1
  }

  println("\n=== 使用场景 ===")
  println("✓ 企业知识库问答")
  println("✓ 文档智能检索")
  println("✓ RAG (检索增强生成)")
  println("✓ 多文档综合分析")
  println("✓ 合同、报告等专业文档处理")
  println("")
  println(
    "注意: 文件搜索使用 Responses API，需要 qwen3.7-plus 或更高版本模型",
  )
  println(
    "使用前请设置 BAILIAN_API_KEY 和 BAILIAN_VECTOR_STORE_ID 环境变量",
  )
}
