///|
/// 音频理解示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/audio_captioner
/// 接口文档: https://help.aliyun.com/zh/model-studio/qwen3-omni-captioner
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///
let api_key : String = @lib.get_env_var("BAILIAN_API_KEY", Some(""))

///|
let base_url : String = @lib.get_env_var(
  "BAILIAN_BASE_URL",
  Some("https://dashscope.aliyuncs.com/compatible-mode/v1"),
)

///|
let mock_body = "{\"model\":\"qwen-plus\",\"id\":\"chatcmpl-e53f7f2d-61bd-9f59-9e6e-8a00e25e84b4\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型，能够回答问题、创作文字、编程、逻辑推理、多语言支持等，致力于为你提供高效、友好和专业的帮助。😊\",\"role\":\"assistant\"},\"index\":0,\"finish_reason\":\"stop\"}],\"created\":1783499893,\"object\":\"chat.completion\",\"usage\":{\"total_tokens\":63,\"completion_tokens\":47,\"prompt_tokens\":16,\"prompt_tokens_details\":{\"cached_tokens\":0}}}"

///|
let config : @lib.ClientConfig = @lib.make_client_config(
  api_key,
  base_url,
  mock_body=Some(mock_body),
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
