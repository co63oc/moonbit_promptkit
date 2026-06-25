///|
/// 语音合成示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/tts
///
/// 环境变量要求:
/// - DASHSCOPE_API_KEY: 阿里云百炼 API Key
/// - DASHSCOPE_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/api/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "DASHSCOPE_API_KEY", "DASHSCOPE_BASE_URL", "https://dashscope.aliyuncs.com/api/v1",
)

///|
async fn main {
  println("=== 百炼语音合成 (TTS) 示例 ===\n")

  println("=== 语音合成 API ===")
  println("")
  println("【CosyVoice 语音合成】")
  println("  cosyvoice_tts() - 基础语音合成")
  println("  cosyvoice_tts_with_voice() - 指定音色合成")
  println("  cosyvoice_tts_with_options() - 带参数的语音合成")
  println("  cosyvoice_tts_ssml() - SSML 标记语音合成")
  println("")
  println("【Qwen-TTS 语音合成】")
  println("  qwen_tts() - 基础语音合成")
  println("  qwen_tts_with_voice() - 指定音色合成")
  println("  qwen_tts_with_instruction() - 指令控制语音合成")
  println("")
  println("【MiniMax 语音合成】")
  println("  minimax_tts() - 基础语音合成")
  println("  minimax_tts_with_options() - 带参数的语音合成")
  println("")

  println("=== 声音复刻 (Voice Cloning) ===")
  println("")
  println("  cosyvoice_clone_voice() - CosyVoice 声音复刻")
  println("  qwen_clone_voice() - Qwen-TTS 声音复刻")
  println("")

  println("=== 声音设计 (Voice Design) ===")
  println("")
  println("  cosyvoice_design_voice() - CosyVoice 声音设计")
  println("  cosyvoice_design_voice_with_preview() - 带预览的声音设计")
  println("  qwen_design_voice() - Qwen-TTS 声音设计")
  println("  qwen_design_voice_with_preview() - 带预览的声音设计")
  println("")

  println("=== SSML 与 LaTeX ===")
  println("")
  println(
    "  CosyVoice 支持 SSML 标记语言，可控制语速、停顿、发音等",
  )
  println("  支持 LaTeX 公式朗读（需使用支持的音色）")
  println("")

  println("=== 常用模型 ===")
  println("")
  println("【CosyVoice 系列】")
  println("  cosyvoice-v3.5-plus - 高质量，支持声音复刻/设计")
  println("  cosyvoice-v3.5-flash - 快速版，支持声音复刻/设计")
  println("  cosyvoice-v3-plus - 高质量版")
  println("  cosyvoice-v3-flash - 快速版 (默认)")
  println("  cosyvoice-v2 - v2 系列")
  println("")
  println("【Qwen-TTS 系列】")
  println("  qwen3-tts-flash - 快速版 (默认)")
  println("  qwen3-tts-instruct-flash - 指令控制版")
  println("  qwen3-tts-vc - 声音复刻版")
  println("  qwen3-tts-vd - 声音设计版")
  println("")
  println("【MiniMax 系列】")
  println("  MiniMax/speech-2.8-hd - 高清版")
  println("  MiniMax/speech-2.8-turbo - 快速版")
  println("")

  println("=== CosyVoice 常用音色 ===")
  println("")
  println("  longanyang - 龙安洋，阳光大男孩 (标杆音色)")
  println("  longanhuan_v3 - 龙安欢，欢脱元气女")
  println("  longhuhu_v3 - 龙呼呼，天真烂漫女童")
  println("  longxiaochun_v3 - 龙小淳，知性积极女")
  println("  longfei_v3 - 龙飞，热血磁性男")
  println("  longjiaxin_v3 - 龙嘉欣，优雅粤语女")
  println("  longlaotie_v3 - 龙老铁，东北直率男")
  println("")
  println("  更多音色请参考 CosyVoice 音色列表文档")
  println("")

  // Demo 1: CosyVoice 语音合成
  println("--- Demo 1: CosyVoice 语音合成 ---")
  try {
    let audio_url = @audio.cosyvoice_tts(
      config, "今天天气怎么样？适合出去走走吗？",
    )
    println("合成成功! 音频 URL: " + audio_url)
    println("提示: 音频 URL 有效期 24 小时")
  } catch {
    e => println("合成失败: \{e.to_string()}")
  }
  println("")

  // Demo 2: Qwen-TTS 语音合成
  println("--- Demo 2: Qwen-TTS 语音合成 ---")
  try {
    let audio_url = @audio.qwen_tts(
      config, "欢迎使用阿里云百炼大模型服务平台。",
    )
    println("合成成功! 音频 URL: " + audio_url)
  } catch {
    e => println("合成失败: \{e.to_string()}")
  }
  println("")

  // Demo 3: 声音设计提示
  println("--- Demo 3: 声音设计 ---")
  println("提示: 使用声音设计功能需要提供声音描述文本")
  println(
    "示例描述: \"年轻活泼的女性声音，语速较快，带有明显的上扬语调\"",
  )
  println("")

  // Demo 4: SSML 示例
  println("--- Demo 4: SSML 语音合成 ---")
  try {
    let ssml_text = "<speak rate=\"2\">我的语速比正常人快。</speak>"
    let audio_url = @audio.cosyvoice_tts_ssml(config, ssml_text, "longanyang")
    println("SSML 合成成功! 音频 URL: " + audio_url)
  } catch {
    e => println("SSML 合成失败: \{e.to_string()}")
  }
  println("")

  println("=== 提示 ===")
  println("")
  println(
    "1. 实时语音合成使用 WebSocket 协议，低延迟，适用于对话场景",
  )
  println(
    "2. 非实时语音合成使用 HTTP API，返回音频 URL，有效期 24 小时",
  )
  println("3. 声音复刻需要提供 10-20 秒的音频样本")
  println("4. 声音设计通过文本描述创建音色，无需音频样本")
  println("5. SSML 可精细控制语速、语调、停顿等语音特征")
  println(
    "6. LaTeX 公式朗读功能适用于在线教育、有声读物等场景",
  )
  println("")
}
