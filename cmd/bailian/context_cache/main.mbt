///|
/// 上下文缓存示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/context_cache
/// 接口文档: https://help.aliyun.com/zh/model-studio/context-cache
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
/// - BAILIAN_MODEL: 使用的模型（默认: qwen3.7-plus）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
/// The model value.
pub let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen3.7-plus"))

///|
/// 模拟的代码仓库内容，最小可缓存提示词长度为 1024 Token
fn build_long_code_content() -> String {
  let mut content = ""
  for _ in 0..<400 {
    content = content + "<Your Code Here>"
  }
  content
}

///|
async fn main {
  let mock_body1 = @lib.read_file("cmd/bailian/context_cache/mocks/demo1.json")
  let mock_body2 = @lib.read_file("cmd/bailian/context_cache/mocks/demo2.json")
  let config1 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body1),
  )
  let config2 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body2),
  )

  println("=== 百炼上下文缓存（显式缓存）示例 ===\n")

  let code_content = build_long_code_content()

  // 第一次请求：创建缓存
  println("--- 第一次请求：创建缓存 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.system_message_with_cache(code_content),
    @lib.user_message_with_text("这段代码的内容是什么"),
  ]
  let response1 = @lib.chat_full_with_params(
    config1,
    model,
    messages1,
    None,
    None,
    Some(200),
    None,
  )
  let msg1 = response1.choices[0].message
  println("回答: \{@lib.extract_text_from_content(msg1.content)}")
  println(
    "第一次请求创建缓存 Token：\{@lib.get_cache_creation_tokens(response1)}",
  )
  println(
    "第一次请求命中缓存 Token：\{@lib.get_cache_read_tokens(response1)}",
  )
  println("====================")

  // 第二次请求：命中缓存
  println("\n--- 第二次请求：命中缓存 ---")
  let messages2 : Array[@lib.Message] = [
    @lib.system_message_with_cache(code_content),
    @lib.user_message_with_text("这段代码可以怎么优化"),
  ]
  let response2 = @lib.chat_full_with_params(
    config2,
    model,
    messages2,
    None,
    None,
    Some(200),
    None,
  )
  let msg2 = response2.choices[0].message
  println("回答: \{@lib.extract_text_from_content(msg2.content)}")
  println(
    "第二次请求创建缓存 Token：\{@lib.get_cache_creation_tokens(response2)}",
  )
  println(
    "第二次请求命中缓存 Token：\{@lib.get_cache_read_tokens(response2)}",
  )

  println("\n--- 使用说明 ---")
  println(
    "1. 显式缓存：通过 cache_control 标记指定需要缓存的内容块",
  )
  println(
    "2. 在 system 或 user 消息的 content 中添加 cache_control: {type: \"ephemeral\"}",
  )
  println(
    "3. 缓存最少需要 1024 Token，有效期 5 分钟（命中后重置）",
  )
  println(
    "4. 缓存创建按输入 Token 的 125% 计费，命中后按 10% 计费",
  )
  println("5. 单次请求最多支持 4 个缓存标记")
}
