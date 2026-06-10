///|
/// 图像编辑 API：Qwen Image Edit + Wan Image Edit
/// 使用 DashScope multimodal-generation 同步端点
///
/// 支持模型：
///   - qwen-image-2.0-pro / qwen-image-edit（Qwen 图像编辑）
///   - wan2.7-image-pro（Wan 图像编辑）
///

///|
/// 默认图像编辑模型
pub let default_model : String = "qwen-image-2.0-pro"

///|
let dashscope_base : String = "https://dashscope.aliyuncs.com/api/v1"

///| 图像编辑：文本指令 + 参考图像

///|
/// 返回编辑后的图像 URL 列表
pub async fn edit_image(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  image_urls : Array[String],
  n? : Int,
  size? : String,
  prompt_extend? : Bool,
) -> Array[String] {
  let content : Array[Json] = []
  // Add text prompt
  let text_item = TextItem::{ text: prompt }
  content.push(text_item.to_json())
  // Add reference images
  for url in image_urls {
    let img_item = ImageItem::{ image: url }
    content.push(img_item.to_json())
  }
  let message = EditMessage::{ role: "user", content }
  let params = EditParams::{ n, size, prompt_extend }
  let request = EditRequest::{
    model,
    input: EditInput::{ messages: [message] },
    parameters: Some(params),
  }
  let (response, resp_body) = @http.post(
    "\{dashscope_base}/services/aigc/multimodal-generation/generation",
    request.to_json(),
    headers={
      "Authorization": "Bearer \{config.api_key}",
      "Content-Type": "application/json",
    },
  )
  guard response.code is (200..=299) else {
    fail("Image edit request failed: \{response.code} \{response.reason}")
  }
  let resp : EditResponse = @json.from_json(resp_body.json())
  match resp.code {
    Some(code) if code != "" =>
      fail("Image edit error: \{code} \{resp.message.unwrap_or("")}")
    _ => ()
  }
  extract_edit_urls(resp)
}

///|
/// 图像编辑便捷函数（使用默认模型）
pub async fn edit_easy(
  config : @lib.ClientConfig,
  prompt : String,
  image_url : String,
) -> Array[String] {
  edit_image(config, default_model, prompt, [image_url])
}

///|
/// 多参考图编辑
pub async fn edit_with_refs(
  config : @lib.ClientConfig,
  model : String,
  prompt : String,
  ref_image_url : String,
  edit_image_url : String,
) -> Array[String] {
  edit_image(config, model, prompt, [ref_image_url, edit_image_url])
}

// ---- Internal ----

///|
fn extract_edit_urls(resp : EditResponse) -> Array[String] {
  let urls : Array[String] = []
  match resp.output.choices {
    Some(choices) =>
      for choice in choices {
        for item in choice.message.content {
          match item.image {
            Some(url) => urls.push(url)
            None => ()
          }
        }
      }
    None => ()
  }
  urls
}
