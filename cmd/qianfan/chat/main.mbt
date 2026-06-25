///|
/// 文本生成示例（百度千帆）
///
/// 运行命令: moon run cmd/qianfan/chat
///
/// 环境变量要求:
/// - QIANFAN_API_KEY: 百度千帆 API Key
/// - QIANFAN_MODEL: 使用的模型（默认: ernie-4.0-turbo-8k）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "QIANFAN_API_KEY", "QIANFAN_BASE_URL", "https://qianfan.baidubce.com/v2",
)

///|
pub let model : String = @lib.get_env_var(
  "QIANFAN_MODEL",
  Some("ernie-4.0-turbo-8k"),
)

///|
async fn main {
  println("=== 百度千帆文本生成示例 (OpenAI 兼容模式) ===\n")

  // 示例1: 简单对话
  println("--- 示例1: 简单对话 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请简单介绍一下你自己"),
  ]
  println("用户: 你好，请简单介绍一下你自己")
  let response1 = @lib.chat(config, model, messages1)
  println("助手: \{@lib.extract_text_from_content(response1.content)}\n")

  // 示例2: 带系统提示词
  println("--- 示例2: 带系统提示词 ---")
  let messages2 : Array[@lib.Message] = [
    @lib.system_message(
      "你是一位物理学教授，擅长用通俗易懂的语言解释复杂的物理概念。",
    ),
    @lib.user_message_with_text(
      "请用一句话总结量子计算的核心原理",
    ),
  ]
  println("系统: 你是一位物理学教授...")
  println("用户: 请用一句话总结量子计算的核心原理")
  let response2 = @lib.chat(config, model, messages2)
  println("助手: \{@lib.extract_text_from_content(response2.content)}\n")

  // 示例3: 多轮对话
  println("--- 示例3: 多轮对话 ---")
  let messages3 : Array[@lib.Message] = [
    @lib.user_message_with_text("什么是机器学习？"),
    @lib.assistant_message(
      "机器学习是人工智能的一个分支，它使计算机系统能够从数据中学习并改进性能，而无需进行明确的编程。",
    ),
    @lib.user_message_with_text("它有哪些主要类型？"),
  ]
  println("用户: 什么是机器学习？")
  println("助手: 机器学习是人工智能的一个分支...")
  println("用户: 它有哪些主要类型？")
  let response3 = @lib.chat(config, model, messages3)
  println("助手: \{@lib.extract_text_from_content(response3.content)}\n")

  println("=== 示例完成 ===")
}
