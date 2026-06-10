///|
/// Hot Words example (自定义热词示例)
/// Demonstrates creating and managing hot word vocabularies for ASR
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 自定义热词示例 (Hot Words) ===\n")

  let target_model = "paraformer-v2"

  // Demo 1: 创建热词列表
  println("--- Demo 1: 创建热词列表 ---")
  let vocabulary = [
    @lib_hot_words.hot_word("百炼平台", 4),
    @lib_hot_words.hot_word("通义千问", 4),
    @lib_hot_words.hot_word("MoonBit", 4, lang="en"),
  ]

  let vocabulary_id = try {
    let id = @lib_hot_words.create_vocabulary(
      config,
      "test",
      target_model,
      vocabulary,
    )
    println("热词列表创建成功！")
    println("Vocabulary ID: \{id}")
    id
  } catch {
    e => {
      println("创建失败: \{e}")
      return ignore(())
    }
  }
  println("")

  // Demo 2: 查询热词状态
  println("--- Demo 2: 查询热词状态 ---")
  try {
    let status = @lib_hot_words.query_vocabulary(config, vocabulary_id)
    println("热词列表状态: \{status}")
  } catch {
    e => println("查询失败: \{e}")
  }
  println("")

  // Demo 3: 列出所有热词
  println("--- Demo 3: 列出所有热词 ---")
  try {
    let list = @lib_hot_words.list_vocabularies(config)
    println("热词列表: \{list}")
  } catch {
    e => println("列出失败: \{e}")
  }
  println("")

  // Demo 4: 删除热词列表
  println("--- Demo 4: 删除热词列表 ---")
  try {
    @lib_hot_words.delete_vocabulary(config, vocabulary_id)
    println("热词列表已删除")
  } catch {
    e => println("删除失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("热词用于提升语音识别中专有名词的识别准确率")
  println("支持模型: paraformer-v2, fun-asr-realtime 等")
  println("每账号最多 10 个热词列表，每个列表最多 500 个热词")
  println("权重范围: 1-5，推荐 4")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
