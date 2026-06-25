///|
/// 批量推理示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/batch
///
/// 环境变量要求:
/// - BAILIAN_API_KEY: 阿里云百炼 API Key
/// - BAILIAN_BASE_URL: API Base URL（默认: https://dashscope.aliyuncs.com/compatible-mode/v1）
/// - BAILIAN_MODEL: 使用的模型（默认: qwen3.7-plus）
///

///|
pub let config : @lib.ClientConfig = @lib.create_client_config(
  "BAILIAN_API_KEY", "BAILIAN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
pub let model : String = @lib.get_env_var("BAILIAN_MODEL", Some("qwen3.7-plus"))

///|
async fn main {
  println("=== 百炼批量推理示例 ===")
  println("批量推理端点: " + @lib.batch_chat_base_url)
  println("成本: 实时调用的 50%")
  println("延迟: 比实时调用高（约 5-10 秒）\n")

  // Demo 1: Batch Chat 基础用法
  println("=== Demo 1: Batch Chat 基础用法 ===")
  let messages1 : Array[@lib.Message] = [
    @lib.system_message("你是一个专业的助手"),
    @lib.user_message_with_text("用一句话解释什么是批量推理"),
  ]
  let response1 = @lib.batch_chat(config, model, messages1)
  println("回答: \{@lib.extract_text_from_content(response1.content)}")
  println("")

  // Demo 2: Batch Chat 完整响应（含用量信息）
  println("=== Demo 2: Batch Chat 完整响应（含用量信息） ===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("请用三句话介绍MoonBit语言"),
  ]
  let response2 = @lib.batch_chat_full_with_params(
    config,
    model,
    messages2,
    None,
    None,
    Some(200),
    None,
  )
  let msg2 = response2.choices[0].message
  println("回答: \{@lib.extract_text_from_content(msg2.content)}")
  println("总 Token 数: \{@lib.get_total_tokens(response2)}")
  println("提示词 Token: \{@lib.get_prompt_tokens(response2)}")
  println("补全 Token: \{@lib.get_completion_tokens(response2)}")
  println("")

  // Demo 3: Batch File 异步批量输入输出构建
  println("=== Demo 3: Batch File 异步批量输入输出构建 ===")
  let messages_q1 : Array[@lib.Message] = [
    @lib.user_message_with_text("什么是人工智能？"),
  ]
  let messages_q2 : Array[@lib.Message] = [
    @lib.user_message_with_text("什么是机器学习？"),
  ]
  let messages_q3 : Array[@lib.Message] = [
    @lib.user_message_with_text("什么是深度学习？"),
  ]
  let batch_inputs : Array[@lib.BatchInputItem] = [
    @lib.build_chat_batch_input("q1", model, messages_q1),
    @lib.build_chat_batch_input("q2", model, messages_q2),
    @lib.build_chat_batch_input("q3", model, messages_q3),
  ]
  let jsonl = @lib.build_batch_input_jsonl(batch_inputs)
  println("--- 批量输入 JSONL 内容 ---")
  println(jsonl)
  println("")
  println("--- 使用流程 ---")
  println("1. 将上述 JSONL 内容保存为文件")
  println("2. 上传文件到百炼获取 file_id")
  println("3. 使用 create_batch() 创建批量任务")
  println("4. 使用 wait_for_batch() 或 get_batch() 轮询状态")
  println("5. 任务完成后，使用 get_file_content() 获取结果")
  println("6. 使用 parse_batch_output() 解析输出结果")
  println("")

  // Demo 4: 批量输出结果解析示例
  println("=== Demo 4: 批量输出结果解析示例 ===")
  let sample_output = "{\"id\":\"batch_req_1\",\"custom_id\":\"q1\",\"response\":{\"status_code\":200,\"request_id\":\"req-123\",\"body\":{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"人工智能是...\"}}]}}}"
  let items = @lib.parse_batch_output(sample_output)
  println("解析到 " + items.length().to_string() + " 条结果")
  for item in items {
    println("  custom_id: " + item.custom_id)
  }
  println("")

  // Demo 5: 批量客户端配置
  println("=== Demo 5: 批量客户端配置 ===")
  let batch_config = @lib.to_batch_config(config)
  println("批量推理端点: " + batch_config.base_url)
  println("")
  println("--- 配置方式 ---")
  println("1. to_batch_config(config) - 从现有配置转换")
  println("2. create_batch_client_config() - 从环境变量创建")
  println("3. batch_chat_base_url - 默认端点常量")
  println("")

  // API 总览
  println("=== Batch Chat API 总览 ===")
  println("")
  println("【基础对话】")
  println("  batch_chat() - 批量对话")
  println("  batch_chat_with_params() - 带参数的批量对话")
  println("")
  println("【完整响应】")
  println("  batch_chat_full() - 返回完整响应（含用量）")
  println("  batch_chat_full_with_params() - 带参数的完整响应")
  println("")
  println("【功能增强】")
  println("  batch_chat_with_search() - 带联网搜索的批量对话")
  println("  batch_chat_with_tools() - 带工具调用的批量对话")
  println("  batch_chat_thinking() - 带深度思考的批量对话")
  println("")
  println("【配置工具】")
  println("  to_batch_config() - 转换为批量配置")
  println("  create_batch_client_config() - 创建批量配置")
  println("  batch_chat_base_url - 默认批量端点")
  println("")
  println("=== Batch File API 总览 ===")
  println("")
  println("【任务管理】")
  println("  create_batch() - 创建批量任务")
  println("  get_batch() - 查询任务状态")
  println("  list_batches() - 列出批量任务")
  println("  cancel_batch() - 取消批量任务")
  println("  wait_for_batch() - 等待任务完成")
  println("")
  println("【文件操作】")
  println("  get_file_info() - 获取文件信息")
  println("  get_file_content() - 获取文件内容")
  println("")
  println("【工具函数】")
  println("  parse_batch_output() - 解析批量输出 JSONL")
  println("  build_chat_batch_input() - 构建对话批量输入项")
  println("  build_batch_input_jsonl() - 构建批量输入 JSONL")
  println("")
  println(
    "提示：Batch Chat 适合中小批量、需要较快响应的场景",
  )
  println(
    "提示：Batch File 适合大规模、异步处理的场景，成本最低",
  )
}
