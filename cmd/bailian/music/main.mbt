///|
/// Music Generation example (音乐生成示例)
/// Demonstrates FunMusic API for generating music from text prompts
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== 百聆音乐生成示例 (FunMusic) ===\n")

  // Demo 1: 生成一段轻快的背景音乐
  println("--- Demo 1: 生成轻快背景音乐 ---")
  try {
    let audio_url = @lib_music.generate_music(
      config,
      "轻快欢快的背景音乐，适合用于视频开场，钢琴和吉他伴奏",
      duration=30,
    )
    println("音乐生成完成！")
    println("音频URL: \{audio_url}")
  } catch {
    e => println("音乐生成失败: \{e}")
  }
  println("")

  // Demo 2: 生成一段舒缓的音乐
  println("--- Demo 2: 生成舒缓音乐 ---")
  try {
    let audio_url = @lib_music.generate_music(
      config,
      "舒缓放松的钢琴曲，适合冥想和休息，慢节奏",
      duration=60,
    )
    println("音乐生成完成！")
    println("音频URL: \{audio_url}")
  } catch {
    e => println("音乐生成失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("音乐生成为异步任务，通常需要 30-60 秒")
  println("可用模型: \{@lib_music.default_model}")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
