#!/bin/bash
#
# 运行所有 cmd/bailian 示例（mock 模式，无需 API Key）
# 并将输出汇总到文件。
#
set -u

# 仓库根目录（脚本位于 cmd/bailian 同级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT" || exit 1

OUTPUT_FILE="$SCRIPT_DIR/all_examples_output.txt"
: > "$OUTPUT_FILE"

# 收集所有示例目录
examples=()
for d in cmd/bailian/*/; do
  [ -d "$d" ] && examples+=("$(basename "$d")")
done

echo "找到 ${#examples[@]} 个示例，开始运行（mock 模式）..."
echo "输出文件: $OUTPUT_FILE"
echo ""

count=0
for name in "${examples[@]}"; do
  count=$((count + 1))
  echo "[$count/${#examples[@]}] 运行: $name"
  {
    echo "=== $name ==="
    BAILIAN_API_KEY="" timeout 60 moon run "cmd/bailian/$name" 2>&1
    echo ""
  } >> "$OUTPUT_FILE"
done

echo ""
echo "完成！共运行 ${#examples[@]} 个示例"
echo "输出已保存至: $OUTPUT_FILE"
echo "总行数: $(wc -l < "$OUTPUT_FILE")"
