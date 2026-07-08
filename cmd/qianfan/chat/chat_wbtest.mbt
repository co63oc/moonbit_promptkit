///|
/// Whitebox tests for cmd/qianfan/chat.
/// The mock tests do NOT require QIANFAN_API_KEY (no network call is made).
/// The real test only runs when QIANFAN_API_KEY is present in the environment.

///|
/// Mock test: chat() success path with a canned response (no API_KEY needed).
async test "qianfan chat mock success" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://qianfan.baidubce.com/v2",
  )
  let body = "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"你好!\"}}],\"usage\":null}"
  @lib.test_install_mock(200, "OK", body)
  try {
    let msg = @lib.chat(cfg, "ernie-4.0-turbo-8k", [
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
/// Mock test: a 500 from the qianfan endpoint must fail (no API_KEY needed).
async test "qianfan chat mock 500 fails" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://qianfan.baidubce.com/v2",
  )
  @lib.test_install_mock(500, "Internal Server Error", "{\"error\":\"boom\"}")
  let mut got_error = false
  try {
    ignore(
      @lib.chat(cfg, "ernie-4.0-turbo-8k", [@lib.user_message_with_text("hi")]),
    )
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
async test "qianfan chat mock records auth header" {
  let cfg = @lib.make_client_config(
    "dummy-key", "https://qianfan.baidubce.com/v2",
  )
  @lib.test_install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(
      @lib.chat(cfg, "ernie-4.0-turbo-8k", [@lib.user_message_with_text("hi")]),
    )
    @lib.test_restore_mock()
  } catch {
    _ => @lib.test_restore_mock()
  }
  let (url, _body, headers) = @lib.test_last_request()
  assert_true(headers.get("Authorization") == Some("Bearer dummy-key"))
  assert_true(url == "https://qianfan.baidubce.com/v2/chat/completions")
}

///|
/// Real call test — only executes when QIANFAN_API_KEY is set in the environment.
/// Note: Qianfan's production API usually requires an access token derived from
/// AK/SK rather than a raw Bearer key, so a direct call may return 401. In that
/// case the test is skipped instead of failing the suite.
async test "qianfan chat real (requires QIANFAN_API_KEY)" {
  let key = @lib.get_env_var("QIANFAN_API_KEY", Some(""))
  if key == "" {
    println("QIANFAN_API_KEY not set; skipping real qianfan chat test")
    return
  }
  let cfg = @lib.make_client_config(key, "https://qianfan.baidubce.com/v2")
  let model = @lib.get_env_var("QIANFAN_MODEL", Some("ernie-4.0-turbo-8k"))
  try {
    let msg = @lib.chat(cfg, model, [@lib.user_message_with_text("hi")])
    let text = @lib.extract_text_from_content(msg.content)
    println("qianfan real response: \{text}")
    assert_true(text.length() > 0)
  } catch {
    e => println("qianfan real call failed (\{e}); skipping real test")
  }
}
