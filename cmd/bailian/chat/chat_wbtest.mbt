///|
/// Whitebox tests for cmd/bailian/chat.
/// The mock tests do NOT require BAILIAN_API_KEY (no network call is made).
/// The real test only runs when BAILIAN_API_KEY is present in the environment.

///|
/// Mock test: chat() success path with a canned response (no API_KEY needed).
async test "bailian chat mock success" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://dashscope.aliyuncs.com/compatible-mode/v1",
  )
  let body = "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"你好!\"}}],\"usage\":null}"
  @lib.test_install_mock(200, "OK", body)
  try {
    let msg = @lib.chat(cfg, "qwen3.7-plus", [
      @lib.user_message_with_text("你好!"),
    ])
    assert_eq(@lib.extract_text_from_content(msg.content), "你好!")
    @lib.test_restore_mock()
  } catch {
    e => {
      @lib.test_restore_mock()
      raise e
    }
  }
}

///|
/// Mock test: a 401 from the bailian endpoint must fail (no API_KEY needed).
async test "bailian chat mock 401 fails" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://dashscope.aliyuncs.com/compatible-mode/v1",
  )
  @lib.test_install_mock(401, "Unauthorized", "{\"error\":\"no key\"}")
  let mut got_error = false
  try {
    ignore(@lib.chat(cfg, "qwen3.7-plus", [@lib.user_message_with_text("hi")]))
    @lib.test_restore_mock()
  } catch {
    _ => {
      got_error = true
      @lib.test_restore_mock()
    }
  }
  assert_true(got_error)
}

///|
/// Mock test: request carries the Authorization header and correct base URL.
async test "bailian chat mock records auth header" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://dashscope.aliyuncs.com/compatible-mode/v1",
  )
  @lib.test_install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(@lib.chat(cfg, "qwen3.7-plus", [@lib.user_message_with_text("hi")]))
    @lib.test_restore_mock()
  } catch {
    _ => @lib.test_restore_mock()
  }
  let (url, _body, headers) = @lib.test_last_request()
  assert_true(headers.get("Authorization") == Some("Bearer dummy-key"))
  assert_true(
    url == "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
  )
}

///|
/// Mock test: chat() with a multi-turn conversation (no API_KEY needed).
async test "bailian chat mock multi-turn" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://dashscope.aliyuncs.com/compatible-mode/v1",
  )
  let body =
    "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"再次问好!\"}}],\"usage\":null}"
  @lib.test_install_mock(200, "OK", body)
  try {
    let msg = @lib.chat(cfg, "qwen3.7-plus", [
      @lib.user_message_with_text("你好!"),
      @lib.assistant_message("你好!"),
      @lib.user_message_with_text("再次问好!"),
    ])
    assert_eq(@lib.extract_text_from_content(msg.content), "再次问好!")
    @lib.test_restore_mock()
  } catch {
    e => {
      @lib.test_restore_mock()
      raise e
    }
  }
}
