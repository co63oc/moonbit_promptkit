# MiniMax

基于 MiniMax 的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export MINIMAX_API_KEY=***
export MINIMAX_BASE_URL=https://api.minimax.chat/v1  # 可选，默认值
```

API Key 获取地址：https://www.minimaxi.com/user-center/basic-information/interface-key

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/minimax/chat` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `MiniMax-M1` | MiniMax 旗舰模型 |
| `abab6.5s-chat` | Abab 6.5S |
| `abab6.5-chat` | Abab 6.5 |
| `abab5.5-chat` | Abab 5.5 |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://www.minimaxi.com/document/guides/chat-model/pro) |

## 快速开始

```bash
export MINIMAX_API_KEY=***
moon run cmd/minimax/chat
```

## 特性

- 擅长长文本处理和角色扮演
- 支持超长上下文
- 创意写作能力强
- OpenAI 兼容接口
- 海螺 AI 背后的模型
