///|
/// File Search API (文件搜索)
/// Search documents in uploaded files
/// Endpoint: /responses (Responses API)
///

///|
/// Search files with a query
pub async fn search_files(
  config : @lib.ClientConfig,
  model : String,
  query : String,
  file_ids : Array[String],
) -> @lib.ResponsesResponse {
  let messages = [
    @lib.response_message("user", [@lib.input_text(query)])
  ]
  let tools = if file_ids.length() > 0 {
    [@lib.file_search_tool_with_ids(file_ids)]
  } else {
    [@lib.file_search_tool()]
  }
  @lib.responses_create(config, model, messages, Some(tools))
}

///|
/// Search files with options
pub async fn search_files_with_options(
  config : @lib.ClientConfig,
  model : String,
  query : String,
  file_ids : Array[String],
) -> @lib.ResponsesResponse {
  search_files(config, model, query, file_ids)
}

///|
/// Extract file search results from response
pub fn extract_file_search_results(response : @lib.ResponsesResponse) -> Array[Json] {
  let results : Array[Json] = []
  for item in response.output {
    match item.output {
      Some(output_str) => {
        try {
          let parsed = @json.parse(output_str)
          match parsed {
            Json::Array(arr) => for x in arr { results.push(x) }
            _ => ignore(())
          }
        } catch {
          _ => ignore(())
        }
      }
      None => ignore(())
    }
  }
  results
}
