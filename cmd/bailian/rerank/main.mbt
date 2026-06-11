///|
/// Rerank example (文本排序示例)
/// Demonstrates document reranking against a query
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 百炼文本排序示例 (Rerank) ===\n")

  let query = "什么是机器学习？"
  let documents : Array[String] = [
    "机器学习是人工智能的一个子领域，它使计算机系统能够从数据中学习并改进性能，而无需进行明确的编程。",
    "深度学习是机器学习的一个子集，使用多层神经网络来学习数据的复杂模式。",
    "自然语言处理（NLP）是人工智能领域的一个重要分支，致力于使计算机能够理解、解释和生成人类语言。",
    "Python 是一种广泛使用的高级编程语言，以其简洁易读的语法著称。",
    "强化学习是一种通过与环境交互来学习最优行为策略的机器学习方法。",
    "数据库是用于存储、管理和检索数据的系统化集合。",
  ]

  println("查询: \{query}")
  println("文档数量: \{documents.length()}")
  println("")

  // Demo 1: 基础排序
  println("--- Demo 1: 基础排序 ---")
  try {
    let results = @embedding.rerank(config, query, documents)
    println("排序结果（按相关性降序）：")
    let mut rank = 0
    for index_, score in results {
      rank = rank + 1
      let truncated = if documents[index_].length() > 50 {
        documents[index_][0:50].to_owned() + "..."
      } else {
        documents[index_]
      }
      println("  [\{rank}] 文档\{index_} (score: \{@debug.to_string(score)})")
      println("      \{truncated}")
    }
  } catch {
    e => println("排序失败: \{e}")
  }
  println("")

  // Demo 2: 带选项的排序
  println("--- Demo 2: 带选项的排序 (top_n=3) ---")
  try {
    let (scores, docs) = @embedding.rerank_with_options(
      config,
      query,
      documents,
      top_n=3,
      return_documents=true,
    )
    println("Top 3 结果：")
    let mut rank = 0
    for index_, score in scores {
      rank = rank + 1
      println("  [\{rank}] 文档\{index_} (score: \{@debug.to_string(score)})")
      match docs[rank - 1] {
        Some(doc) => {
          let truncated = if doc.length() > 60 {
            doc[0:60].to_owned() + "..."
          } else {
            doc
          }
          println("      \{truncated}")
        }
        None => ignore(())
      }
    }
  } catch {
    e => println("排序失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("可用模型: \{@embedding.default_rerank_model}")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
