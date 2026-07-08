///|
/// 流式输出示例（OpenRouter）
///
/// 运行命令: moon run cmd/openrouter/stream
/// 接口文档: https://openrouter.ai/docs/api-reference/chat-completion
///
/// 环境变量要求:
/// - OPENROUTER_API_KEY: OpenRouter API Key
/// - OPENROUTER_BASE_URL: API Base URL（默认: https://openrouter.ai/api/v1）
///

///|
let mock_body = ": OPENROUTER PROCESSING\n\n: OPENROUTER PROCESSING\n\n: OPENROUTER PROCESSING\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\"Artificial intelligence began in the 1950s with the\",\"role\":\"assistant\"},\"finish_reason\":null,\"native_finish_reason\":null}]}\n\n: OPENROUTER PROCESSING\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\" ambition to create machines that could simulate human intelligence, leading to early successes in logic and game-playing. The field experienced\",\"role\":\"assistant\"},\"finish_reason\":null,\"native_finish_reason\":null}]}\n\n: OPENROUTER PROCESSING\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\" several \\\"AI winters\\\" due to overhyped expectations and limited computing power, but it rebounded with the rise of machine\",\"role\":\"assistant\"},\"finish_reason\":null,\"native_finish_reason\":null}]}\n\n: OPENROUTER PROCESSING\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\" learning and big data in the late 20th century. Today, AI has entered a transformative era dominated by deep\",\"role\":\"assistant\"},\"finish_reason\":null,\"native_finish_reason\":null}]}\n\n: OPENROUTER PROCESSING\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\" learning and large language models, enabling machines to generate human-like text, images, and complex reasoning.\",\"role\":\"assistant\"},\"finish_reason\":null,\"native_finish_reason\":null}]}\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\"\",\"role\":\"assistant\"},\"finish_reason\":\"stop\",\"native_finish_reason\":\"STOP\"}]}\n\ndata: {\"id\":\"gen-1783502007-pDPlrfE0b7tZ4Vho7fyh\",\"object\":\"chat.completion.chunk\",\"created\":1783502007,\"model\":\"google/gemma-4-31b-it-20260402:free\",\"provider\":\"Google AI Studio\",\"service_tier\":\"default\",\"choices\":[{\"index\":0,\"delta\":{\"content\":\"\",\"role\":\"assistant\"},\"finish_reason\":\"stop\",\"native_finish_reason\":\"STOP\"}],\"usage\":{\"prompt_tokens\":11,\"completion_tokens\":106,\"total_tokens\":117,\"cost\":0,\"is_byok\":false,\"prompt_tokens_details\":{\"cached_tokens\":0,\"cache_write_tokens\":0,\"audio_tokens\":0,\"video_tokens\":0},\"cost_details\":{\"upstream_inference_cost\":0,\"upstream_inference_prompt_cost\":0,\"upstream_inference_completions_cost\":0},\"completion_tokens_details\":{\"reasoning_tokens\":0,\"image_tokens\":0,\"audio_tokens\":0}}}\n\ndata: [DONE]\n\n"

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

  println("=== Demo 1: Streaming output ===")
  let messages1 : Array[@lib.Message] = [
    @lib.user_message_with_text("Describe the history of AI in 3 sentences."),
  ]
  println("User: Describe the history of AI in 3 sentences.")
  println("Assistant: ")
  let full_text1 = @lib.chat_stream(
    config,
    "google/gemma-4-31b-it:free",
    messages1,
    fn(text) { println(text) },
  )
  println("\nFull reply: \{full_text1}")

  println("\n=== Demo 2: Non-streaming output ===")
  let messages2 : Array[@lib.Message] = [
    @lib.user_message_with_text("Hello, introduce yourself briefly."),
  ]
  println("User: Hello, introduce yourself briefly.")
  let response2 = @lib.chat(config, "google/gemma-4-31b-it:free", messages2)
  println("Assistant: \{@lib.extract_text_from_content(response2.content)}")
}
