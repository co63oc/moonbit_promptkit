# 百度千帆 (Qianfan)

基于百度千帆平台的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export QIANFAN_API_KEY=***
export QIANFAN_MODEL=ernie-4.5-turbo-32k  # 可选，默认 ernie-4.5-turbo-32k
```

API Key 获取地址：https://console.bce.baidu.com/qianfan/ais/console/applicationList/application

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 文本生成（简单对话、系统提示词、多轮对话） | `moon run cmd/qianfan/chat` |

## 支持的模型

常用模型（具体可用模型请通过 API 查询）：
- `ernie-4.5-turbo-32k`（推荐）
- `ernie-4.5-turbo-128k`

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat Completions](https://cloud.baidu.com/doc/qianfan-api/s/3m7of64lb) |
| 鉴权说明 | API Key 获取与鉴权方式 | [鉴权说明](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/4lilb9vpf) |
| API 概览 | 千帆 ModelBuilder API 总览 | [API 概览](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/Fm2vrveyu) |

## 快速开始

```bash
# 配置环境变量
export QIANFAN_API_KEY=***
export QIANFAN_MODEL=ernie-4.5-turbo-32k

# 运行示例
moon run cmd/qianfan/chat
```
