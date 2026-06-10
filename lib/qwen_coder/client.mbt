///|
pub async fn code_generate(
  config : @lib.ClientConfig,
  prompt : String,
  model : String,
  language : String?,
) -> @lib.Message {
  let sys_prompt = match language {
    Some(lang) =>
      "You are an expert \{lang} programmer. Generate clean, efficient, and well-documented code."
    None =>
      "You are an expert programmer. Generate clean, efficient, and well-documented code."
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_prompt),
    @lib.user_message_with_text(prompt),
  ]
  @lib.chat(config, model, messages)
}

///|
pub async fn code_generate_stream(
  config : @lib.ClientConfig,
  prompt : String,
  on_delta : (String) -> Unit,
  model : String,
  language : String?,
) -> String {
  let sys_prompt = match language {
    Some(lang) =>
      "You are an expert \{lang} programmer. Generate clean, efficient, and well-documented code."
    None =>
      "You are an expert programmer. Generate clean, efficient, and well-documented code."
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_prompt),
    @lib.user_message_with_text(prompt),
  ]
  @lib.chat_stream(config, model, messages, on_delta)
}

///|
pub async fn code_with_tools(
  config : @lib.ClientConfig,
  prompt : String,
  tools : Json,
  model : String,
  language : String?,
) -> @lib.Message {
  let sys_prompt = match language {
    Some(lang) =>
      "You are an expert \{lang} programmer. Generate clean, efficient, and well-documented code."
    None =>
      "You are an expert programmer. Generate clean, efficient, and well-documented code."
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(sys_prompt),
    @lib.user_message_with_text(prompt),
  ]
  @lib.chat_with_tools(config, model, messages, tools)
}

///|
pub async fn code_explain(
  config : @lib.ClientConfig,
  code : String,
  model : String,
) -> @lib.Message {
  let messages : Array[@lib.Message] = [
    @lib.system_message(
      "You are an expert code reviewer and explainer. Provide clear, detailed explanations of code.",
    ),
    @lib.user_message_with_text("Please explain the following code:\n\n\{code}"),
  ]
  @lib.chat(config, model, messages)
}

///|
pub async fn code_refactor(
  config : @lib.ClientConfig,
  code : String,
  suggestions : String?,
  model : String,
) -> @lib.Message {
  let user_msg = match suggestions {
    Some(s) =>
      "Please refactor the following code with these suggestions: \{s}\n\n\{code}"
    None =>
      "Please refactor the following code to improve readability, performance, and maintainability:\n\n\{code}"
  }
  let messages : Array[@lib.Message] = [
    @lib.system_message(
      "You are an expert code refactoring specialist. Provide improved, production-ready code.",
    ),
    @lib.user_message_with_text(user_msg),
  ]
  @lib.chat(config, model, messages)
}
