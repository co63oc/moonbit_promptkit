# MoonBit PromptKit — 申报书

## 基本信息
- **项目名称**：MoonBit PromptKit
- **项目仓库**：https://github.com/co63oc/moonbit_promptkit
- **项目方向**：MoonBit 生态系统 — AI/LLM 基础库
- **项目类型**：原创项目
- **开源协议**：Apache-2.0

## 项目简介
MoonBit 实现的 AI 大模型 SDK，基于 OpenAI 兼容接口，统一封装了阿里云百炼、腾讯混元、Moonshot AI、百度千帆、OpenRouter 等主流平台的调用能力。

## 应用场景
为 MoonBit 生态提供生产可用的 LLM 接入能力，支撑 AI 应用开发、智能 Agent、RAG 检索增强生成、多模态内容处理等场景。开发者通过统一 API 即可调用多家模型服务。

## 核心功能
- 统一 OpenAI 兼容客户端（`lib/client.mbt`），支持流式/非流式调用
- 覆盖 5 个 AI 平台，百炼平台包含 30+ 功能模块
- 支持文本生成、多轮对话、深度思考、函数调用、联网搜索

## 实现计划
已完成 SDK 核心框架、5 个平台适配和 46 个可运行示例。后续将继续丰富平台功能覆盖，优化文档与 CI 流程。

## 预期交付物
- MoonBit PromptKit SDK（已发布 mooncakes.io，v0.1.2）
- 多平台调用示例程序（46 个可运行入口）
- 完整 CI/CD 流程与平台文档
