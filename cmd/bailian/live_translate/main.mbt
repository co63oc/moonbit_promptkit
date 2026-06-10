///|
/// Live Translation example (实时翻译示例)
/// Demonstrates Qwen-LiveTranslate for streaming translation
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 实时翻译示例 (Live Translation) ===\n")

  // Demo 1: 中译英
  println("--- Demo 1: 中文翻译为英文 ---")
  try {
    let result = @lib_live_translate.translate(
      config,
      "人工智能正在改变我们的生活方式，从医疗到教育，从交通到娱乐。",
      "zh",
      "en",
    )
    println("翻译结果: \{result}")
  } catch {
    e => println("翻译失败: \{e}")
  }
  println("")

  // Demo 2: 英译中
  println("--- Demo 2: 英文翻译为中文 ---")
  try {
    let result = @lib_live_translate.translate(
      config,
      "Artificial intelligence is transforming the way we live, from healthcare to education, from transportation to entertainment.",
      "en",
      "zh",
    )
    println("翻译结果: \{result}")
  } catch {
    e => println("翻译失败: \{e}")
  }
  println("")

  // Demo 3: 流式翻译
  println("--- Demo 3: 流式翻译 (Streaming) ---")
  try {
    println("实时输出: ")
    let _ = @lib_live_translate.translate_stream(
      config,
      "Machine learning enables computers to learn from data without being explicitly programmed.",
      "en",
      "zh",
      fn(delta) {
        println(delta)
      },
    )
    println("")
  } catch {
    e => println("流式翻译失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("可用模型:")
  println("  - \{@lib_live_translate.default_model} (实时流式翻译)")
  println("  - \{@lib_live_translate.translate_model} (非实时翻译)")
  println("支持语言: zh (中文), en (英文), ja (日文), ko (韩文) 等")
  println("")
  println("注意: 真正的实时语音翻译需要 WebSocket 协议，此处为文本流式翻译")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
