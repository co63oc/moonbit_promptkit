# OpenRouter

基于 OpenRouter 的 AI 大模型调用，支持数百种模型，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export OPENROUTER_API_KEY=***
export OPENROUTER_BASE_URL=https://openrouter.ai/api/v1  # 可选，默认值
```

API Key 获取地址：https://openrouter.ai/keys

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话（使用免费模型） | `moon run cmd/openrouter/chat` |
| `stream` | 流式输出 | `moon run cmd/openrouter/stream` |

## 支持的模型

OpenRouter 支持数百种模型，包括免费和付费模型：

**免费模型** (在模型名后加 `:free`，具体以 https://openrouter.ai/models 查询为准)：
- `google/gemma-4-31b-it:free`（Google Gemma 4 31B 参数，稳定可用）
- `openai/gpt-oss-20b:free`（OpenAI GPT-OSS 20B 参数）
- `meta-llama/llama-3.3-70b-instruct:free`（Meta Llama 3.3 70B，可能触发限流）

**付费模型**:
- OpenAI: `openai/gpt-4`, `openai/gpt-3.5-turbo`
- Anthropic: `anthropic/claude-3-opus`, `anthropic/claude-3-sonnet`
- Google: `google/gemini-pro`, `google/palm-2`
- 等等...

完整模型列表：https://openrouter.ai/models

## 快速开始

```bash
# 配置环境变量
export OPENROUTER_API_KEY=***

# 运行示例
moon run cmd/openrouter/chat
```

## 特性

- 统一接口访问数百种 AI 模型
- 自动故障转移和负载均衡
- 选择最具成本效益的模型
- 支持流式输出
