# 阿里云百炼 (Bailian)

基于阿里云百炼平台的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export BAILIAN_API_KEY=***
export BAILIAN_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
export BAILIAN_MODEL=qwen3.7-plus
```

API Key 获取地址：https://bailian.console.aliyun.com/cn-beijing?tab=model#/api-key

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/bailian/chat` |
| `stream` | 流式输出 | `moon run cmd/bailian/stream` |
| `thinking` | 深度思考 | `moon run cmd/bailian/thinking` |
| `multi_chat` | 多轮对话 | `moon run cmd/bailian/multi_chat` |
| `partial` | 前缀续写 | `moon run cmd/bailian/partial` |
| `search` | 联网搜索 | `moon run cmd/bailian/search` |
| `tool_call` | 工具调用 | `moon run cmd/bailian/tool_call` |
| `image_gen` | 图像生成 | `moon run cmd/bailian/image_gen` |

## 快速开始

```bash
# 配置环境变量
export BAILIAN_API_KEY=***
export BAILIAN_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
export BAILIAN_MODEL=qwen3.7-plus

# 运行简单对话示例
moon run cmd/bailian/chat

# 运行深度思考示例
moon run cmd/bailian/thinking
```
