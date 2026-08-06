# 零一万物 Yi

基于零一万物 Yi 系列模型的调用，使用 OpenAI 兼容接口。

## 环境变量配置

```bash
export YI_API_KEY=***
export YI_BASE_URL=https://api.lingyiwanwu.com/v1  # 可选，默认值
```

API Key 获取地址：https://platform.lingyiwanwu.com/api-keys

## 示例程序

| 示例 | 说明 | 运行命令 |
|------|------|----------|
| `chat` | 简单对话 | `moon run cmd/yi/chat` |

## 支持的模型

| 模型 | 说明 |
|------|------|
| `yi-lightning` | Yi-Lightning（全场景旗舰） |
| `yi-large` | Yi-Large（千亿参数） |
| `yi-large-turbo` | Yi-Large Turbo（快速版） |
| `yi-vision` | Yi-Vision（视觉理解） |
| `yi-medium-200k` | Yi-Medium 200K（长上下文） |

## API 文档参考

| 接口 | 说明 | 文档链接 |
|------|------|----------|
| Chat Completions | OpenAI 兼容的对话补全接口 | [Chat](https://platform.lingyiwanwu.com/api-reference) |

## 快速开始

```bash
export YI_API_KEY=***
moon run cmd/yi/chat
```

## 特性

- Yi-Lightning 国际盲测排名前列
- 强大的中英文理解能力
- 支持超长上下文（200K）
- 视觉理解能力（Yi-Vision）
- OpenAI 兼容接口
