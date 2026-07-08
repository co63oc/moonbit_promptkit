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
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
async fn main {
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
