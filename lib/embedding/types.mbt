///|
/// Embedding types

///|
/// Text embedding request input
pub enum TextEmbeddingInput {
  Single(String)
  Multiple(Array[String])
} derive(Debug, ToJson)

///|
/// Text embedding request (OpenAI compatible)
pub struct TextEmbeddingRequest {
  model : String
  input : TextEmbeddingInput
  dimensions : Int?
} derive(Debug, ToJson)

///|
/// Single embedding data
pub struct EmbeddingData {
  index : Int
  embedding : Array[Double]
  object : String
} derive(Debug, ToJson, @json.FromJson)

///|
/// Embedding usage
pub struct EmbeddingUsage {
  prompt_tokens : Int?
  total_tokens : Int
} derive(Debug, ToJson, @json.FromJson)

///|
/// Text embedding response (OpenAI compatible)
pub struct TextEmbeddingResponse {
  object : String
  data : Array[EmbeddingData]
  model : String
  usage : EmbeddingUsage
} derive(Debug, ToJson, @json.FromJson)

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
/// Rerank result item
pub struct RerankResultItem {
  index : Int
  relevance_score : Double
  document : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Rerank response
pub struct RerankResponse {
  results : Array[RerankResultItem]
  model : String
  usage : Json?
} derive(Debug, ToJson, @json.FromJson)

///|
/// Default rerank model
pub let default_rerank_model : String = "gte-rerank"
