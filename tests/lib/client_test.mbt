///|
test "user_message_with_text" {
  let message = @promptkit.user_message_with_text("Hello")
  assert_true(message.role == "user")
}

///|
test "system_message" {
  let message = @promptkit.system_message("You are helpful")
  assert_true(message.role == "system")
}

///|
test "assistant_message" {
  let message = @promptkit.assistant_message("Hi there")
  assert_true(message.role == "assistant")
}

///|
test "assistant_message_partial" {
  let message = @promptkit.assistant_message_partial("thinking...")
  assert_true(message.role == "assistant")
  assert_true(message.partial is Some(_))
}

///|
test "tool_message" {
  let message = @promptkit.tool_message("call_123", "result data")
  assert_true(message.role == "tool")
  assert_true(message.tool_call_id is Some(_))
}

///|
test "extract_text_from_content_string" {
  let content = Json::string("Hello world")
  let result = @promptkit.extract_text_from_content(content)
  assert_eq(result, "Hello world")
}

///|
test "extract_text_from_content_array" {
  let content = Json::array([Json::object({ "text": Json::string("Hello") })])
  let result = @promptkit.extract_text_from_content(content)
  assert_eq(result, "Hello")
}

///|
test "extract_text_from_content_empty_array" {
  let content = Json::array([])
  let result = @promptkit.extract_text_from_content(content)
  assert_eq(result, "(无回复)")
}

///|
test "extract_text_from_content_non_text" {
  let content = Json::object({})
  let result = @promptkit.extract_text_from_content(content)
  assert_eq(result, "(无文本回复)")
}

///|
test "text_content" {
  let c = @promptkit.text_content("hello")
  assert_true(c.type_ == "text")
  assert_true(c.text is Some(_))
}

///|
test "image_content" {
  let c = @promptkit.image_content("https://example.com/img.png")
  assert_true(c.type_ == "image_url")
  assert_true(c.image_url is Some(_))
}

///|
test "video_content" {
  let c = @promptkit.video_content("https://example.com/vid.mp4")
  assert_true(c.type_ == "video_url")
  assert_true(c.video_url is Some(_))
}

///|
test "audio_content" {
  let c = @promptkit.audio_content("https://example.com/audio.mp3")
  assert_true(c.type_ == "audio_url")
  assert_true(c.audio_url is Some(_))
}

///|
test "text_content_with_cache" {
  let c = @promptkit.text_content_with_cache("cached text")
  assert_true(c.type_ == "text")
  assert_true(c.cache_control is Some(_))
}

///|
test "content_with_cache" {
  let original = @promptkit.text_content("hello")
  let cached = @promptkit.content_with_cache(original)
  assert_true(cached.cache_control is Some(_))
  assert_true(cached.text is Some(_))
}

///|
test "stream_options" {
  let opts = @promptkit.stream_options(true)
  assert_true(opts.include_usage)
}

///|
test "user_message_with_contents" {
  let contents = [
    @promptkit.text_content("hello"),
    @promptkit.image_content("https://img.png"),
  ]
  let message = @promptkit.user_message_with_contents(contents)
  assert_true(message.role == "user")
}

///|
test "system_message_with_cache" {
  let message = @promptkit.system_message_with_cache("system prompt")
  assert_true(message.role == "system")
}

///|
test "user_message_with_cache" {
  let message = @promptkit.user_message_with_cache("user prompt")
  assert_true(message.role == "user")
}

///|
test "batch_chat_base_url" {
  assert_true(
    @promptkit.batch_chat_base_url ==
    "https://batch.dashscope.aliyuncs.com/compatible-mode/v1",
  )
}

///|
test "response_message" {
  let msg = @promptkit.response_message("user", [@promptkit.input_text("hello")])
  assert_true(msg.role == "user")
}

///|
test "input_text" {
  let content = @promptkit.input_text("hello")
  match content {
    @promptkit.InputContent::Text(t) => assert_true(t.text == "hello")
    _ => fail("expected Text")
  }
}

///|
test "input_image" {
  let content = @promptkit.input_image("https://img.png")
  match content {
    @promptkit.InputContent::Image(i) =>
      assert_true(i.image_url == "https://img.png")
    _ => fail("expected Image")
  }
}

///|
test "web_search_image_tool" {
  let tool = @promptkit.web_search_image_tool()
  assert_true(tool.type_ == "web_search_image")
}

///|
test "image_search_tool" {
  let tool = @promptkit.image_search_tool()
  assert_true(tool.type_ == "image_search")
}

///|
test "file_search_tool" {
  let tool = @promptkit.file_search_tool()
  assert_true(tool.type_ == "file_search")
}

///|
test "file_search_tool_with_ids" {
  let tool = @promptkit.file_search_tool_with_ids(["vs_123", "vs_456"])
  assert_true(tool.type_ == "file_search")
  assert_true(tool.vector_store_ids is Some(_))
}
