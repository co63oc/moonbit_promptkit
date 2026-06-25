///|
/// Text Embedding APIs
/// API Reference: https://help.aliyun.com/zh/model-studio/embedding
/// Endpoint: /embeddings (OpenAI compatible)

///|
/// Create text embedding for single text
/// Returns embedding vector as Array[Double]
pub async fn create_embedding(
  config : @lib.ClientConfig,
  text : String,
) -> Array[Double] {
  let resp = create_embeddings_impl(
    config,
    [text],
    default_text_embedding_model,
    None,
  )
  if resp.data.length() == 0 {
    fail("No embedding data in response")
  }
  resp.data[0].embedding
}

///|
/// Create text embedding with model
pub async fn create_embedding_with_model(
  config : @lib.ClientConfig,
  text : String,
  model : String,
) -> Array[Double] {
  let resp = create_embeddings_impl(config, [text], model, None)
  if resp.data.length() == 0 {
    fail("No embedding data in response")
  }
  resp.data[0].embedding
}

///|
/// Create embeddings for multiple texts
/// Returns array of embedding vectors
pub async fn create_embeddings(
  config : @lib.ClientConfig,
  texts : Array[String],
) -> Array[Array[Double]] {
  let resp = create_embeddings_impl(
    config,
    texts,
    default_text_embedding_model,
    None,
  )
  resp.data.map(fn(d) { d.embedding })
}

///|
/// Create embeddings with full options
pub async fn create_embeddings_with_options(
  config : @lib.ClientConfig,
  texts : Array[String],
  model? : String,
  dimensions? : Int,
) -> (Array[Array[Double]], Int) {
  let resp = create_embeddings_impl(
    config,
    texts,
    model.unwrap_or(default_text_embedding_model),
    dimensions,
  )
  let embeddings = resp.data.map(fn(d) { d.embedding })
  let total_tokens = resp.usage.total_tokens
  (embeddings, total_tokens)
}

///|
/// Internal: text embedding implementation
async fn create_embeddings_impl(
  config : @lib.ClientConfig,
  texts : Array[String],
  model : String,
  dimensions : Int?,
) -> TextEmbeddingResponse {
  let input = if texts.length() == 1 {
    TextEmbeddingInput::Single(texts[0])
  } else {
    TextEmbeddingInput::Multiple(texts)
  }
  let request = TextEmbeddingRequest::{ model, input, dimensions }

  let url = "\{config.base_url}/embeddings"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Embedding request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  body.json() |> @json.from_json()
}

///|
/// Rerank APIs
/// API Reference: https://help.aliyun.com/zh/model-studio/rerank
/// Endpoint: /rerank (OpenAI compatible)

///|
/// Rerank documents against a query
/// Returns ranked indices and scores
pub async fn rerank(
  config : @lib.ClientConfig,
  query : String,
  documents : Array[String],
) -> Array[(Int, Double)] {
  let resp = rerank_impl(
    config,
    query,
    documents,
    default_rerank_model,
    None,
    None,
  )
  resp.results.map(fn(r) { (r.index, r.relevance_score) })
}

///|
/// Rerank with full options
pub async fn rerank_with_options(
  config : @lib.ClientConfig,
  query : String,
  documents : Array[String],
  model? : String,
  top_n? : Int,
  return_documents? : Bool,
) -> (Array[(Int, Double)], Array[String?]) {
  let resp = rerank_impl(
    config,
    query,
    documents,
    model.unwrap_or(default_rerank_model),
    top_n,
    return_documents,
  )
  let scores = resp.results.map(fn(r) { (r.index, r.relevance_score) })
  let docs = resp.results.map(fn(r) {
    match r.document {
      Some(Json::String(s)) => Some(s)
      _ => None
    }
  })
  (scores, docs)
}

///|
/// Internal: rerank implementation
async fn rerank_impl(
  config : @lib.ClientConfig,
  query : String,
  documents : Array[String],
  model : String,
  top_n : Int?,
  return_documents : Bool?,
) -> RerankResponse {
  let request = RerankRequest::{
    model,
    query,
    documents,
    top_n,
    return_documents,
  }

  // Rerank uses compatible-api/v1, not compatible-mode/v1
  let base_url = config.base_url.replace(
    old="compatible-mode",
    new="compatible-api",
  )
  let url = "\{base_url}/reranks"
  let (response, body) = @http.post(url, request.to_json(), headers={
    "Authorization": "Bearer \{config.api_key}",
    "Content-Type": "application/json",
  })
  guard response.code is (200..=299) else {
    let error_text = body.text()
    fail(
      "Rerank request failed: \{response.code} \{response.reason}\n\{error_text}",
    )
  }
  body.json() |> @json.from_json()
}
