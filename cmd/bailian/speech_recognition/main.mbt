///|
/// Speech Recognition example (语音识别示例)
/// Demonstrates non-realtime audio transcription (file-based)
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_audio_url : String = "https://dashscope.oss-cn-beijing.aliyuncs.com/audios/welcome.mp3"

///|
async fn main {
  println("=== 百炼语音识别示例 (Speech Recognition) ===\n")

  // Demo 1: 基础语音转写
  println("--- Demo 1: 基础语音转写 ---")
  try {
    let result_url = @lib_speech_recognition.transcribe(
      config,
      [sample_audio_url],
    )
    println("转写完成！")
    println("结果URL: \{result_url}")
  } catch {
    e => println("转写失败: \{e}")
  }
  println("")

  // Demo 2: 带说话人分离的转写
  println("--- Demo 2: 说话人分离转写 ---")
  try {
    let result_url = @lib_speech_recognition.transcribe(
      config,
      [sample_audio_url],
      diarization_enabled=true,
      speaker_count=2,
    )
    println("转写完成！")
    println("结果URL: \{result_url}")
  } catch {
    e => println("转写失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("语音识别为异步任务，通常需要数秒到数分钟")
  println("可用模型: \{@lib_speech_recognition.default_model}")
  println("支持功能:")
  println("  - 多语言识别 (language_hints)")
  println("  - 说话人分离 (diarization_enabled)")
  println("  - 多文件批量转写")
  println("")
  println("注意: 实时语音识别使用 WebSocket 协议，需要额外实现")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
