# 腾讯混元 (Tokenhub)

基于腾讯混元平台的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export HUNYUAN_API_KEY=***
export HUNYUAN_BASE_URL=https://tokenhub.tencentmaas.com/v1
```

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/hunyuan/chat` |

## 支持的模型

- `hy3-preview` - 混元 3.0 预览版

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat Completions](https://cloud.tencent.com/document/product/1729/111007) |
| API 概览 | 腾讯混元大模型 API 总览 | [API 概览](https://cloud.tencent.com/document/product/1729/105701) |

## 快速开始

```bash
# 配置环境变量
export HUNYUAN_API_KEY=***
export HUNYUAN_BASE_URL=https://tokenhub.tencentmaas.com/v1

# 运行示例
moon run cmd/hunyuan/chat
```
