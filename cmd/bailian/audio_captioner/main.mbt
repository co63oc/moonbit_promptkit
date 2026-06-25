///|
/// 音频理解示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/audio_captioner
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
/// Sample audio URL
pub let sample_audio_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20240916/xvappi/装修噪音.wav"

///|
async fn main {
  println("=== Qwen3-Omni-Captioner 音频理解示例 ===\n")

  // Demo 1: 基础音频描述
  println("--- Demo 1: 基础音频描述 ---")
  let result1 = @audio.caption_audio(config, sample_audio_url)
  println("音频描述:")
  println(result1)
  println("")

  // Demo 2: 使用指定模型
  println("--- Demo 2: 指定模型 ---")
  let result2 = @audio.caption_audio_with_model(
    config, sample_audio_url, "qwen3-omni-30b-a3b-captioner",
  )
  println("音频描述:")
  println(result2)
  println("")

  println("=== 可用模型 ===")
  println("  qwen3-omni-30b-a3b-captioner - 音频理解专用模型")
  println("")
  println("=== 支持的音频类型 ===")
  println("  - 语音（含情绪识别、语言识别）")
  println("  - 环境声（如装修噪音、街道声）")
  println("  - 音乐（风格、乐器、节奏）")
  println("  - 影视声效")
  println("")
  println("=== 支持的音频格式 ===")
  println("  - WAV, MP3, FLAC, AAC, OGG 等")
  println("  - 音频时长不超过 60 秒")
  println("")
  println("提示：使用前请设置 BAILIAN_API_KEY 环境变量")
}
