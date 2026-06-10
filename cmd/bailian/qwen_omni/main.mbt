///|
/// Qwen-Omni example (多模态大模型示例)
/// Demonstrates text, audio, and video understanding with Qwen3.5-Omni
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_audio_url : String = "https://dashscope.oss-cn-beijing.aliyuncs.com/audios/welcome.mp3"

///|
async fn main {
  println("=== Qwen-Omni 多模态大模型示例 ===\n")

  // Demo 1: 文本对话
  println("--- Demo 1: 文本对话 ---")
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text("你好，请介绍一下你自己"),
  ]
  try {
    let result = @lib_qwen_omni.chat(config, messages)
    println("模型回复: \{result}")
  } catch {
    e => println("对话失败: \{e}")
  }
  println("")

  // Demo 2: 音频理解
  println("--- Demo 2: 音频理解 ---")
  try {
    let result = @lib_qwen_omni.analyze_audio(
      config,
      sample_audio_url,
      "请描述这段音频的内容",
    )
    println("音频分析结果: \{result}")
  } catch {
    e => println("音频分析失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("Qwen-Omni 支持:")
  println("  - 文本对话（可输出文本+音频）")
  println("  - 音频理解（语音识别、音乐分析等）")
  println("  - 视频理解（视频描述、字幕生成等）")
  println("  - 多模态组合输入")
  println("可用模型:")
  println("  - \{@lib_qwen_omni.default_model} (全功能)")
  println("  - \{@lib_qwen_omni.flash_model} (成本优化)")
  println("")
  println("注意: Qwen-Omni 必须使用流式输出 (stream=true)")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
