///|
/// Image generation example - using WanXiang model
///

///|
let config : @lib.ClientConfig = @lib.create_client_config(
  "MOONBIT_API_KEY", "MOONBIT_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1",
)

///|
async fn main {
  println("=== Bailian Text-to-Image Test ===")

  let prompt = "A cute orange cat sitting on a windowsill, sunshine streaming in from outside, warm atmosphere, photography style"
  println("\nPrompt: " + prompt)
  println("\nGenerating image, please wait...")

  try {
    let result = @lib.generate_image(config, prompt)
    println("\nImage generation complete!")
    println("Task ID: " + result[0])
    println("Status: " + result[1])
  } catch {
    _ => println("Image generation failed: Error")
  }
}
