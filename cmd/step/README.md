# 阶跃星辰 Step

基于阶跃星辰 Step 系列模型的调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export STEP_API_KEY=***
export STEP_BASE_URL=https://api.stepfun.com/v1  # 可选，默认值
```

API Key 获取地址：https://platform.stepfun.com/interface-key

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/step/chat` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `step-2-16k` | Step-2（16K 上下文） |
| `step-2-32k` | Step-2（32K 上下文） |
| `step-1-8k` | Step-1（8K 上下文） |
| `step-1-32k` | Step-1（32K 上下文） |
| `step-1-128k` | Step-1（128K 上下文） |
| `step-1-flash` | Step-1 Flash（快速版） |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://platform.stepfun.com/docs/reference/overview) |

## 快速开始

```bash
export STEP_API_KEY=***
moon run cmd/step/chat
```

## 特性

- 强大的中文理解能力
- 支持多种上下文长度选择
- 快速响应
- OpenAI 兼容接口
- 适合中文对话场景
