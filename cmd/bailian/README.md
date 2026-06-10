# 阿里云百炼 (Bailian)

基于阿里云百炼平台的 AI 大模型调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export BAILIAN_API_KEY=***
export BAILIAN_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
export BAILIAN_MODEL=qwen3.7-plus
```

API Key 获取地址：https://bailian.console.aliyun.com/cn-beijing?tab=model#/api-key

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/bailian/chat` |
| `stream` | 流式输出 | `moon run cmd/bailian/stream` |
| `thinking` | 深度思考 | `moon run cmd/bailian/thinking` |
| `params` | 自定义参数 (temperature/top_p/max_tokens/seed等) | `moon run cmd/bailian/params` |
| `multi_chat` | 多轮对话 | `moon run cmd/bailian/multi_chat` |
| `partial` | 前缀续写 | `moon run cmd/bailian/partial` |
| `search` | 联网搜索 | `moon run cmd/bailian/search` |
| `tool_call` | 工具调用 | `moon run cmd/bailian/tool_call` |
| `image_gen` | 图像生成 | `moon run cmd/bailian/image_gen` |
| `models` | 模型列表 | `moon run cmd/bailian/models` |
| `batch` | 批量推理 | `moon run cmd/bailian/batch` |
| `context_cache` | 上下文缓存 | `moon run cmd/bailian/context_cache` |
| `vl` | 图像与视频理解 | `moon run cmd/bailian/vl` |
| `translate` | Qwen-MT 机器翻译 | `moon run cmd/bailian/translate` |
| `role_play` | 角色扮演（通义星尘） | `moon run cmd/bailian/role_play` |
| `qwen_doc_turbo` | 文档数据挖掘 | `moon run cmd/bailian/qwen_doc_turbo` |
| `qwen_math` | 数学推理（Qwen-Math） | `moon run cmd/bailian/qwen_math` |
| `gui_automation` | UI交互自动化（GUI-Plus） | `moon run cmd/bailian/gui_automation` |
| `dialogue_analysis` | 对话分析（通义晓蜜） | `moon run cmd/bailian/dialogue_analysis` |
| `audio_captioner` | 音频理解（Qwen3-Omni-Captioner） | `moon run cmd/bailian/audio_captioner` |
| `deep_research` | 深度研究（Qwen-Deep-Research） | `moon run cmd/bailian/deep_research` |
| `tts` | 语音合成（CosyVoice/Qwen-TTS/MiniMax） | `moon run cmd/bailian/tts` |

## 已实现接口文档参考

### 文本生成与对话

| 功能 | 说明 | 文档链接 |
|------|------|----------|
| 文本生成 | 单轮文本生成 | [文本生成](https://help.aliyun.com/zh/model-studio/text-generation) |
| 多轮对话 | 多轮对话上下文管理 | [多轮对话](https://help.aliyun.com/zh/model-studio/multi-round-conversation) |
| 流式输出 | SSE 流式响应输出 | [流式输出](https://help.aliyun.com/zh/model-studio/stream) |
| 深度思考 | 深度思考推理模式 | [深度思考](https://help.aliyun.com/zh/model-studio/deep-thinking) |
| 前缀续写 | Partial 模式前缀续写 | [前缀续写](https://help.aliyun.com/zh/model-studio/partial-mode) |
| 上下文缓存 | Prompt 上下文缓存优化 | [上下文缓存](https://help.aliyun.com/zh/model-studio/context-cache) |
| 批量推理 | 异步批量推理任务 | [批量推理](https://help.aliyun.com/zh/model-studio/batch-inference) |
| 函数调用 | Function Calling 工具调用 | [函数调用](https://help.aliyun.com/zh/model-studio/qwen-function-calling) |
| 联网搜索 | Web Search 联网搜索增强 | [联网搜索](https://help.aliyun.com/zh/model-studio/web-search) |
| 长文本 Qwen-Long | 长上下文窗口模型 | [长文本](https://help.aliyun.com/zh/model-studio/long-context-qwen-long) |
| 代码生成 Qwen-Coder | 代码生成与补全 | [代码生成](https://help.aliyun.com/zh/model-studio/qwen-coder) |
| 机器翻译 Qwen-MT | 多语言机器翻译 | [机器翻译](https://help.aliyun.com/zh/model-studio/machine-translation) |
| 角色扮演 | 通义星尘角色对话 | [角色扮演](https://help.aliyun.com/zh/model-studio/role-play) |
| 文档数据挖掘 | Qwen-Doc 文档分析 | [文档数据挖掘](https://help.aliyun.com/zh/model-studio/data-mining-qwen-doc) |
| 深度研究 | Qwen-Deep-Research 深度研究 | [深度研究](https://help.aliyun.com/zh/model-studio/qwen-deep-research) |
| 数学推理 | Qwen-Math 数学推理 | [数学推理](https://help.aliyun.com/zh/model-studio/math-language-model) |
| 对话分析 | 通义晓蜜对话分析 | [对话分析](https://help.aliyun.com/zh/model-studio/dialogue-analysis) |
| GUI 自动化 | GUI-Plus UI交互自动化 | [GUI自动化](https://help.aliyun.com/zh/model-studio/gui-automation) |
| 音频理解 | Qwen3-Omni-Captioner 音频理解 | [音频理解](https://help.aliyun.com/zh/model-studio/qwen3-omni-captioner) |

### 视觉理解

| 功能 | 说明 | 文档链接 |
|------|------|----------|
| 视觉大模型 | 通用图像理解、描述问答 | [vision](https://help.aliyun.com/zh/model-studio/vision) |
| OCR文字识别 | 通用文字识别、表格识别 | [Qwen-VL-OCR](https://help.aliyun.com/zh/model-studio/qwen-vl-ocr) |
| 视觉推理 | 几何推理、空间推理、逻辑推理 | [视觉推理](https://help.aliyun.com/zh/model-studio/visual-reasoning) |

### 图像生成与编辑

| 功能 | 说明 | 文档链接 |
|------|------|----------|
| 文本生成图像 | Wan 2.1 文生图大模型 | [文本生成图像](https://help.aliyun.com/zh/model-studio/text-to-image) |
| 图像编辑（Qwen） | 基于指令的图像编辑 | [Qwen图像编辑](https://help.aliyun.com/zh/model-studio/qwen-image-edit-guide) |
| 图像编辑（Wan） | Wan 图像编辑模型 | [Wan图像编辑](https://help.aliyun.com/zh/model-studio/wan-image-edit) |
| 图像编辑（Wanx） | 通义万相图像编辑 | [Wanx图像编辑](https://help.aliyun.com/zh/model-studio/wanx-image-edit) |
| 风格重绘 | 局部风格迁移与重绘 | [风格重绘](https://help.aliyun.com/zh/model-studio/style-repaint) |
| 背景生成 | 商品图智能背景生成 | [背景生成](https://help.aliyun.com/zh/model-studio/image-background-generation) |
| 图像扩图 | AI智能扩图，Outpainting | [图像扩图](https://help.aliyun.com/zh/model-studio/image-expansion) |
| 虚拟模特 | 服装/鞋靴虚拟模特生成 | [虚拟模特](https://help.aliyun.com/zh/model-studio/virtual-model-generation) |
| 鞋靴模特 | 鞋靴虚拟模特生成 | [鞋靴模特](https://help.aliyun.com/zh/model-studio/shoes-and-boots-model) |
| 创意海报 | 一键生成营销海报 | [创意海报](https://help.aliyun.com/zh/model-studio/creative-poster-generation-overview) |
| 图像擦除补全 | 移除物体、智能补全 | [图像擦除补全](https://help.aliyun.com/zh/model-studio/image-erasure-and-completion) |
| 区域编辑 | Vary-Region 指定区域编辑 | [区域编辑](https://help.aliyun.com/zh/model-studio/vary-region) |
| 草图生成图像 | 线稿/草图转图像 | [草图生成图像](https://help.aliyun.com/zh/model-studio/sketch-to-image) |

### 视频生成

| 功能 | 说明 | 文档链接 |
|------|------|----------|
| 文本生成视频 | Wan 2.1 文生视频大模型 | [文本生成视频](https://help.aliyun.com/zh/model-studio/text-to-video-guide) |
| 图生视频（Wan） | Wan 图生视频模型 | [Wan图生视频](https://help.aliyun.com/zh/model-studio/wan-image-to-video-guide) |
| 首尾帧视频 | 首尾帧控制视频生成 | [首尾帧视频](https://help.aliyun.com/zh/model-studio/image-to-video-first-and-last-frames-guide) |
| 图像生成视频 | 通用图生视频 | [图生视频](https://help.aliyun.com/zh/model-studio/image-to-video-guide) |

### 语音合成（TTS）

| 功能 | 说明 | 文档链接 |
|------|------|----------|
| 实时语音合成 | WebSocket 流式语音合成（待完善） | [实时语音合成](https://help.aliyun.com/zh/model-studio/realtime-tts-user-guide) |
| 非实时语音合成 | HTTP 非流式语音合成 | [非实时语音合成](https://help.aliyun.com/zh/model-studio/non-realtime-tts-user-guide) |
| 声音复刻 | 通过音频样本创建定制音色 | [声音复刻](https://help.aliyun.com/zh/model-studio/voice-cloning-user-guide) |
| 声音设计 | 通过文本描述创建定制音色 | [声音设计](https://help.aliyun.com/zh/model-studio/voice-design-user-guide) |
| SSML 与 LaTeX | 语音合成标记语言，数学公式朗读 | [SSML与LaTeX](https://help.aliyun.com/zh/model-studio/ssml-latex-user-guide) |
| CosyVoice 音色列表 | CosyVoice 可用音色参考 | [CosyVoice音色列表](https://help.aliyun.com/zh/model-studio/cosyvoice-voice-list) |

## 待开发接口（规划中）

以下接口参考文档，待后续开发：

### 文本与搜索（待开发）

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| 网页提取 | Web Extractor 网页内容提取 | [网页提取](https://help.aliyun.com/zh/model-studio/web-extractor) |
| 代码解释器 | Qwen Code Interpreter 代码执行 | [代码解释器](https://help.aliyun.com/zh/model-studio/qwen-code-interpreter) |
| 图片搜索 | Web Search Image 图文搜索 | [图片搜索](https://help.aliyun.com/zh/model-studio/web-search-image) |
| 图像搜索 | Image Search 以图搜图 | [图像搜索](https://help.aliyun.com/zh/model-studio/image-search) |
| 文件搜索 | File Search 文件检索 | [文件搜索](https://help.aliyun.com/zh/model-studio/file-search) |
| MCP | Model Context Protocol 集成 | [MCP](https://help.aliyun.com/zh/model-studio/mcp) |

### 图像与视频（待开发）

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| 图像实例分割 | 实例分割与抠图 | [图像实例分割](https://help.aliyun.com/zh/model-studio/image-instance-segmentation) |
| 视频生成视频 | 视频风格迁移、增强 | [视频生成视频](https://help.aliyun.com/zh/model-studio/video-to-video-guide) |
| Wan 视频编辑 | Wan 视频编辑模型 | [Wan视频编辑](https://help.aliyun.com/zh/model-studio/wan-video-editing-guide) |
| Wan VACE 视频编辑 | VACE 视频编辑与一致性编辑 | [Wan VACE](https://help.aliyun.com/zh/model-studio/wan-vace-guide) |
| Tripo 3D 生成 | 3D 模型生成 | [Tripo 3D生成](https://help.aliyun.com/zh/model-studio/tripo-3d-generation-guide) |

### 语音与音频（待开发）

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Qwen-TTS 音色列表 | Qwen-TTS 可用音色及参数说明 | [Qwen-TTS音色列表](https://help.aliyun.com/zh/model-studio/qwen-tts-voice-list) |
| FunMusic 音乐生成 | 百聆音乐生成大模型 | [音乐生成](https://help.aliyun.com/zh/model-studio/fun-music) |
| 实时语音识别 | WebSocket 流式语音识别 | [实时语音识别](https://help.aliyun.com/zh/model-studio/real-time-speech-recognition-user-guide) |
| 非实时语音识别 | 异步音视频文件转写 | [非实时语音识别](https://help.aliyun.com/zh/model-studio/non-realtime-speech-recognition-user-guide) |
| 自定义热词 | 语音识别热词词汇表管理 | [自定义热词](https://help.aliyun.com/zh/model-studio/custom-hot-words-user-guide) |

### 多模态与实时（待开发）

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| 端到端语音 | S2S 语音大模型 | [S2S模型](https://help.aliyun.com/zh/model-studio/s2s-model) |
| 实时语音 | 实时语音对话 | [实时语音](https://help.aliyun.com/zh/model-studio/realtime) |
| Qwen-Omni | 多模态大模型 | [Qwen-Omni](https://help.aliyun.com/zh/model-studio/qwen-omni) |
| 实时翻译 | 流式实时翻译 | [实时翻译](https://help.aliyun.com/zh/model-studio/qwen3-5-livetranslate-flash-realtime) |
| 翻译模型 | Qwen-LiveTranslate 翻译 | [翻译模型](https://help.aliyun.com/zh/model-studio/qwen3-livetranslate-flash) |
| Omni 音色列表 | Omni 系列可用音色 | [Omni音色列表](https://help.aliyun.com/zh/model-studio/omni-voice-list) |

### 向量与排序（待开发）

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Embedding 向量 | 文本向量表征模型 | [Embedding](https://help.aliyun.com/zh/model-studio/embedding) |
| Rerank 排序 | 文本排序模型 | [Rerank](https://help.aliyun.com/zh/model-studio/rerank) |

## 快速开始

```bash
# 配置环境变量
export BAILIAN_API_KEY=***
export BAILIAN_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
export BAILIAN_MODEL=qwen3.7-plus

# 运行简单对话示例
moon run cmd/bailian/chat

# 运行深度思考示例
moon run cmd/bailian/thinking
```
