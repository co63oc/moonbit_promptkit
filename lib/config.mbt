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
  }
}
