///|
/// 文搜图示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/web_search_image
/// 接口文档: https://help.aliyun.com/zh/model-studio/web-search-image
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
  println("=== 文搜图示例 (Web Search Image) ===\n")

  let query = "帮我找一张适合做 PPT 封面的科技感背景图"
  println("搜索查询: \{query}\n")

  let response = @lib.web_search_image(config, "qwen3.7-plus", query)

  // 输出搜索结果
  println("=== 搜索结果 ===")
  let images = @lib.extract_web_search_images(response)
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
