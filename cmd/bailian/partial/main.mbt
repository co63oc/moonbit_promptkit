///|
/// 前缀续写示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/partial
/// 接口文档: https://help.aliyun.com/zh/model-studio/partial-mode
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
  let mock_body = @lib.read_file("cmd/bailian/partial/mocks/demo1.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  println("=== 前缀续写（代码补全）===")
  let partial_code = "def calculate_fibonacci(n):\\n    if n <= 1:\\n        return n\\n    else:\\n"
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "请补全这个斐波那契函数，勿添加其他内容",
    ),
    @lib.assistant_message_partial(partial_code),
  ]
  println("用户: 请补全这个斐波那契函数，勿添加其他内容")
  println("前缀: ")
  println(partial_code)
  println("补全结果: ")
  let response = @lib.chat(config, "qwen3-coder-plus", messages)
  println(@lib.extract_text_from_content(response.content))
}
