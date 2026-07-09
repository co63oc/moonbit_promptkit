#!/bin/bash
# =============================================================================
# Moonbit PromptKit - 全量无 API Key 测试脚本
#
# 所有命令在 API_KEY 为空时自动使用内置 mock_body 数据，无需真实 API。
# 用法: bash tools/test_all_no_api_key.sh
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
TOTAL=0

# 所有可能存在的 API 相关环境变量，测试时需要全部置空
# 避免本机已配置的真实 Key 被意外使用
UNSET_ENV=(
  BAILIAN_API_KEY BAILIAN_BASE_URL BAILIAN_MODEL BAILIAN_VECTOR_STORE_ID
  DASHSCOPE_API_KEY
  HUNYUAN_API_KEY HUNYUAN_BASE_URL
  MOONSHOT_API_KEY MOONSHOT_BASE_URL
  OPENROUTER_API_KEY OPENROUTER_BASE_URL
  QIANFAN_API_KEY QIANFAN_BASE_URL QIANFAN_MODEL
)

run_test() {
  local name="$1"
  shift
  TOTAL=$((TOTAL + 1))
  printf "[%3d/46] %-45s ... " "$TOTAL" "$name"

  # 构建 env -u 参数：逐个 unset 环境变量
  local env_args=()
  for var in "${UNSET_ENV[@]}"; do
    env_args+=(-u "$var")
  done

  if env "${env_args[@]}" moon run "$@" > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}FAIL${NC}"
    FAIL=$((FAIL + 1))
  fi
}

echo "=============================================="
echo "  Moonbit PromptKit - Full Mock Test Suite"
echo "  (BAILIAN_API_KEY / HUNYUAN_API_KEY ... all empty)"
echo "=============================================="
echo ""

# =========================================================================
# Bailian (百炼) - 40 commands
# =========================================================================
echo "--- Bailian (百炼) ---"

run_test "bailian/audio_captioner"     cmd/bailian/audio_captioner
run_test "bailian/background"          cmd/bailian/background
run_test "bailian/batch"               cmd/bailian/batch
run_test "bailian/chat"                cmd/bailian/chat
run_test "bailian/code_interpreter"    cmd/bailian/code_interpreter
run_test "bailian/context_cache"       cmd/bailian/context_cache
run_test "bailian/deep_research"       cmd/bailian/deep_research
run_test "bailian/dialogue_analysis"   cmd/bailian/dialogue_analysis
run_test "bailian/embedding"           cmd/bailian/embedding
run_test "bailian/file_search"         cmd/bailian/file_search
run_test "bailian/gui_automation"      cmd/bailian/gui_automation
run_test "bailian/image_edit"          cmd/bailian/image_edit
run_test "bailian/image_expansion"     cmd/bailian/image_expansion
run_test "bailian/image_gen"           cmd/bailian/image_gen
run_test "bailian/image_search"        cmd/bailian/image_search
run_test "bailian/mcp"                 cmd/bailian/mcp
run_test "bailian/models"              cmd/bailian/models
run_test "bailian/multi_chat"          cmd/bailian/multi_chat
run_test "bailian/params"              cmd/bailian/params
run_test "bailian/partial"             cmd/bailian/partial
run_test "bailian/qwen_coder"          cmd/bailian/qwen_coder
run_test "bailian/qwen_doc_turbo"      cmd/bailian/qwen_doc_turbo
run_test "bailian/qwen_long"           cmd/bailian/qwen_long
run_test "bailian/qwen_math"           cmd/bailian/qwen_math
run_test "bailian/rerank"              cmd/bailian/rerank
run_test "bailian/role_play"           cmd/bailian/role_play
run_test "bailian/search"              cmd/bailian/search
run_test "bailian/speech_recognition"  cmd/bailian/speech_recognition
run_test "bailian/stream"              cmd/bailian/stream
run_test "bailian/style_repaint"       cmd/bailian/style_repaint
run_test "bailian/thinking"            cmd/bailian/thinking
run_test "bailian/tool_call"           cmd/bailian/tool_call
run_test "bailian/translate"           cmd/bailian/translate
run_test "bailian/tts"                 cmd/bailian/tts
run_test "bailian/vace"                cmd/bailian/vace
run_test "bailian/video_gen"           cmd/bailian/video_gen
run_test "bailian/vision"              cmd/bailian/vision
run_test "bailian/vl"                  cmd/bailian/vl
run_test "bailian/web_extractor"       cmd/bailian/web_extractor
run_test "bailian/web_search_image"    cmd/bailian/web_search_image

# =========================================================================
# Hunyuan (混元) - 1 command
# =========================================================================
echo ""
echo "--- Hunyuan (混元) ---"

run_test "hunyuan/chat"                cmd/hunyuan/chat

# =========================================================================
# Moonshot - 2 commands
# =========================================================================
echo ""
echo "--- Moonshot ---"

run_test "moonshot/chat"               cmd/moonshot/chat
run_test "moonshot/stream"             cmd/moonshot/stream

# =========================================================================
# OpenRouter - 2 commands
# =========================================================================
echo ""
echo "--- OpenRouter ---"

run_test "openrouter/chat"             cmd/openrouter/chat
run_test "openrouter/stream"           cmd/openrouter/stream

# =========================================================================
# Qianfan (千帆) - 1 command
# =========================================================================
echo ""
echo "--- Qianfan (千帆) ---"

run_test "qianfan/chat"                cmd/qianfan/chat

# =========================================================================
# Summary
# =========================================================================
echo ""
echo "=============================================="
printf "  Total: %d  |  ${GREEN}PASS: %d${NC}  |  ${RED}FAIL: %d${NC}\n" "$TOTAL" "$PASS" "$FAIL"
echo "=============================================="

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
