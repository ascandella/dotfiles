#!/usr/bin/env bash
# Benchmark zsh startup time (ms), average of 8 runs (drop first for cache warmup)
set -euo pipefail

N=8
total=0
for i in $(seq 1 $N); do
  ms=$( { time zsh -i -c exit; } 2>&1 | grep real | sed 's/.*m//;s/s//' | awk '{printf "%d", $1*1000}' )
  echo "  run $i: ${ms}ms"
  total=$((total + ms))
done

avg=$((total / N))
echo "METRIC startup_ms=$avg"
