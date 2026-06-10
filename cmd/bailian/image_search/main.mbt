///|
/// Image Search example (图搜图示例)
/// Demonstrates searching similar images by image URL using Responses API
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 图搜图示例 (Image Search) ===\n")

  // 示例图片 URL
  let image_url = "https://img.alicdn.com/imgextra/i4/O1CN01YbrnSS1qtmsAkw0Ud_!!6000000005554-2-tps-788-450.png"
  let query = "找与这张图相似风格的风景图"
  
  println("输入图片: \{image_url}")
  println("搜索描述: \{query}\n")

  let response = @lib.image_search(config, "qwen3.7-plus", image_url, Some(query))

  // 输出搜索结果
  println("=== 搜索结果 ===")
  let images = @lib.extract_image_search_results(response)
  println("找到 \{images.length()} 张图片\n")

  // 显示前5张图片
  let limit = if images.length() < 5 { images.length() } else { 5 }
  let mut i = 0
  while i < limit {
    let img = images[i]
    match img {
      Json::Object(obj) =>
        match obj.get("title") {
          Some(Json::String(title)) => println("[\{i + 1}] \{title}")
          _ => println("[\{i + 1}] (无标题)")
        }
      _ => println("[\{i + 1}] (无标题)")
    }
    match img {
      Json::Object(obj) =>
        match obj.get("url") {
          Some(Json::String(url)) => println("    \{url}")
          _ => ignore(())
        }
      _ => ignore(())
    }
    i = i + 1
  }

  // 输出模型回复
  match response.output_text {
    Some(text) => {
      println("\n=== 模型回复 ===")
      println(text)
    }
    None => ignore(())
  }

  // 输出 Token 使用情况
  match response.usage {
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
}
