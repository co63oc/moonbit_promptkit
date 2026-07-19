# co63oc/moonbit_promptkit

MoonBit 实现的 AI 大模型 SDK，附带多平台调用示例。

## 安装

### 前置条件：安装 MoonBit 工具链

```bash
curl -fsSL https://cli.moonbitlang.com/install.sh | bash
```

安装完成后重启终端或执行 `source ~/.bashrc`（/`~/.zshrc`），验证：

```bash
moon version
```

### 获取项目

```bash
git clone https://gitlink.org.cn/co63oc/moonbit_promptkit.git
cd moonbit_promptkit
```

### 安装依赖

```bash
moon install
```

### 运行示例

无需 API Key 即可运行（使用内置 mock 数据）：

```bash
moon run cmd/bailian/stream      # 流式输出示例
moon run cmd/bailian/tool_call   # 工具调用示例
```

指定 API Key 调用真实接口：

```bash
BAILIAN_API_KEY="sk-xxx" moon run cmd/bailian/chat
```

### 运行测试

```bash
moon test
```

## 快速开始

### 最小对话示例

```mbt
// main.mbt — 文件放在一个独立的 MoonBit 包中

async fn main {
  // 空 api_key 自动触发 mock 模式，无需联网
  let config = @lib.make_client_config(
    "",
    "https://dashscope.aliyuncs.com/compatible-mode/v1",
    mock_body="{\"model\":\"qwen-plus\",\"choices\":[{\"message\":{\"content\":\"你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型。\",\"role\":\"assistant\"},\"finish_reason\":\"stop\"}]}",
  )
  let messages = [@lib.user_message_with_text("你好!")]
  let reply = @lib.chat(config, "qwen-plus", messages)
  println(reply.content)
}
```

预期输出：

```
你好！我是通义千问（Qwen），阿里巴巴集团旗下的超大规模语言模型。
```

> **补充说明**：`lib/client` 包中的 `chat` / `chat_stream` / `chat_stream_thinking` 为核心入口。
> 更多功能（工具调用、图像/视频/音频生成、embedding、MCP 等）见 [cmd/bailian/](cmd/bailian/) 目录下的完整示例。

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

## Mock 数据说明

mock 数据来源于 API 接口调用返回，使用授权与项目代码一致，见 [LICENSE](LICENSE)。

参考范围：覆盖对话补全、SSE 流式、工具调用、思考模型等 OpenAI 兼容格式的响应解析；不包含异常响应、网络异常、生产环境真实延迟及模型输出质量评估。

## 环境变量

SDK 在运行时会从环境变量读取 API Key。不同模块使用各自独立的环境变量。

- **设置了 API Key**：正常调用真实 API 接口。
- **API Key 为空**：使用内置的 mock 数据返回，无需联网即可运行示例、查看效果。适合快速体验、测试和 CI 环境。

| 模块 / 平台 | 所需 API Key 环境变量 | 说明 |
|-------------|----------------------|------|
| **OpenRouter** | `OPENROUTER_API_KEY` | `cmd/openrouter/*` 示例 |
| **Moonshot AI (Kimi)** | `MOONSHOT_API_KEY` | `cmd/moonshot/*` 示例 |
| **腾讯混元 (Tokenhub)** | `HUNYUAN_API_KEY` | `cmd/hunyuan/*` 示例 |
| **百度千帆 (Qianfan)** | `QIANFAN_API_KEY` | `cmd/qianfan/*` 示例 |
| **阿里云百炼 (Bailian)** | `BAILIAN_API_KEY` | `cmd/bailian/*` 全部示例（chat、stream、image、video、audio、embedding、batch 等）|

各模块除 API Key 外，Base URL 也通过环境变量读取（缺失时使用内置默认值）：

- OpenRouter：`OPENROUTER_BASE_URL`（默认 `https://openrouter.ai/api/v1`）
- Moonshot：`MOONSHOT_BASE_URL`（默认 `https://api.moonshot.cn/v1`）
- 腾讯混元：`HUNYUAN_BASE_URL`（默认 `https://tokenhub.tencentmaas.com/v1`）
- 百度千帆：`QIANFAN_BASE_URL`（默认 `https://qianfan.baidubce.com/v2`）
- 阿里云百炼：`BAILIAN_BASE_URL`（默认 `https://dashscope.aliyuncs.com/compatible-mode/v1`）

### 额外环境变量

部分阿里云百炼示例还需要以下变量：

| 环境变量 | 用途 | 是否必填 |
|----------|------|----------|
| `BAILIAN_MODEL` | 指定模型名（如 `qwen-plus`、`qwen3.7-plus`），未设置时使用代码内默认值 | 可选 |
| `BAILIAN_VECTOR_STORE_ID` | 知识库（向量库）ID，`cmd/bailian/file_search` 示例必需 | 条件必填 |

### 设置示例

```bash
# Bash / Zsh
export OPENROUTER_API_KEY="sk-or-..."
export BAILIAN_API_KEY="sk-..."
export BAILIAN_VECTOR_STORE_ID="vs_xxx"   # 仅 file_search 示例需要

# 或临时在命令前指定
QIANFAN_API_KEY="..." moon run cmd/qianfan/chat
```

> 提示：`lib` 核心库本身不直接硬编码任何 API Key 变量名，所有变量名由各 `cmd/*`
> 示例在调用 `make_client_config` 时传入。如需新增兼容 OpenAI 的平台，只需在对应示例中修改环境变量名即可。
> 各示例已内置 mock 数据，无需 API Key 即可直接运行查看效果。

## 通用说明

所有平台均支持 OpenAI 兼容接口，配置对应的 API Key 和 Base URL 即可使用。

如有其他兼容 OpenAI 的接口，可修改对应平台的环境变量为相应值。
