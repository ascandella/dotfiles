# Autoresearch: zsh startup time

## Objective

Reduce `zsh -i -c exit` wall-clock time, with emphasis on the **Zellij subshell** case —
the shell the user opens most often (new pane/window in Zellij). In that scenario most of
the environment (PATH, FNM\_\*, MISE_SHELL, …) is already inherited from the parent shell,
so many init steps are pure waste.

## Metrics

- **Primary**: `zellij_ms` (ms, lower is better) — median of 7 `zsh -i -c exit` runs with
  ZELLIJ/MISE_SHELL/FNM_MULTISHELL_PATH set (simulating a real Zellij pane)
- **Secondary**: `fresh_ms` — median startup in a clean env (simulating first terminal open);
  `p90_zellij_ms`, `p90_fresh_ms` — 90th-percentile times for spread visibility

## How to Run

```
./autoresearch.sh
```

Outputs `METRIC name=value` lines. Includes `just home` to apply the current config.

## Files in Scope

- `modules/home/shell.nix` — main zsh/plugin/init config; where all the nix derivations and
  `initContent` live
- `modules/home/files/zsh/custom-init.zsh` — aliases, FZF opts, keybindings, histdb setup

## Off Limits

- Do not change shell behaviour that would be user-visible: aliases, keybindings, FZF opts,
  histdb integration, autosuggestions, all plugins must remain functional.
- Do not remove any tool integrations (fnm, mise, zoxide, starship, direnv, fzf, fzf-tab).

## Constraints

- `just home` must succeed on every kept commit.
- Shell must remain interactive and fully functional after optimizations.
- Both Zellij-pane and fresh-terminal cases must keep all tools working.

## Key Findings from Pre-experiment Profiling (EPOCHREALTIME trace)

### Timing profile (non-interactive trace, approximate per-step cost):

| Step | ~ms |
|------------------------------|-----|
| compinit -C | 20 |
| fnm env --use-on-cd (eval) | 27 |
| starship init (pre-built) | 16 |
| mise init (pre-built) | 16 |
| fzf-tab plugin | 8 |
| zsh-history-substring-search | 6 |
| zsh-npm-scripts-autocomplete | 6 |
| custom-init.zsh | 6 |
| zsh-autoenv | 6 |
| direnv/zoxide/fzf (pre-built)| 1 |

### What's inherited in a Zellij subshell:

The following env vars are already set (exported by parent shell):

- `ZELLIJ=0`, `ZELLIJ_SESSION_NAME`, `ZELLIJ_PANE_ID`
- `FNM_MULTISHELL_PATH`, `FNM_DIR`, `FNM_ARCH`, `FNM_VERSION_FILE_STRATEGY`, etc.
- `MISE_SHELL=zsh`, `__MISE_ORIG_PATH`, `__MISE_DIFF`, `__MISE_SESSION`
- Correct `PATH` (already includes fnm multishell bin, mise shims, nix, etc.)

### Already-implemented optimizations:

- `compinit -C` (skips security check, ~180ms saved vs full compinit)
- All tool inits pre-built as nix derivations (fzf, direnv, zoxide, starship, mise)
- `miseZshInitNested`: skips `hook-env` + PATH override in subshells (`[[ -z $MISE_SHELL ]]`)
- `zsh-defer` for syntax-highlighting + autopair (cosmetic plugins load after first prompt)
- Lazy AWS completion (only sources on first `aws<TAB>`)

### Biggest remaining opportunities:

1. **fnm in Zellij subshells** (~27ms): `eval "$(fnm env --use-on-cd)"` still runs and
   creates a fresh multishell dir even when PATH/FNM\_\* are inherited. Fix: detect `$ZELLIJ`
   and source a pre-built static shims file (functions + alias only, no subprocess).
1. **Defer fzf-tab, npm-autocomplete, history-substring-search** via `zsh-defer` (~20ms):
   these don't need to be ready before first prompt — they hook into zle/completion which
   zsh-defer can set up after prompt display.
1. **Defer starship in subshells** (~16ms): starship prompt hooks register as precmd — safe
   to defer. But visually the first prompt might render without the prompt symbol briefly.
1. **compinit lazy-deferral** (~20ms): risky — many plugins call `compdef` during load.

## What's Been Tried

_(Start experiments — update this section as results accumulate.)_
