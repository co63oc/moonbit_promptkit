///|
/// File Search example (文件搜索示例)
/// Demonstrates searching uploaded files
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 百炼文件搜索示例 (File Search) ===\n")

  println("文件搜索功能需要先上传文件到百炼平台")
  println("上传文件 API: POST /files")
  println("")
  println("使用示例:")
  println("  let file_ids = [\"file-xxx\", \"file-yyy\"]")
  println("  let response = @file_search.search_files(")
  println("    config,")
  println("    \"qwen3.7-plus\",")
  println("    \"总结文档的主要内容\",")
  println("    file_ids,")
  println("  )")
  println("  let results = @file_search.extract_file_search_results(response)")
  println("")
  println("注意: 文件搜索使用 Responses API，需要 qwen3.7-plus 或更高版本模型")
  println("")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
