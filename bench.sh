#!/usr/bin/env bash
# Benchmark zsh startup time (ms), average of 7 runs after 1 warm-up.
# The warm-up run lets compinit regenerate the zcompdump if it was just wiped
# (e.g. right after `just home`).  All subsequent runs reflect steady-state.
set -euo pipefail

N=7
echo "  warm-up run (may regenerate zcompdump)..."
{ time zsh -i -c exit; } 2>&1 | grep real

total=0
for i in $(seq 1 $N); do
  ms=$( { time zsh -i -c exit; } 2>&1 | grep real | sed 's/.*m//;s/s//' | awk '{printf "%d", $1*1000}' )
  echo "  run $i: ${ms}ms"
  total=$((total + ms))
done

avg=$((total / N))
echo "METRIC startup_ms=$avg"
