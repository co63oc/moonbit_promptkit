///|
/// 视频编辑示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/vace
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
pub let sample_image_1 : String = "http://wanx.alicdn.com/material/20250318/image_reference_2_5_16.png"

///|
pub let sample_image_2 : String = "http://wanx.alicdn.com/material/20250318/image_reference_1_5_16.png"

///|
pub let sample_video : String = "http://wanx.alicdn.com/material/20250318/video_repainting_1.mp4"

///|
async fn main {
  println("=== Wan VACE 视频编辑示例 ===\n")

  // Demo 1: 多图参考生成视频
  println("--- Demo 1: 多图参考 (Image Reference) ---")
  println("注意：视频生成任务通常需要 2-5 分钟")
  try {
    let video_url = @lib_vace.image_reference(
      config,
      "视频中，一位女孩自晨雾缭绕的古老森林深处款款走出，她步伐轻盈，镜头捕捉她每一个灵动瞬间。",
      [sample_image_1, sample_image_2],
      ["obj", "bg"],
      size="1280*720",
    )
    println("视频生成完成！")
    println("视频URL: \{video_url}")
  } catch {
    e => println("多图参考失败: \{e}")
  }
  println("")

  // Demo 2: 视频重绘
  println("--- Demo 2: 视频重绘 (Video Repainting) ---")
  try {
    let video_url = @lib_vace.video_repainting(
      config, "视频展示了一辆黑色的蒸汽朋克风格汽车，绅士驾驶着，车辆装饰着齿轮和铜管。",
      sample_video, @lib_vace.depth_condition,
    )
    println("视频重绘完成！")
    println("视频URL: \{video_url}")
  } catch {
    e => println("视频重绘失败: \{e}")
  }
  println("")

  println("=== 提示 ===")
  println("VACE 支持的功能:")
  println("  - 多图参考：融合多张参考图生成视频")
  println("  - 视频重绘：基于输入视频生成新视频")
  println("  - 局部编辑：编辑视频特定区域")
  println("  - 视频延展：延长视频时长")
  println("")
  println("视频重绘控制条件:")
  println("  - PoseBodyFace: 提取脸部表情和肢体动作")
  println("  - PoseBody: 仅提取肢体动作")
  println("  - Depth: 提取构图和运动轮廓")
  println("  - Scribble: 提取线稿结构")
  println("")
  println("可用模型: \{@lib_vace.default_model}")
  println("输出规格: 720P, 不超过5秒, 30fps, MP4")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
}
