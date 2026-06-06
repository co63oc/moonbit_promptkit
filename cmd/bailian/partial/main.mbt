///|
/// Partial completion example
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
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
