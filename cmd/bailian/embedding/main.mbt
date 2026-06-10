///|
/// Embedding example (文本向量化示例)
/// Demonstrates text embedding generation
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 文本向量化示例 (Embedding) ===\n")

  // 示例1: 单文本向量化
  println("【示例1: 单文本向量化】")
  let text1 = "衣服的质量杠杠的"
  println("输入文本: \{text1}")
  
  let input1 : Json = Json::string(text1)
  let response1 = @lib.create_embedding(config, "text-embedding-v4", input1)
  
  println("\n=== 向量化结果 ===")
  if response1.data.length() > 0 {
    let embedding = response1.data[0].embedding
    println("向量维度: \{embedding.length()}")
    let first5 = embedding.iter().take(5).map(fn(x) { x.to_string() }).to_array()
    println("前5个维度: [\{first5.join(", ")}]")
  }
  
  match response1.usage {
    Some(usage) => {
      println("\n=== Token 使用情况 ===")
      match usage.prompt_tokens {
        Some(tokens) => println("输入 tokens: \{tokens}")
        None => ignore(())
      }
      match usage.total_tokens {
        Some(tokens) => println("总计 tokens: \{tokens}")
        None => ignore(())
      }
    }
    None => ignore(())
  }

  // 示例2: 批量文本向量化
  println("\n\n【示例2: 批量文本向量化】")
  let texts = ["你好世界", "机器学习很有趣", "深度学习是机器学习的子集"]
  println("输入文本: \{texts.join(", ")}")
  
  let input2 : Json = Json::array(
    texts.map(fn(text) { Json::string(text) })
  )
  let response2 = @lib.create_embedding(config, "text-embedding-v4", input2)
  
  println("\n=== 批量向量化结果 ===")
  println("生成向量数量: \{response2.data.length()}")
  let mut idx = 0
  for data in response2.data {
    println("文本 \{idx + 1} 维度: \{data.embedding.length()}")
    idx = idx + 1
  }

  // 示例3: 指定维度向量化
  println("\n\n【示例3: 指定维度向量化】")
  let text3 = "这是一段测试文本"
  println("输入文本: \{text3}")
  println("指定维度: 512")
  
  let input3 : Json = Json::string(text3)
  let response3 = @lib.create_embedding_with_options(
    config, "text-embedding-v4", input3, None, Some(512)
  )
  
  println("\n=== 指定维度向量化结果 ===")
  if response3.data.length() > 0 {
    let embedding = response3.data[0].embedding
    println("向量维度: \{embedding.length()}")
  }
}
