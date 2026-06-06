# 百度千帆 (Qianfan)

基于百度千帆平台的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export QIANFAN_API_KEY=***
export QIANFAN_MODEL=ernie-4.0-turbo-8k  # 可选，默认 ernie-4.0-turbo-8k
```

API Key 获取地址：https://console.bce.baidu.com/qianfan/ais/console/applicationList/application

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 文本生成（简单对话、系统提示词、多轮对话） | `moon run cmd/qianfan/chat` |

## 支持的模型

常用模型：
- `ernie-4.0-turbo-8k`
- `ernie-4.0-8k`
- `ernie-3.5-8k`
- `ernie-speed-8k`

API 文档：https://cloud.baidu.com/doc/qianfan-api/s/3m7of64lb

## 快速开始

```bash
# 配置环境变量
export QIANFAN_API_KEY=***
export QIANFAN_MODEL=ernie-4.0-turbo-8k

# 运行示例
moon run cmd/qianfan/chat
```
