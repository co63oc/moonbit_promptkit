#!/bin/bash
# Run programs under cmd/bailian/
# Usage: ./run_bailian.sh [program_name]
#   no args -> run all
#   <name>  -> run specific program

set -e
cd "$(dirname "$0")/../"

# Auto-discover programs from cmd/bailian/
mapfile -t PROGRAMS < <(find cmd/bailian -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

run_one() {
  local name=$1
  if [[ ! " ${PROGRAMS[*]} " =~ " $name " ]]; then
    echo "Unknown program: $name"
    echo "Available: ${PROGRAMS[*]}"
    exit 1
  fi
  echo "▶ Running cmd/bailian/$name"
  moon run cmd/bailian/$name
}

if [ $# -eq 0 ]; then
  for prog in "${PROGRAMS[@]}"; do
    echo ""
    echo "========== cmd/bailian/$prog =========="
    moon run "cmd/bailian/$prog" || echo "⚠ $prog failed (exit $?)"
  done
else
  run_one "$1"
fi
