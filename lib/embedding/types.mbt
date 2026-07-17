///|
/// Embedding types

///|
/// Text embedding request input
pub enum TextEmbeddingInput {
  Single(String)
  Multiple(Array[String])
} derive(Debug, ToJson)

///|
pub extend TextEmbeddingInput with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextEmbeddingInput with ToJson::{to_json}

///|
/// Text embedding request (OpenAI compatible)
pub struct TextEmbeddingRequest {
  model : String
  input : TextEmbeddingInput
  dimensions : Int?
} derive(Debug, ToJson)

///|
pub extend TextEmbeddingRequest with ToJson::{to_json}

///|
pub extend TextEmbeddingRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Single embedding data
pub struct EmbeddingData {
  index : Int
  embedding : Array[Double]
  object : String
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend EmbeddingData with ToJson::{to_json}

///|
pub extend EmbeddingData with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend EmbeddingData with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Embedding usage
pub struct EmbeddingUsage {
  prompt_tokens : Int?
  total_tokens : Int
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend EmbeddingUsage with ToJson::{to_json}

///|
pub extend EmbeddingUsage with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EmbeddingUsage with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Text embedding response (OpenAI compatible)
pub struct TextEmbeddingResponse {
  object : String
  data : Array[EmbeddingData]
  model : String
  usage : EmbeddingUsage
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend TextEmbeddingResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend TextEmbeddingResponse with ToJson::{to_json}

///|
pub extend TextEmbeddingResponse with @moonbitlang/core/json.FromJson::{
  from_json,
}

///|
/// Default text embedding model
pub let default_text_embedding_model : String = "text-embedding-v4"

///|
/// Rerank types

///|
/// Rerank request
pub struct RerankRequest {
  model : String
  query : String
  documents : Array[String]
  top_n : Int?
  return_documents : Bool?
} derive(Debug, ToJson)

///|
pub extend RerankRequest with ToJson::{to_json}

///|
pub extend RerankRequest with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// Rerank result item
pub struct RerankResultItem {
  index : Int
  relevance_score : Double
  document : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend RerankResultItem with @moonbitlang/core/json.FromJson::{from_json}

///|
pub extend RerankResultItem with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RerankResultItem with ToJson::{to_json}

///|
/// Rerank response
pub struct RerankResponse {
  results : Array[RerankResultItem]
  model : String
  usage : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
pub extend RerankResponse with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RerankResponse with ToJson::{to_json}

///|
pub extend RerankResponse with @moonbitlang/core/json.FromJson::{from_json}

///|
/// Default rerank model
pub let default_rerank_model : String = "qwen3-rerank"
