///|
/// 机器翻译示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/translate
/// 接口文档: https://help.aliyun.com/zh/model-studio/machine-translation
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
async fn main {
  // Load mock data for demos
  let mock_demo1 = @lib.read_file("cmd/bailian/translate/mocks/demo1.json")
  let mock_demo2 = @lib.read_file("cmd/bailian/translate/mocks/demo2.json")
  let mock_demo3 = @lib.read_file("cmd/bailian/translate/mocks/demo3.json")
  let mock_demo4a = @lib.read_file("cmd/bailian/translate/mocks/demo4a.json")
  let mock_demo4b = @lib.read_file("cmd/bailian/translate/mocks/demo4b.json")
  let mock_demo5 = @lib.read_file("cmd/bailian/translate/mocks/demo5.json")
  let mock_demo6 = @lib.read_file("cmd/bailian/translate/mocks/demo6.json")

  println("=== 通义千问翻译模型 (Qwen-MT) 示例 ===\n")

  // Demo 1: 基础翻译 (中译英)
  println("--- Demo 1: 基础翻译 (中译英) ---")
  let config1 = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo1),
  )
  let text1 = "我看到这个视频后没有笑"
  let result1 = @mt.translate(config1, text1, "Chinese", "English")
  println("原文: " + text1)
  println("译文: " + result1)
  println("")

  // Demo 2: 自动检测源语种
  println("--- Demo 2: 自动检测源语种 (auto) ---")
  let config2 = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo2),
  )
  let text2 = "Hello, how are you today?"
  let result2 = @mt.translate(config2, text2, "auto", "Chinese")
  println("原文: " + text2)
  println("译文: " + result2)
  println("")

  // Demo 3: 使用指定模型 (qwen-mt-plus 翻译质量最高)
  println("--- Demo 3: 使用 qwen-mt-plus 高质量翻译 ---")
  let config3 = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo3),
  )
  let text3 = "量子计算是一种利用量子力学现象进行信息处理的计算方式。"
  let result3 = @mt.translate_with_model(
    config3, text3, "Chinese", "English", "qwen-mt-plus",
  )
  println("原文: " + text3)
  println("译文: " + result3)
  println("")

  // Demo 4: 术语干预 (terms)
  println("--- Demo 4: 术语干预 (Terminology) ---")
  let text4 = "而这套生物传感器运用了石墨烯这种新型材料，它的目标物是化学元素，敏锐的嗅觉让它能更深度、准确地体现身体健康状况。"
  println("原文: " + text4)

  println("\n[不使用术语表]")
  let config4a = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo4a),
  )
  let result4a = @mt.translate(config4a, text4, "Chinese", "English")
  println("译文: " + result4a)

  println("\n[使用术语表]")
  let terms : Array[@mt.TranslationTerm] = [
    @mt.translation_term("生物传感器", "biological sensor"),
    @mt.translation_term("身体健康状况", "health status of the body"),
  ]
  let config4b = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo4b),
  )
  let result4b = @mt.translate_with_terms(
    config4b, text4, "Chinese", "English", terms,
  )
  println("译文: " + result4b)
  println("")

  // Demo 5: 领域提示 (domain hint)
  println("--- Demo 5: 领域提示 (Domain Hint) ---")
  let config5 = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo5),
  )
  let text5 = "The defendant was found guilty of breach of contract and ordered to pay damages."
  let result5 = @mt.translate_with_domain(
    config5, text5, "English", "Chinese", "legal",
  )
  println("原文: " + text5)
  println("译文: " + result5)
  println("")

  // Demo 6: 流式输出 (Streaming)
  println("--- Demo 6: 流式输出 (Streaming) ---")
  let config6 = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_demo6),
  )
  let text6 = "人工智能正在改变我们的生活方式,从医疗诊断到自动驾驶,AI技术的应用越来越广泛。"
  println("原文: " + text6)
  println("译文 (流式): ")
  let _ = @mt.translate_stream(config6, text6, "Chinese", "English", fn(chunk) {
    println(chunk)
  })

  // API 总览
  println("=== Qwen-MT API 总览 ===")
  println("")
  println("【基础翻译】")
  println("  translate() - 基础翻译 (默认 qwen-mt-flash)")
  println("  translate_with_model() - 指定模型翻译")
  println("  translate_with_terms() - 带术语干预的翻译")
  println("  translate_with_domain() - 带领域提示的翻译")
  println("  translate_stream() - 流式输出翻译")
  println("")
  println("【可用模型】")
  println(
    "  qwen-mt-flash  - 通用首选,质量/速度/成本平衡 (支持流式)",
  )
  println("  qwen-mt-plus   - 最高质量,适合专业文献/正式文书")
  println("  qwen-mt-turbo  - 快速 (已停更,建议用 flash)")
  println("  qwen-mt-lite   - 最低延迟,适合实时聊天 (支持流式)")
  println("")
  println("【支持的语种】")
  println("  92 种语言互译,包括: Chinese, English, Japanese, Korean,")
  println("  French, German, Spanish, Russian, Arabic, Thai, Vietnamese 等")
  println("  source_lang 设为 \"auto\" 可自动检测源语种")
  println("")
  println("提示:使用前请设置 BAILIAN_API_KEY 环境变量")
}
