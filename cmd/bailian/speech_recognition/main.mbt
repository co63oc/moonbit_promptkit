///|
/// 语音识别示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/speech_recognition
/// 接口文档: https://help.aliyun.com/zh/model-studio/non-realtime-speech-recognition-user-guide
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"request_id\":\"135a7732-4a41-9aaf-a76f-b338e1a7bbe4\",\"output\":{\"task_id\":\"0f993915-2590-4143-ac62-2eacb01f6815\",\"task_status\":\"SUCCEEDED\",\"results\":[{\"transcription_url\":\"https://example.com/mock-transcript.json\"}]}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
)

///|
/// The sample_audio_url value.
pub let sample_audio_url : String = "https://dashscope.oss-cn-beijing.aliyuncs.com/audios/welcome.mp3"

///|
async fn main {
  println("=== 百炼语音识别示例 (Speech Recognition) ===\n")

  // Demo 1: 基础语音转写
  println("--- Demo 1: 基础语音转写 ---")
  try {
    let result_url = @lib_speech_recognition.transcribe(config, [
      sample_audio_url,
    ])
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
  println(
    "注意: 实时语音识别使用 WebSocket 协议，需要额外实现",
  )
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
