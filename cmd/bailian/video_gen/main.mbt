///|
/// Video generation and 3D generation example (视频生成与3D生成示例)
/// 展示图生视频、参考生视频、视频编辑、3D生成等功能
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
let sample_image_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20250925/wpimhv/rap.png"

///|
///let sample_video_url : String = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20260129/qigswt/wan-r2v-role2.mp4"

///|
async fn main {
  println("=== 百炼视频生成与3D生成示例 ===\n")

  println("=== 视频生成 API ===")
  println("")
  println("【图生视频 (Image-to-Video)】")
  println("  create_video_gen_task() - 创建视频生成任务")
  println("  get_video_gen_result() - 查询视频生成结果")
  println("  image_to_video() - 图生视频（便捷函数）")
  println("  image_to_video_with_params() - 带参数的图生视频")
  println("  wait_for_video_gen() - 等待视频生成完成（轮询）")
  println("")
  println("【参考生视频 (Reference-to-Video)】")
  println("  reference_to_video() - 参考生视频")
  println("")
  println("【视频编辑 (Video Editing)】")
  println("  edit_video() - 视频编辑")
  println("")
  println("【常用视频模型】")
  println("  wan2.6-i2v-flash - 图生视频，高速版")
  println("  wan2.6-i2v - 图生视频，标准版")
  println("  wan2.7-r2v - 参考生视频（多主体）")
  println("  wan2.7-videoedit - 视频编辑")
  println(
    "  wanx2.1-vace-plus - VACE 视频编辑（多图参考、视频重绘）",
  )
  println("")

  // Demo 1: 图生视频 - 创建任务并轮询获取结果
  println("--- Demo 1: 图生视频（创建任务 + 轮询获取视频） ---")
  try {
    let task_resp = @lib.image_to_video(
      config, "wan2.6-i2v-flash", "一个可爱的猫咪在草地上奔跑，阳光明媚的午后",
      sample_image_url,
    )
    let task_id = task_resp.output.task_id
    println("任务创建成功! 任务ID: " + task_id)
    println("任务状态: " + task_resp.output.task_status)
    println("")

    // 轮询等待视频生成完成
    println("开始轮询等待视频生成完成...")
    let result = @lib.wait_for_video_gen(config, task_id, 60, 5000)
    let final_status = result.output.task_status
    println("最终状态: " + final_status)

    match final_status {
      "SUCCEEDED" => {
        match result.output.video_url {
          Some(url) => println("视频生成成功! 视频URL: " + url)
          None => println("视频生成成功，但未获取到视频URL")
        }
      }
      "FAILED" => println("视频生成失败!")
      "CANCELLED" => println("视频生成已取消")
      _ => println("轮询超时，任务仍在进行中，请稍后手动查询: get_video_gen_result(\"" + task_id + "\")")
    }
  } catch {
    _ => println("创建任务失败: 请检查 API Key 和模型权限")
  }
  println("")

  println("=== 快速使用示例 ===")
  println("")
  println("// 图生视频完整流程:")
  println("let task = image_to_video(config, model, prompt, img_url)")
  println("let task_id = task.output.task_id")
  println("let result = wait_for_video_gen(config, task_id, 30, 5000)")
  println("match result.output.video_url {")
  println("  Some(url) => println(\"视频URL: \" + url)")
  println("  None => println(\"视频生成失败\")")
  println("}")
  println("")
  println("提示: 使用前请设置 BAILIAN_API_KEY 环境变量")
  println(
    "注意: 视频生成和3D生成为异步任务，需要轮询获取结果",
  )
}
