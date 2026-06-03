# co63oc/moonbit_openai

以百炼接口为例运行：
先导出环境变量，MOONBIT_API_KEY 为百炼API KEY，在页面 `https://bailian.console.aliyun.com/cn-beijing?tab=model#/api-key` 查看
```
export MOONBIT_API_KEY=xxx
export MOONBIT_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions
export MOONBIT_MODEL=qwen3.7-plus
```
然后运行 `moon run cmd/main`

如果有其他兼容openai的接口，可以修改这几个环境变量为对应接口值。
