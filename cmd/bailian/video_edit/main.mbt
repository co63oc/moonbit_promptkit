///|
/// Video Editing example (视频编辑示例)
/// Demonstrates Wan Video Editing API for video style transfer and enhancement
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_video_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20260129/qigswt/wan-r2v-role2.mp4"

///|
async fn main {
  println("=== Wan 视频编辑示例 (Video Editing) ===\n")

  // Demo 1: 视频风格迁移
  println("--- Demo 1: 视频风格迁移 ---")
  try {
    let video_url = @lib_video_edit.edit_video(
      config,
      sample_video_url,
      "将视频转换为赛博朋克风格，霓虹灯光效果",
      resolution="720P",
    )
    println("视频编辑完成！")
    println("视频URL: \{video_url}")
  } catch {
    e => println("视频编辑失败: \{e}")
  }
  println("")

  // Demo 2: 视频增强
  println("--- Demo 2: 视频画质增强 ---")
  try {
    let video_url = @lib_video_edit.edit_video(
      config,
      sample_video_url,
      "提升视频画质，增强细节，使画面更清晰",
      resolution="1080P",
    )
    println("视频增强完成！")
    println("视频URL: \{video_url}")
  } catch {
    e => println("视频增强失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("视频编辑为异步任务，通常需要 1-3 分钟")
  println("可用模型: \{@lib_video_edit.default_model}")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
