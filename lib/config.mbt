///|
/// Configuration utilities for Moonbit Promptkit SDK
///

///|
let env : Map[String, String] = @sys.get_env_vars()

///|
pub fn get_env_var(name : String, default : String?) -> String {
  match env.get(name) {
    Some(value) => value
    None =>
      match default {
        Some(value) => value
        None => {
          println("Please set \{name} environment variable")
          panic()
        }
      }
  }
}

///|
pub struct ClientConfig {
  api_key : String
  base_url : String
  mock_body : String?
}

///|
/// Build a ClientConfig directly from an api_key, base_url, and optional mock_body.
/// When `mock_body` is provided and `api_key` is empty, the SDK automatically
/// returns the mock response instead of making a real HTTP call.
/// Mainly useful for tests or when configuration is provided by other means
/// than environment variables.
pub fn make_client_config(
  api_key : String,
  base_url : String,
  mock_body? : String? = None,
) -> ClientConfig {
  ClientConfig::{ api_key, base_url, mock_body }
}

///|
pub fn create_client_config(
  api_key_env : String,
  base_url_env : String,
  default_base_url : String,
) -> ClientConfig {
  ClientConfig::{
    api_key: get_env_var(api_key_env, None),
    base_url: get_env_var(base_url_env, Some(default_base_url)),
    mock_body: None,
  }
}

///|
/// Default Batch Chat base URL (China Mainland)
pub let batch_chat_base_url : String = "https://batch.dashscope.aliyuncs.com/compatible-mode/v1"

///|
/// Create a batch chat client config from an existing config
/// Uses batch.dashscope.aliyuncs.com endpoint for 50% cost reduction
pub fn to_batch_config(config : ClientConfig) -> ClientConfig {
  ClientConfig::{
    api_key: config.api_key,
    base_url: batch_chat_base_url,
    mock_body: config.mock_body,
  }
}

///|
/// Create a batch chat client config with env vars
pub fn create_batch_client_config(
  api_key_env : String,
  base_url_env : String,
) -> ClientConfig {
  ClientConfig::{
    api_key: get_env_var(api_key_env, None),
    base_url: get_env_var(base_url_env, Some(batch_chat_base_url)),
    mock_body: None,
  }
}
