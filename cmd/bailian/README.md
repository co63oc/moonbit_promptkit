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
| `params` | 自定义参数 (temperature/top_p/max_tokens/seed等) | `moon run cmd/bailian/params` |
| `multi_chat` | 多轮对话 | `moon run cmd/bailian/multi_chat` |
| `partial` | 前缀续写 | `moon run cmd/bailian/partial` |
| `search` | 联网搜索 | `moon run cmd/bailian/search` |
| `tool_call` | 工具调用 | `moon run cmd/bailian/tool_call` |
| `image_gen` | 图像生成 | `moon run cmd/bailian/image_gen` |
| `models` | 模型列表 | `moon run cmd/bailian/models` |
| `batch` | 批量推理 | `moon run cmd/bailian/batch` |
| `context_cache` | 上下文缓存 | `moon run cmd/bailian/context_cache` |
| `vl` | 图像与视频理解 | `moon run cmd/bailian/vl` |
| `translate` | Qwen-MT 机器翻译 | `moon run cmd/bailian/translate` |
| `role_play` | 角色扮演（通义星尘） | `moon run cmd/bailian/role_play` |
| `qwen_doc_turbo` | 文档数据挖掘 | `moon run cmd/bailian/qwen_doc_turbo` |
| `qwen_math` | 数学推理（Qwen-Math） | `moon run cmd/bailian/qwen_math` |
| `gui_automation` | UI交互自动化（GUI-Plus） | `moon run cmd/bailian/gui_automation` |
| `dialogue_analysis` | 对话分析（通义晓蜜） | `moon run cmd/bailian/dialogue_analysis` |
| `audio_captioner` | 音频理解（Qwen3-Omni-Captioner） | `moon run cmd/bailian/audio_captioner` |
| `deep_research` | 深度研究（Qwen-Deep-Research） | `moon run cmd/bailian/deep_research` |

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
