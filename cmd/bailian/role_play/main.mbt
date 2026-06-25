///|
/// 角色扮演示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/role_play
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
pub let character_model : String = "qwen-plus-character"

///|
pub let system_prompt : String = "你是江让，男性，一个围棋天才，拿过很多围棋的奖项。你现在在读高中，是高中校草，用户是你的班长。\n\n你的性格特点：\n\n热情，聪明，顽皮\n\n你的行事风格：\n\n机智，果断\n\n你的语言特点：\n\n说话幽默、爱开玩笑\n\n你可以将动作、神情语气、心理活动、故事背景放在（）中来表示，为对话提供补充信息。"

///|
pub let opening : String = "班长你在干嘛呢"

///|
async fn main {
  println("=== 通义星尘角色扮演模型 (Qwen Character) 示例 ===\n")

  // Demo 1: 单次对话
  println("--- Demo 1: 单次对话 ---")
  let messages1 : Array[@lib.Message] = [
    @lib.system_message(system_prompt),
    @lib.assistant_message(opening),
    @lib.user_message_with_text("我在看书"),
  ]
  let result1 = @lib.chat(config, character_model, messages1)
  println("角色回复: " + @lib.extract_text_from_content(result1.content))
  println("")

  // Demo 2: 多轮对话（追加历史）
  println("--- Demo 2: 多轮对话 ---")
  let messages2 : Array[@lib.Message] = [
    @lib.system_message(system_prompt),
    @lib.assistant_message(opening),
    @lib.user_message_with_text("我在看书"),
    @lib.assistant_message("看什么书啊？这么认真"),
    @lib.user_message_with_text("《平凡的世界》"),
  ]
  let result2 = @lib.chat(config, character_model, messages2)
  println("角色回复: " + @lib.extract_text_from_content(result2.content))
  println("")

  // Demo 3: 流式输出
  println("--- Demo 3: 流式输出 ---")
  let messages3 : Array[@lib.Message] = [
    @lib.system_message(system_prompt),
    @lib.assistant_message(opening),
    @lib.user_message_with_text("最近心情不好，安慰我一下"),
  ]
  @lib.chat_stream(config, character_model, messages3, fn(delta) {
    println(delta)
  })
  |> ignore
  println("")
  println("")

  println("=== 可用模型 ===")
  println("  qwen-plus-character  - 高质量角色扮演")
  println("  qwen-flash-character - 快速低成本")
}
