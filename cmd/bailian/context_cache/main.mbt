///|
/// Context cache (上下文缓存) example using Bailian
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen3.7-plus"))

///|
fn build_long_system_prompt() -> String {
  let mut prompt = "你是一个专业的编程助手。\n"
  prompt = prompt + "请遵循以下规则：\n"
  for i in 1..<=50 {
    prompt = prompt +
      "规则" +
      i.to_string() +
      ": 认真回答用户的问题。\n"
  }
  prompt
}

///|
async fn main {
  println("=== 百炼上下文缓存（显式缓存）示例 ===\n")

  let system_prompt = build_long_system_prompt()

  println("--- 第一次请求：创建缓存 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.system_message_with_cache(system_prompt),
    @lib.user_message_with_text("请简单介绍一下MoonBit语言"),
  ]
  let response1 = @lib.chat_full_with_params(
    config,
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
    "缓存创建 Token 数: \{@lib.get_cache_creation_tokens(response1)}",
  )
  println("缓存读取 Token 数: \{@lib.get_cache_read_tokens(response1)}")

  println("\n--- 第二次请求：命中缓存 ---")
  let messages2 : Array[@lib.Message] = [
    @lib.system_message_with_cache(system_prompt),
    @lib.user_message_with_text("MoonBit有哪些主要特性？"),
  ]
  let response2 = @lib.chat_full_with_params(
    config,
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
    "缓存创建 Token 数: \{@lib.get_cache_creation_tokens(response2)}",
  )
  println("缓存读取 Token 数: \{@lib.get_cache_read_tokens(response2)}")

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
