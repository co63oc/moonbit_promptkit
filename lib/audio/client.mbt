///|
/// Audio understanding API for Qwen3-Omni-Captioner
/// Uses OpenAI-compatible `input_audio` format
///

///|
/// Caption audio using Qwen3-Omni-Captioner
pub async fn caption_audio(
  config : @lib.ClientConfig,
  audio_url : String,
) -> String {
  caption_audio_impl(config, audio_url, default_model, None)
}

///|
/// Caption audio with specific model
pub async fn caption_audio_with_model(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
) -> String {
  caption_audio_impl(config, audio_url, model, None)
}

///|
/// Caption audio with custom prompt
pub async fn caption_audio_with_prompt(
  config : @lib.ClientConfig,
  audio_url : String,
  prompt : String,
) -> String {
  caption_audio_impl(config, audio_url, default_model, Some(prompt))
}

///|
/// Clean text content struct (no null fields like image_url, video_url, etc.)
struct CleanTextContent {
  type_ : String
  text : String
} derive(ToJson(fields(type_(rename="type"))))

///|
/// Message structure for audio requests
struct AudioMessage {
  role : String
  content : Array[Json]
} derive(ToJson)

///|
/// Internal: build request and call API
async fn caption_audio_impl(
  config : @lib.ClientConfig,
  audio_url : String,
  model : String,
  prompt : String?,
) -> String {
  // Build audio content
  let audio_json = audio_content(audio_url).to_json()

  // Audio always goes in a user message
  let audio_message = AudioMessage::{ role: "user", content: [audio_json] }

  // When there's a custom prompt, add it as a separate system message.
  // The API rejects mixed audio+text in a single user message content array.
  let messages : Array[Json] = match prompt {
    Some(p) => {
      let text_json = CleanTextContent::{ type_: "text", text: p }.to_json()
      let system_message = AudioMessage::{
        role: "system",
        content: [text_json],
      }
      [system_message.to_json(), audio_message.to_json()]
    }
    None => [audio_message.to_json()]
  }

  // Build request
  let request = AudioRequest::{
    model,
    messages,
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
    let error_text = body.text()
    fail(
      "Audio caption request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  let resp : @lib.Response = body.json() |> @json.from_json()
  if resp.choices.length() == 0 {
    fail("No audio caption generated")
  } else {
    @lib.extract_text_from_content(resp.choices[0].message.content)
  }
}
