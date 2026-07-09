///|
/// 模型列表示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/models
/// 接口文档: https://help.aliyun.com/zh/model-studio/models
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
  let mock_body = @lib.read_file("cmd/bailian/models/mocks/response.json")
  let config : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )

  println("=== 百炼模型列表示例 ===\n")

  // Demo 1: 列出所有可用模型
  println("--- Demo 1: 列出所有可用模型 ---")
  let models = @lib.list_models(config)
  println("可用模型总数: " + models.data.length().to_string())
  println("")

  println("模型列表:")
  let mut index = 1
  for model in models.data {
    println("  " + index.to_string() + ". " + model.id)
    index = index + 1
  }
  println("")

  // Demo 2: 获取单个模型详情
  println("--- Demo 2: 获取单个模型详情 ---")
  if models.data.length() > 0 {
    let first_model_id = models.data[0].id
    if api_key != "" {
      let model_info = @lib.get_model(config, first_model_id)
      println("模型 ID: " + model_info.id)
      match model_info.object {
        Some(obj) => println("对象类型: " + obj)
        None => println("对象类型: (无)")
      }
      match model_info.owned_by {
        Some(owner) => println("所属方: " + owner)
        None => println("所属方: (无)")
      }
      match model_info.created {
        Some(ts) => println("创建时间: " + ts.to_string())
        None => println("创建时间: (无)")
      }
    } else {
      // 无 API Key 时从 mock 文件读取
      let mock_detail = @lib.read_file(
        "cmd/bailian/models/mocks/model_detail.json",
      )
      let model_info : @lib.Model = @json.parse(mock_detail)
        |> @json.from_json()
      println("模型 ID: " + model_info.id)
      match model_info.object {
        Some(obj) => println("对象类型: " + obj)
        None => println("对象类型: (无)")
      }
      match model_info.owned_by {
        Some(owner) => println("所属方: " + owner)
        None => println("所属方: (无)")
      }
      match model_info.created {
        Some(ts) => println("创建时间: " + ts.to_string())
        None => println("创建时间: (无)")
      }
      println("(无 API Key，使用 mock 数据)")
    }
    println("")
  }

  // Demo 3: 切换不同模型进行对话
  println("--- Demo 3: 切换不同模型对话 ---")
  let test_models : Array[String] = ["qwen-turbo", "qwen-plus"]
  let messages : Array[@lib.Message] = [
    @lib.user_message_with_text("请用一句话介绍你自己"),
  ]

  for model_name in test_models {
    println("")
    println("模型: " + model_name)
    if api_key != "" {
      try {
        let response = @lib.chat_with_params(
          config,
          model_name,
          messages,
          Some(0.7),
          None,
          Some(100),
          None,
        )
        let answer = @lib.extract_text_from_content(response.content)
        println("回答: " + answer)
      } catch {
        _ =>
          println("调用失败: 模型可能不可用或 API Key 权限不足")
      }
    } else {
      // 无 API Key 时从 mock 文件读取
      let mock_file = match model_name {
        "qwen-turbo" => "cmd/bailian/models/mocks/chat_turbo.json"
        "qwen-plus" => "cmd/bailian/models/mocks/chat_plus.json"
        _ => "cmd/bailian/models/mocks/chat_turbo.json"
      }
      let mock_response = @lib.read_file(mock_file)
      let response : @lib.Response = @json.parse(mock_response)
        |> @json.from_json()
      if response.choices.length() > 0 {
        let answer = @lib.extract_text_from_content(
          response.choices[0].message.content,
        )
        println("回答: " + answer)
        println("(无 API Key，使用 mock 数据)")
      }
    }
  }

  println("")
  println("=== API 总览 ===")
  println("")
  println("【模型列表】")
  println("  list_models() - 列出所有可用模型")
  println("  get_model() - 获取单个模型详情")
  println("  get_model_names() - 从列表中提取模型名称数组")
  println("")
  println("【对话接口】")
  println("  chat() - 基础对话")
  println("  chat_with_params() - 带参数对话")
  println("  chat_full() - 返回完整响应（含用量）")
  println("  chat_stream() - 流式对话")
  println("  chat_with_search() - 联网搜索对话")
  println("  chat_with_tools() - 工具调用对话")
  println("  chat_thinking() - 推理模型对话")
  println("")
  println("提示：使用前请设置 BAILIAN_API_KEY 环境变量")
}
