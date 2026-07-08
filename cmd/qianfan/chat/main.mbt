///|
/// 文本生成示例（百度千帆）
///
/// 运行命令: moon run cmd/qianfan/chat
/// 接口文档: https://cloud.baidu.com/doc/qianfan-api/s/3m7of64lb
///
/// 环境变量要求:
/// - QIANFAN_API_KEY: 百度千帆 API Key
/// - QIANFAN_MODEL: 使用的模型（默认: ernie-4.5-turbo-32k）
///

///|
let mock_body = "{\"id\": \"as-cd5j7pxiw9\", \"object\": \"chat.completion\", \"created\": 1783502150, \"model\": \"ernie-4.5-turbo-32k\", \"choices\": [{\"index\": 0, \"message\": {\"role\": \"assistant\", \"content\": \"你好！我是文心一言，英文名是ERNIE Bot，是百度研发的知识增强大语言模型。我能够与人对话互动，回答问题，协助创作，高效便捷地帮助人们获取信息、知识和灵感。如果你有任何问题，都可以随时告诉我。\"}, \"finish_reason\": \"stop\", \"flag\": 0}], \"usage\": {\"prompt_tokens\": 6, \"completion_tokens\": 50, \"total_tokens\": 56, \"prompt_tokens_details\": {\"cached_tokens\": 4}}}"

///|
async fn main {
  let api_key = @lib.get_env_var("QIANFAN_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "QIANFAN_BASE_URL",
    Some("https://qianfan.baidubce.com/v2"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let model = @lib.get_env_var("QIANFAN_MODEL", Some("ernie-4.5-turbo-32k"))

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
