///|
/// Deep thinking (深度思考) example using Bailian
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen-plus"))

///|
async fn main {
  println("=== 深度思考示例：流式输出（开启思考模式）===")
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text(
      "鸡兔同笼，头有35，足有94，问鸡兔各几何？",
    ),
  ]
  println("用户: 鸡兔同笼，头有35，足有94，问鸡兔各几何？")
  println("")

  let result = @lib.chat_stream_thinking(
    config,
    model,
    messages,
    fn(reasoning) {
      println("=== 思考过程 ===")
      println(reasoning)
    },
    fn(answer) {
      println("")
      println("=== 最终回答 ===")
      println(answer)
    },
  )

  println("")
  println("=== 完整信息 ===")
  println("思考过程长度: \{result.reasoning.length()} 字符")
  println("回答长度: \{result.answer.length()} 字符")
}
