///|
/// GUI-Plus 多模态 UI 交互自动化模型示例
/// 基于屏幕截图和自然语言指令解析用户意图，转换为标准化 GUI 操作
///
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
/// Sample desktop screenshot URL
let sample_screenshot_url : String = "https://img.alicdn.com/imgextra/i2/O1CN016iJ8ob1C3xP1s2M6z_!!6000000000026-2-tps-3008-1758.png"

///|
/// Simplified system prompt for GUI automation
let gui_system_prompt : String = "You are a computer use agent. You can interact with a desktop GUI using mouse and keyboard. The screen resolution is 1000x1000. Output your action as a JSON tool_call with action type and parameters."

///|
async fn main {
  println("=== GUI-Plus UI 交互自动化示例 ===\n")

  // Demo 1: 单步操作
  println("--- Demo 1: 单步操作 (识别桌面图标) ---")
  let contents1 : Array[@lib.Content] = [
    @lib.image_content(sample_screenshot_url),
    @lib.text_content("帮我打开浏览器"),
  ]
  let messages1 : Array[@lib.Message] = [
    @lib.system_message(gui_system_prompt),
    @lib.user_message_with_contents(contents1),
  ]
  let result1 = @lib.chat(config, "gui-plus-2026-02-26", messages1)
  println("模型输出:")
  println(@lib.extract_text_from_content(result1.content))
  println("")

  // Demo 2: 流式输出
  println("--- Demo 2: 流式输出 ---")
  let contents2 : Array[@lib.Content] = [
    @lib.image_content(sample_screenshot_url),
    @lib.text_content("描述一下当前屏幕上有什么"),
  ]
  let messages2 : Array[@lib.Message] = [
    @lib.system_message(gui_system_prompt),
    @lib.user_message_with_contents(contents2),
  ]
  @lib.chat_stream(config, "gui-plus-2026-02-26", messages2, fn(delta) {
    println(delta)
  })
  |> ignore
  println("")
  println("")

  // Demo 3: 完整响应
  println("--- Demo 3: 完整响应 ---")
  let contents3 : Array[@lib.Content] = [
    @lib.image_content(sample_screenshot_url),
    @lib.text_content("点击屏幕中央的位置"),
  ]
  let messages3 : Array[@lib.Message] = [
    @lib.system_message(gui_system_prompt),
    @lib.user_message_with_contents(contents3),
  ]
  let response3 = @lib.chat_full(config, "gui-plus-2026-02-26", messages3)
  println("模型输出:")
  println(@lib.extract_text_from_content(response3.choices[0].message.content))
  println("")

  println("=== 可用模型 ===")
  println("  gui-plus              - 非思考模式，快速响应")
  println(
    "  gui-plus-2026-02-26   - 支持思考与非思考模式（推荐）",
  )
  println("")
  println("=== 支持的操作 ===")
  println("  key, type, mouse_move, left_click, right_click,")
  println("  double_click, scroll, hscroll, wait, terminate,")
  println("  answer, interact")
}
