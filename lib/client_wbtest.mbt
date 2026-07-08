///|
/// Whitebox tests for the HTTP transport layer.
/// These exercise error handling, streaming, auth, and request parameter mapping
/// without making real network calls, by enabling the package's mock HTTP state.
/// The `install_mock` / `restore_mock` helpers are provided by `client.mbt`.

///|
fn test_config() -> ClientConfig {
  ClientConfig::{
    api_key: "test-key",
    base_url: "https://api.example.com/v1",
    mock_body: None,
  }
}

///|
/// Read a field from a JSON object as an Option[Json].
fn body_field(body : Json, key : String) -> Json? {
  match body {
    Json::Object(obj) => obj.get(key)
    _ => None
  }
}

///|
async test "generate success parses choices and usage" {
  let cfg = test_config()
  let body = "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"Hi\"}}],\"usage\":{\"prompt_tokens\":10,\"completion_tokens\":5,\"total_tokens\":15}}"
  install_mock(200, "OK", body)
  try {
    let resp = chat_full(cfg, "gpt-4", [user_message_with_text("hello")])
    assert_eq(get_total_tokens(resp), 15)
    assert_eq(get_prompt_tokens(resp), 10)
    assert_eq(get_completion_tokens(resp), 5)
    restore_mock()
  } catch {
    e => {
      restore_mock()
      raise e
    }
  }
}

///|
async test "chat success extracts assistant content" {
  let cfg = test_config()
  let body = "{\"choices\":[{\"message\":{\"role\":\"assistant\",\"content\":\"Hi\"}}],\"usage\":null}"
  install_mock(200, "OK", body)
  try {
    let msg = chat(cfg, "gpt-4", [user_message_with_text("hi")])
    match msg.content {
      Json::String(s) => assert_eq(s, "Hi")
      _ => fail("expected string content")
    }
    restore_mock()
  } catch {
    e => {
      restore_mock()
      raise e
    }
  }
}

///|
async test "generate 401 unauthorized fails" {
  let cfg = test_config()
  install_mock(401, "Unauthorized", "{\"error\":\"no key\"}")
  let mut got_error = false
  try {
    ignore(chat(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => {
      got_error = true
      restore_mock()
    }
  }
  assert_true(got_error)
}

///|
async test "generate 500 server error fails" {
  let cfg = test_config()
  install_mock(500, "Internal Server Error", "{\"error\":\"boom\"}")
  let mut got_error = false
  try {
    ignore(chat(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => {
      got_error = true
      restore_mock()
    }
  }
  assert_true(got_error)
}

///|
async test "chat_stream delivers sse body to callback" {
  let cfg = test_config()
  let sse = "data: {\"choices\":[{\"delta\":{\"content\":\"Hello\"}}]}\n\ndata: [DONE]\n"
  let chunks : Array[String] = []
  install_mock(200, "OK", sse)
  try {
    let result = chat_stream(cfg, "gpt-4", [user_message_with_text("hi")], fn(
      s,
    ) {
      chunks.push(s)
    })
    assert_eq(chunks.join(""), sse)
    assert_eq(result, sse)
    restore_mock()
  } catch {
    e => {
      restore_mock()
      raise e
    }
  }
}

///|
async test "chat_stream_thinking parses reasoning and answer" {
  let cfg = test_config()
  let sse = "data: {\"choices\":[{\"delta\":{\"reasoning_content\":\"think\",\"content\":\"\"}}]}\n\ndata: {\"choices\":[{\"delta\":{\"content\":\"ans\"}}]}\n\ndata: [DONE]\n"
  let rchunks : Array[String] = []
  let achunks : Array[String] = []
  install_mock(200, "OK", sse)
  try {
    let r = chat_stream_thinking(
      cfg,
      "gpt-4",
      [user_message_with_text("hi")],
      fn(s) { rchunks.push(s) },
      fn(s) { achunks.push(s) },
    )
    assert_eq(r.reasoning, "think")
    assert_eq(r.answer, "ans")
    assert_eq(rchunks.join(""), "think")
    assert_eq(achunks.join(""), "ans")
    restore_mock()
  } catch {
    e => {
      restore_mock()
      raise e
    }
  }
}

///|
async test "missing auth sends empty bearer token" {
  let cfg = ClientConfig::{
    api_key: "",
    base_url: "https://api.example.com/v1",
    mock_body: None,
  }
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(chat(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  assert_true(mock_state.req_headers.get("Authorization") == Some("Bearer "))
  assert_true(mock_state.url == "https://api.example.com/v1/chat/completions")
}

///|
async test "present auth sends bearer token" {
  let cfg = test_config()
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(chat(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  assert_true(
    mock_state.req_headers.get("Authorization") == Some("Bearer test-key"),
  )
}

///|
async test "chat_with_search maps enable_search" {
  let cfg = test_config()
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(chat_with_search(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  let s = mock_state.req_body.stringify()
  assert_true(s.contains("\"enable_search\":true"))
  assert_true(s.contains("\"model\":\"gpt-4\""))
  assert_true(mock_state.url == "https://api.example.com/v1/chat/completions")
}

///|
async test "chat_with_tools maps tools and disables thinking" {
  let cfg = test_config()
  let tools = Json::array([Json::object({ "type": Json::string("function") })])
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(chat_with_tools(cfg, "gpt-4", [user_message_with_text("hi")], tools))
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  assert_true(body_field(mock_state.req_body, "tools") is Some(_))
  assert_true(
    mock_state.req_body.stringify().contains("\"enable_thinking\":false"),
  )
}

///|
async test "chat_thinking maps enable_thinking" {
  let cfg = test_config()
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(chat_thinking(cfg, "gpt-4", [user_message_with_text("hi")]))
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  assert_true(
    mock_state.req_body.stringify().contains("\"enable_thinking\":true"),
  )
}

///|
async test "chat_with_params maps generation parameters" {
  let cfg = test_config()
  install_mock(200, "OK", "{\"choices\":[]}")
  try {
    ignore(
      chat_with_params(
        cfg,
        "gpt-4",
        [user_message_with_text("hi")],
        Some(0.5),
        None,
        Some(100),
        None,
      ),
    )
    restore_mock()
  } catch {
    _ => restore_mock()
  }
  let s = mock_state.req_body.stringify()
  assert_true(s.contains("\"temperature\":0.5"))
  assert_true(s.contains("\"max_tokens\":100"))
}

///|
test "to_batch_config maps base url" {
  let cfg = test_config()
  let bc = to_batch_config(cfg)
  assert_eq(bc.base_url, batch_chat_base_url)
  assert_eq(bc.api_key, "test-key")
}

///|
test "build_chat_batch_input json mapping" {
  let item = build_chat_batch_input("req-1", "gpt-4", [
    user_message_with_text("hi"),
  ])
  let s = item.to_json().stringify()
  assert_true(s.contains("\"custom_id\":\"req-1\""))
  assert_true(s.contains("\"method\":\"POST\""))
  assert_true(s.contains("\"url\":\"/v1/chat/completions\""))
  assert_true(body_field(item.to_json(), "body") is Some(_))
}

///|
test "build_batch_input_jsonl roundtrip" {
  let item = build_chat_batch_input("req-1", "gpt-4", [
    user_message_with_text("hi"),
  ])
  let jsonl = build_batch_input_jsonl([item])
  let parsed = parse_batch_output(jsonl)
  assert_eq(parsed.length(), 1)
  assert_eq(parsed[0].custom_id, "req-1")
}

///|
test "parse_batch_output skips invalid lines" {
  let item = build_chat_batch_input("r", "gpt-4", [user_message_with_text("x")])
  let jsonl = "not-valid-json\n" + build_batch_input_jsonl([item])
  let parsed = parse_batch_output(jsonl)
  assert_eq(parsed.length(), 1)
}
