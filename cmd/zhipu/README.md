# 智谱AI GLM

基于智谱AI GLM 的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export ZHIPU_API_KEY=***
export ZHIPU_BASE_URL=https://open.bigmodel.cn/api/paas/v4  # 可选，默认值
```

API Key 获取地址：https://open.bigmodel.cn/usercenter/apikeys

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/zhipu/chat` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `glm-4` | GLM-4 标准版 |
| `glm-4v` | GLM-4 多模态版（支持图像理解） |
| `glm-3-turbo` | GLM-3 Turbo 快速版 |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://open.bigmodel.cn/dev/api/normal-model/glm-4) |
| 多模态 | 图像理解接口 | [Vision](https://open.bigmodel.cn/dev/api/normal-model/glm-4v) |

## 快速开始

```bash
export ZHIPU_API_KEY=***
moon run cmd/zhipu/chat
```

## 特性

- 强大的中文理解能力
- 支持超长上下文（最高 128K）
- 多模态理解（GLM-4V）
- 工具调用能力
- OpenAI 兼容接口
