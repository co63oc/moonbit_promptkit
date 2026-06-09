///|
/// Types for Qwen-MT translation models
///

///| Translation term for terminology intervention (术语干预)
///| Maps a source term to its pre-translated target
pub struct TranslationTerm {
  source : String
  target : String
} derive(Debug, ToJson, @json.FromJson)

///| Translation options for Qwen-MT models
///| source_lang/target_lang: use English language names (e.g. "Chinese", "English", "Japanese")
///| Set source_lang to "auto" for automatic detection
pub struct TranslationOptions {
  source_lang : String
  target_lang : String
  terms : Array[TranslationTerm]?
  domain : String?
} derive(Debug, ToJson, @json.FromJson)

///| Translate request for Qwen-MT models
///| translation_options is a top-level field in the API request body
///| This struct is separate from lib.Request to avoid polluting non-translation APIs
pub struct TranslateRequest {
  model : String
  messages : Array[@lib.Message]
  stream : Bool?
  stream_options : @lib.StreamOptions?
  translation_options : TranslationOptions
} derive(ToJson)

///| Create a TranslationTerm for terminology intervention (术语干预)
pub fn translation_term(source : String, target : String) -> TranslationTerm {
  TranslationTerm::{ source, target }
}
