///|
/// 简单对话示例（OpenRouter）
///
/// 运行命令: moon run cmd/openrouter/chat
/// 接口文档: https://openrouter.ai/docs/api-reference/chat-completion
///
/// 环境变量要求:
/// - OPENROUTER_API_KEY: OpenRouter API Key
/// - OPENROUTER_BASE_URL: API Base URL（默认: https://openrouter.ai/api/v1）
///

///|
let mock_body = "{\"id\": \"gen-1783502006-gsAIN7JmPe8VASxwnmmk\", \"object\": \"chat.completion\", \"created\": 1783502006, \"model\": \"google/gemma-4-31b-it-20260402:free\", \"provider\": \"Google AI Studio\", \"system_fingerprint\": null, \"service_tier\": \"default\", \"choices\": [{\"index\": 0, \"logprobs\": null, \"finish_reason\": \"stop\", \"native_finish_reason\": \"STOP\", \"message\": {\"role\": \"assistant\", \"content\": \"On a clear day, the sky appears **blue**.\", \"refusal\": null, \"reasoning\": null}}], \"usage\": {\"prompt_tokens\": 14, \"completion_tokens\": 11, \"total_tokens\": 25, \"cost\": 0, \"is_byok\": false, \"prompt_tokens_details\": {\"cached_tokens\": 0, \"cache_write_tokens\": 0, \"audio_tokens\": 0, \"video_tokens\": 0}, \"cost_details\": {\"upstream_inference_cost\": 0, \"upstream_inference_prompt_cost\": 0, \"upstream_inference_completions_cost\": 0}, \"completion_tokens_details\": {\"reasoning_tokens\": 0, \"image_tokens\": 0, \"audio_tokens\": 0}}}"

///|
async fn main {
  let api_key = @lib.get_env_var("OPENROUTER_API_KEY", Some(""))
  let base_url = @lib.get_env_var(
    "OPENROUTER_BASE_URL",
    Some("https://openrouter.ai/api/v1"),
  )
  let config = @lib.make_client_config(
    api_key,
    base_url,
    mock_body=Some(mock_body),
  )
  let user_question = "What color is the sky?"
  let messages : Array[@lib.Message] = [
    @lib.system_message("You are a helpful assistant."),
    @lib.user_message_with_text(user_question),
  ]
  println("User: \{user_question}")
  let response = @lib.chat(config, "google/gemma-4-31b-it:free", messages)
  println("Assistant: \{@lib.extract_text_from_content(response.content)}")
}
