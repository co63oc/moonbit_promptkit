///|
/// 流式输出示例（阿里云百炼）
///
/// 运行命令: moon run cmd/bailian/stream
/// 接口文档: https://help.aliyun.com/zh/model-studio/stream
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
/// FFI: write bytes to stdout and flush immediately, without adding a newline.
/// When `is_mock` is true, also applies a small delay for the typewriter effect.
#borrow(data)
extern "C" fn print_flush(data : Bytes, len : Int, is_mock : Bool) -> Unit = "moonbit_print_flush"

///|
async fn main {
  println("=== 流式输出示例（阿里云百炼）===\n")
  let is_mock = api_key == ""

  // Demo 1: 图片理解模型流式输出
  println("--- Demo 1: 图片理解模型流式输出 ---")
  let mock_body1 = @lib.read_file("cmd/bailian/stream/mocks/demo1_stream.txt")
  let config1 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body1),
  )

  let image_url = "https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20241022/emyrja/dog_and_girl.jpeg"
  let query = "图中描绘的是什么景象？"

  println("图片 URL: \{image_url}")
  println("问题: \{query}")
  println("\n流式输出:")

  let messages1 = [
    @lib.user_message_with_contents([
      @lib.image_content(image_url),
      @lib.text_content(query),
    ]),
  ]
  @lib.chat_stream(config1, "qwen3-vl-plus", messages1, fn(chunk) {
    let bytes = @encoding.encode(UTF8, chunk)
    print_flush(bytes, bytes.length(), is_mock)
  })
  |> ignore
  println("")

  // Demo 2: 纯文本模型流式输出
  println("--- Demo 2: 纯文本模型流式输出 ---")
  let mock_body2 = @lib.read_file("cmd/bailian/stream/mocks/demo2_stream.txt")
  let config2 : @lib.ClientConfig = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body2),
  )

  let question = "请用3句话介绍一下人工智能的发展历史"
  println("问题: \{question}")
  println("\n流式输出:")

  let messages2 = [@lib.user_message_with_text(question)]
  @lib.chat_stream(config2, "qwen3.7-plus", messages2, fn(chunk) {
    let bytes = @encoding.encode(UTF8, chunk)
    print_flush(bytes, bytes.length(), is_mock)
  })
  |> ignore
  println("")

  println("=== 提示 ===")
  println("使用前请设置 BAILIAN_API_KEY 环境变量")
  println("可选：设置 BAILIAN_BASE_URL 指定 API 地址")
}
