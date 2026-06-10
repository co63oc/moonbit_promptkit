///|
/// Embedding 向量与 Rerank 重排序示例
/// 展示文本向量化和文档重排序功能
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "DASHSCOPE_API_KEY", "DASHSCOPE_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
fn print_first_n(vec : Array[Double], n : Int) -> String {
  let count = if n < vec.length() { n } else { vec.length() }
  let mut result = "["
  let mut i = 0
  while i < count {
    if i > 0 {
      result = result + ", "
    }
    result = result + vec[i].to_string()
    i = i + 1
  }
  result + "]"
}

///|
async fn main {
  println("=== 百炼 Embedding 向量与 Rerank 重排序示例 ===\n")

  println("=== Embedding 向量生成 API ===")
  println("")
  println("【文本向量化】")
  println("  create_embedding() - 单文本向量生成")
  println("  create_embedding_with_model() - 指定模型的向量生成")
  println("  create_embeddings() - 批量文本向量生成")
  println("  create_embeddings_with_options() - 带维度参数的向量生成")
  println("")

  println("=== Rerank 文档重排序 API ===")
  println("")
  println("【文档重排序】")
  println("  rerank() - 基础文档重排序")
  println("  rerank_with_options() - 带参数的文档重排序")
  println("")

  println("=== 常用模型 ===")
  println("")
  println("【文本向量模型】")
  println("  text-embedding-v4 - 最新高性能文本向量模型 (默认)")
  println("  text-embedding-v3 - v3 版本文本向量模型")
  println("  text-embedding-v2 - v2 版本文本向量模型")
  println("")
  println("【多模态向量模型】")
  println("  qwen3-vl-embedding - 多模态向量，支持融合向量")
  println("  qwen2.5-vl-embedding - 多模态向量，仅融合向量")
  println("  tongyi-embedding-vision-plus - 多模态向量增强版")
  println("  tongyi-embedding-vision-flash - 多模态向量快速版")
  println("")
  println("【重排序模型】")
  println("  gte-rerank - GTE 重排序模型 (默认)")
  println("")

  println("=== 向量维度说明 ===")
  println("")
  println("【text-embedding-v4】")
  println("  支持维度: 2048, 1536, 1024(默认), 768, 512, 256, 128, 64")
  println("  批次大小: 10, 最大 Token: 8192/批次")
  println("")

  // Demo 1: 单文本向量生成
  println("--- Demo 1: 单文本向量生成 ---")
  try {
    let text = "你好，世界"
    let embedding = @embedding.create_embedding(config, text)
    println("输入文本: " + text)
    println("向量维度: \{embedding.length()}")
    println("前5个维度值: " + print_first_n(embedding, 5))
  } catch {
    e => println("向量生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: 批量文本向量生成
  println("--- Demo 2: 批量文本向量生成 ---")
  try {
    let texts = ["机器学习", "深度学习", "自然语言处理"]
    let (embeddings, total_tokens) = @embedding.create_embeddings_with_options(
      config,
      texts,
      model?=None,
      dimensions?=Some(256),
    )
    println("输入文本数量: \{texts.length()}")
    println("总 Token 数: \{total_tokens}")
    println("生成向量数: \{embeddings.length()}")
    println("每个向量维度: \{embeddings[0].length()}")
  } catch {
    e => println("批量向量生成失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 文档重排序
  println("--- Demo 3: 文档重排序 ---")
  try {
    let query = "什么是机器学习？"
    let documents = [
      "机器学习是人工智能的一个分支", "今天天气很好", "深度学习是机器学习的一种方法",
      "机器学习让计算机能够从数据中学习", "我今天吃了一顿美食",
    ]
    let ranked = @embedding.rerank(config, query, documents)
    println("查询: " + query)
    println("")
    println("重排序结果 (索引, 相关度分数):")
    let mut i = 0
    while i < ranked.length() {
      let (index, score) = ranked[i]
      println("  [\{index}] 分数: \{score.to_string()} - " + documents[index])
      i = i + 1
    }
  } catch {
    e => println("重排序失败: \{e.to_string()}")
  }
  println("")

  println("=== 提示 ===")
  println("")
  println("1. Embedding 用于语义搜索、推荐、聚类、分类等场景")
  println("2. Rerank 用于对搜索结果进行语义重排序")
  println("3. 选择合适的维度可以在效果和性能之间取得平衡")
  println("4. text-embedding-v4 支持任务指令 (instruct) 和稀疏向量")
  println("5. 大规模数据建议使用 Batch 接口降低成本")
  println("")
}
