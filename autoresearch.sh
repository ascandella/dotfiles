#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Use full path so it works inside env -i / stripped-PATH subshells
HYPERFINE=$(command -v hyperfine)

# Apply current config
echo "[autoresearch] Running just home..." >&2
just home 2>&1 | grep -E "^(Activating|Warning|Error)" >&2 || true

# --- helpers ---
median() {
  # median of space-separated numbers
  printf '%s\n' "$@" | sort -n | awk '{a[NR]=$1} END { n=NR; if(n%2==1) print a[(n+1)/2]; else printf "%.1f\n", (a[n/2]+a[n/2+1])/2 }'
}

p90() {
  printf '%s\n' "$@" | sort -n | awk '{a[NR]=$1} END { print a[int(NR*0.9)+1] }'
}

RUNS=7

# --- Zellij subshell scenario ---
# Simulates: open new pane inside an active Zellij session.
# Key inherited vars: ZELLIJ, MISE_SHELL, FNM_MULTISHELL_PATH, FNM_DIR, etc.
# PATH is already correct; tool env is already set up.
echo "[autoresearch] Measuring Zellij subshell startup (${RUNS} runs)..." >&2
zellij_times=()
_tmpjson=$(mktemp /tmp/hf-XXXXXX.json)
trap 'rm -f $_tmpjson' EXIT

for i in $(seq 1 $RUNS); do
  ZELLIJ=0 \
    ZELLIJ_SESSION_NAME=test \
    MISE_SHELL=zsh \
    FNM_MULTISHELL_PATH=/Users/ascandella/.local/state/fnm_multishells/99_test \
    FNM_DIR=/Users/ascandella/.local/share/fnm \
    FNM_VERSION_FILE_STRATEGY=local \
    FNM_LOGLEVEL=info \
    FNM_NODE_DIST_MIRROR=https://nodejs.org/dist \
    FNM_COREPACK_ENABLED=false \
    FNM_RESOLVE_ENGINES=true \
    FNM_ARCH=arm64 \
    "$HYPERFINE" --shell=none --runs=1 --export-json="$_tmpjson" \
      'zsh -i -c exit' >/dev/null 2>&1
  ms=$(jq -r '.results[0].mean * 1000 | round' "$_tmpjson")
  zellij_times+=("$ms")
done

# --- Fresh terminal scenario ---
# Simulates: opening a brand-new terminal (no Zellij, tool env not yet initialised).
# Unsets the "already set up" markers so the full init path runs, but keeps
# PATH intact (a real terminal inherits PATH from launchd/PAM, not empty).
echo "[autoresearch] Measuring fresh shell startup (${RUNS} runs)..." >&2
fresh_times=()
for i in $(seq 1 $RUNS); do
  env -u ZELLIJ -u ZELLIJ_SESSION_NAME -u ZELLIJ_PANE_ID \
      -u MISE_SHELL -u __MISE_ORIG_PATH -u __MISE_DIFF -u __MISE_SESSION \
      -u __MISE_ZSH_PRECMD_RUN -u __MISE_ZSH_CHPWD_RAN \
      -u FNM_MULTISHELL_PATH -u FNM_DIR -u FNM_VERSION_FILE_STRATEGY \
      -u FNM_LOGLEVEL -u FNM_NODE_DIST_MIRROR -u FNM_COREPACK_ENABLED \
      -u FNM_RESOLVE_ENGINES -u FNM_ARCH \
    "$HYPERFINE" --shell=none --runs=1 --export-json="$_tmpjson" \
      'zsh -i -c exit' >/dev/null 2>&1
  ms=$(jq -r '.results[0].mean * 1000 | round' "$_tmpjson")
  fresh_times+=("$ms")
done

# --- Report ---
z_med=$(median "${zellij_times[@]}")
z_p90=$(p90   "${zellij_times[@]}")
f_med=$(median "${fresh_times[@]}")
f_p90=$(p90   "${fresh_times[@]}")

echo "METRIC zellij_ms=${z_med}"
echo "METRIC fresh_ms=${f_med}"
echo "METRIC p90_zellij_ms=${z_p90}"
echo "METRIC p90_fresh_ms=${f_p90}"

echo "[autoresearch] zellij: med=${z_med}ms p90=${z_p90}ms  |  fresh: med=${f_med}ms p90=${f_p90}ms" >&2
