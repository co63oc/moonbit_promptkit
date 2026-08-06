# 讯飞星火

基于讯飞星火认知大模型的调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export SPARK_API_KEY=***
export SPARK_BASE_URL=https://spark-api-open.xf-yun.com/v1  # 可选，默认值
```

API Key（APIPassword）获取地址：https://console.xfyun.cn/services/bm35

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/spark/chat` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `generalv3.5` | Spark Pro-128K |
| `generalv3` | Spark Pro |
| `general` | Spark Lite（免费） |
| `4.0Ultra` | Spark 4.0 Ultra |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://www.xfyun.cn/doc/spark/HTTP%E8%B0%83%E7%94%A8%E6%96%87%E6%A1%A3.html) |
| 深度推理 | Spark X1/X2 推理模型 | [Thinking](https://www.xfyun.cn/doc/spark/X1http.html) |

## 快速开始

```bash
export SPARK_API_KEY=***
moon run cmd/spark/chat
```

## 特性

- Spark Lite 免费使用
- 中文语音生态完善
- 支持深度推理模式
- OpenAI 兼容接口
- 教育、办公场景优化
