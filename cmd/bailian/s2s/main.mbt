///|
/// S2S (Speech-to-Speech) example (端到端语音对话示例)
/// Demonstrates Qwen-S2S model for voice-to-voice and text-to-voice
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_audio_url : String = "https://dashscope.oss-cn-beijing.aliyuncs.com/audios/welcome.mp3"

///|
async fn main {
  println("=== 端到端语音对话示例 (S2S) ===\n")

  // Demo 1: 语音到语音
  println("--- Demo 1: 语音到语音 (Voice-to-Voice) ---")
  try {
    let audio_url = @lib_s2s.speech_to_speech(
      config,
      sample_audio_url,
      voice="longanyang",
    )
    println("语音对话完成！")
    println("输出音频URL: \{audio_url}")
  } catch {
    e => println("语音对话失败: \{e}")
  }
  println("")

  // Demo 2: 文本到语音（使用 S2S 模型）
  println("--- Demo 2: 文本到语音 (Text-to-Voice via S2S) ---")
  try {
    let audio_url = @lib_s2s.text_to_speech_s2s(
      config,
      "你好，我是通义千问语音大模型，很高兴为您服务。",
      voice="longanyang",
    )
    println("语音合成完成！")
    println("输出音频URL: \{audio_url}")
  } catch {
    e => println("语音合成失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("S2S 模型支持:")
  println("  - 语音到语音：直接理解语音内容并生成语音回复")
  println("  - 文本到语音：将文本转换为自然语音")
  println("可用模型: \{@lib_s2s.default_model}")
  println("")
  println("注意: 实时语音对话使用 WebSocket 协议，需要额外实现")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
