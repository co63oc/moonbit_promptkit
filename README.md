# co63oc/moonbit_promptkit

MoonBit 实现的 AI 大模型 SDK 示例，支持多个平台。

## 支持的 API 平台

| 平台 | 说明 | 文档 |
|------|------|------|
| **OpenRouter** | 统一接口访问数百种模型 | [cmd/openrouter/README.md](cmd/openrouter/README.md) |
| **Moonshot AI (Kimi)** | OpenAI 兼容接口 | [cmd/moonshot/README.md](cmd/moonshot/README.md) |
| **阿里云百炼 (Bailian)** | OpenAI 兼容接口 | [cmd/bailian/README.md](cmd/bailian/README.md) |
| **腾讯混元 (Tokenhub)** | OpenAI 兼容接口 | [cmd/hunyuan/README.md](cmd/hunyuan/README.md) |
| **百度千帆 (Qianfan)** | OpenAI 兼容接口 | [cmd/qianfan/README.md](cmd/qianfan/README.md) |

## 项目结构

```
cmd/
├── openrouter/  # OpenRouter 示例 
├── moonshot/    # Moonshot AI (Kimi) 示例
├── hunyuan/     # 腾讯混元示例
├── qianfan/     # 百度千帆示例
└── bailian/     # 阿里云百炼示例
```

## 通用说明

所有平台均支持 OpenAI 兼容接口，配置对应的 API Key 和 Base URL 即可使用。

如有其他兼容 OpenAI 的接口，可修改对应平台的环境变量为相应值。

## 文档生成

本项目使用 `moon doc` 生成文档，由于当前版本的 `moon doc` 仍需要 `moon.mod.json` 才能运行，因此仓库中同时保留了新格式的 `moon.mod` 和旧格式的 `moon.mod.json`（二者内容保持一致）。
