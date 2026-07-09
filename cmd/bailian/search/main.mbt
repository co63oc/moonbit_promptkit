///|
/// 联网搜索示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/search
/// 接口文档: https://help.aliyun.com/zh/model-studio/web-search
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
async fn main {
  let mock_body = @lib.read_file("cmd/bailian/search/mocks/demo1.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  println("=== 联网搜索演示===")
  let user_question = "杭州明天天气如何"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")
  println("正在使用联网搜索...")
  let response = @lib.chat_with_search(config, "qwen-plus", messages)
  println("助手: \{@lib.extract_text_from_content(response.content)}")
}
