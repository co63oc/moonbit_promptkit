///| Qwen-Long 超长文档推理接口

///| 支持上传文件或直接传入文档文本进行长文档推理

///|

///|
/// 默认模型名称
pub let default_model : String = "qwen-long"

///| 上传文件并获取 file_id

///| 用于后续通过 fileid:// 协议引用文档

///|
/// purpose 固定为 "file-extract"
pub async fn upload_file(
  config : @lib.ClientConfig,
  filename : String,
  file_content : String,
) -> FileUploadResult {
  let boundary = "----MoonBitBoundary\{filename.length()}"
  let mut body = ""
  body = body + "--" + boundary + "\r\n"
  body = body + "Content-Disposition: form-data; name=\"purpose\"\r\n\r\n"
  body = body + "file-extract\r\n"
  body = body + "--" + boundary + "\r\n"
  body = body +
    "Content-Disposition: form-data; name=\"file\"; filename=\"" +
    filename +
    "\"\r\n"
  body = body + "Content-Type: text/plain\r\n\r\n"
  body = body + file_content + "\r\n"
  body = body + "--" + boundary + "--\r\n"
  let (response, body_resp) = @http.post("\{config.base_url}/files", body, headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "multipart/form-data; boundary=" + boundary,
  })
  guard response.code is (200..=299) else {
    fail("File upload failed: \{response.code} \{response.reason}")
  }
  @json.from_json(body_resp.json())
}

///| 使用已上传的 file_id 进行文档问答（非流式）

///|
/// 支持多个 file_id 同时引用
pub async fn chat_with_files(
  config : @lib.ClientConfig,
  model : String,
  file_ids : Array[String],
  question : String,
  system_prompt : String?,
) -> @lib.Message {
  let mut file_refs = ""
  for id in file_ids {
    file_refs = file_refs + "fileid://" + id + "\n"
  }
  let sys_content = match system_prompt {
    Some(prompt) => prompt + "\n\n" + file_refs
    None => "请根据以下文档内容回答问题：\n\n" + file_refs
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_content),
    @lib.user_message_with_text(question),
  ]
  @lib.chat(config, model, messages)
}

///|
/// 使用已上传的 file_id 进行文档问答（流式）
pub async fn chat_with_files_stream(
  config : @lib.ClientConfig,
  model : String,
  file_ids : Array[String],
  question : String,
  on_delta : (String) -> Unit,
  system_prompt : String?,
) -> String {
  let mut file_refs = ""
  for id in file_ids {
    file_refs = file_refs + "fileid://" + id + "\n"
  }
  let sys_content = match system_prompt {
    Some(prompt) => prompt + "\n\n" + file_refs
    None => "请根据以下文档内容回答问题：\n\n" + file_refs
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_content),
    @lib.user_message_with_text(question),
  ]
  @lib.chat_stream(config, model, messages, on_delta)
}

///| 直接传入文档文本进行问答（非流式）

///|
/// 适用于文档内容较小的场景
pub async fn chat_with_text(
  config : @lib.ClientConfig,
  model : String,
  doc_text : String,
  question : String,
  system_prompt : String?,
) -> @lib.Message {
  let sys_content = match system_prompt {
    Some(prompt) => prompt + "\n\n" + doc_text
    None => "请根据以下文档内容回答问题：\n\n" + doc_text
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_content),
    @lib.user_message_with_text(question),
  ]
  @lib.chat(config, model, messages)
}

///|
/// 直接传入文档文本进行问答（流式）
pub async fn chat_with_text_stream(
  config : @lib.ClientConfig,
  model : String,
  doc_text : String,
  question : String,
  on_delta : (String) -> Unit,
  system_prompt : String?,
) -> String {
  let sys_content = match system_prompt {
    Some(prompt) => prompt + "\n\n" + doc_text
    None => "请根据以下文档内容回答问题：\n\n" + doc_text
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_content),
    @lib.user_message_with_text(question),
  ]
  @lib.chat_stream(config, model, messages, on_delta)
}
