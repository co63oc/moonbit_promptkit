# DeepSeek

基于 DeepSeek 的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export DEEPSEEK_API_KEY=***
export DEEPSEEK_BASE_URL=https://api.deepseek.com  # 可选，默认值
```

API Key 获取地址：https://platform.deepseek.com/api_keys

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/deepseek/chat` |
| `thinking` | 深度思考（R1） | `moon run cmd/deepseek/thinking` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `deepseek-chat` | DeepSeek-V3.2 非思考模式 |
| `deepseek-reasoner` | DeepSeek-V3.2 思考模式（R1） |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://api-docs.deepseek.com/zh-cn/api/create-chat-completion) |
| 深度思考 | Reasoning Model 使用指南 | [Thinking](https://api-docs.deepseek.com/zh-cn/guides/reasoning_model) |
| FIM 补全 | 代码补全接口 | [FIM](https://api-docs.deepseek.com/zh-cn/guides/coder) |

## 快速开始

```bash
export DEEPSEEK_API_KEY=***
moon run cmd/deepseek/chat
```

## 特性

- 性价比极高（DeepSeek-V3 价格远低于同级别模型）
- 强大的数学和编程能力
- 支持深度思考模式（DeepSeek-R1）
- 支持 FIM 代码补全
- OpenAI 兼容接口
