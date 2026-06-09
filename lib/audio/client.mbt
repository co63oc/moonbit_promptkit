///|
/// Audio understanding API for Qwen3-Omni-Captioner
/// Uses OpenAI-compatible `input_audio` format
///

///| Caption audio using Qwen3-Omni-Captioner
pub async fn caption_audio(
  config : @lib.ClientConfig,
  audio_url : String,
) -> String {
  caption_audio_impl(config, audio_url, default_model, None)
}

///| Caption audio with specific model
pub async fn caption_audio_with_model(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
) -> String {
  caption_audio_impl(config, audio_url, model, None)
}

///| Caption audio with custom prompt
pub async fn caption_audio_with_prompt(
  config : @lib.ClientConfig,
  audio_url : String,
  prompt : String,
) -> String {
  caption_audio_impl(config, audio_url, default_model, Some(prompt))
}

///| Internal: build request and call API
fn caption_audio_impl(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
  prompt : String?,
) -> String {
  let content_items = match prompt {
    Some(p) =>
      [
        audio_content(audio_url).to_json(),
        @lib.text_content(p).to_json(),
      ]
    None =>
      [audio_content(audio_url).to_json()]
  }
  let message_json = { "role": "user", "content": content_items }
  let request = AudioRequest::{
    model,
    messages: [message_json],
    stream: None,
    stream_options: None,
  }
  let (response, body) = @http.post(
    "\{config.base_url}/chat/completions",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Audio caption request failed: \{response.code} \{response.reason}")
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No audio caption generated")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}
