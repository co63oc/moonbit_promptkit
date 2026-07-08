///|
/// 简单对话示例（腾讯混元）
///
/// 运行命令: moon run cmd/hunyuan/chat
/// 接口文档: https://cloud.tencent.com/document/product/1729/111007
///
/// 环境变量要求:
/// - HUNYUAN_API_KEY: 腾讯混元 API Key
/// - HUNYUAN_BASE_URL: API Base URL（默认: https://tokenhub.tencentmaas.com/v1）
///

///|
let mock_body = "{\"id\": \"119fc518-b988-4a81-8e57-d6fd46e96bd0\", \"object\": \"chat.completion\", \"model\": \"hy3-preview\", \"created\": 1783502140, \"choices\": [{\"index\": 0, \"message\": {\"role\": \"assistant\", \"content\": \"我暂时无法获取实时天气数据，建议你通过以下方式查询杭州明天的天气：  \\n1. 打开手机天气应用（如系统自带天气、墨迹天气等）；  \\n2. 访问中国天气网（www.weather.com.cn）或杭州市气象局官网；  \\n3. 直接搜索“杭州明天天气”（如百度、谷歌搜索）。  \\n\\n通常杭州春季（3-5月）多阴雨，夏季（6-8月）炎热潮湿，秋季（9-11月）凉爽干燥，冬季（12-2月）湿冷少雪，你可以根据当前季节大致预判哦～ 🌤️\"}, \"finish_reason\": \"stop\"}], \"usage\": {\"prompt_tokens\": 25, \"completion_tokens\": 136, \"total_tokens\": 161, \"prompt_tokens_details\": {\"cached_tokens\": 0}, \"completion_tokens_details\": {\"reasoning_tokens\": 0}}}"

///|
async fn main {
  let api_key = @lib.get_env_var("HUNYUAN_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "HUNYUAN_BASE_URL",
    Some("https://tokenhub.tencentmaas.com/v1"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "杭州明天天气如何"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("用户: \{user_question}")
  let response = @lib.chat(config, "hy3-preview", messages)
  println("助手: \{@lib.extract_text_from_content(response.content)}")
}
