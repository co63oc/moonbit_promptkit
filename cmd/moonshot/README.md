# Kimi (Moonshot AI)

基于 Kimi (Moonshot AI) 的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export MOONSHOT_API_KEY=***
export MOONSHOT_BASE_URL=https://api.moonshot.cn/v1  # 可选，默认国内地址
```

API Key 获取地址：https://platform.moonshot.cn/console/api-keys

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/moonshot/chat` |
| `stream` | 流式输出 | `moon run cmd/moonshot/stream` |

## 支持的模型

常用模型：
- `kimi-latest` - Kimi 最新版本
- `moonshot-v1-8k` - 8k 上下文
- `moonshot-v1-32k` - 32k 上下文
- `moonshot-v1-128k` - 128k 上下文

API 文档：https://platform.moonshot.cn/docs

## 快速开始

```bash
# 配置环境变量
export MOONSHOT_API_KEY=***

# 运行示例
moon run cmd/moonshot/chat
```

## 特性

- 支持超长上下文（最高 128k）
- 中文理解能力强
- OpenAI 兼容接口
- 支持流式输出
