# Autoresearch Ideas — zsh startup

## Explored, gave real wins
- ✅ Skip fnm subprocess in Zellij (pkgs.writeText static shims, ZELLIJ guard) — −27ms
- ✅ Defer fzf-tab + npm-autocomplete + history-substring-search via zsh-defer — −21ms
- ✅ Strip duplicate fpath entries (run/current-system + usr/share/zsh 5.9/functions) — −15ms

## Tried, no gain
- ✗ Remove duplicate zsh-autosuggestions from plugins array — autosuggestions guards
  against double-load internally; essentially free to source twice

## Promising but blocked/risky
- **Defer compinit** (~15ms): user said no. Would need compdef stub + replay queue.
  autosuggestions already handles missing compdef with `whence compdef || return`.
  Other callers (aws, kgetsec, tv) would queue safely. High reward, medium risk.
- **Defer zsh-autoenv** (~5ms): NOT SAFE. Plugin calls `_autoenv_chpwd_handler`
  immediately on load to check current directory for .autoenv.zsh. Deferring means
  initial-directory autoenv files are never sourced for that pane.

## Other ideas not yet tried
- **Replace fnm with mise for Node.js** — mise is already active; dropping fnm removes
  the 27ms fresh-shell subprocess entirely. Big behavioral change, needs user buy-in.
- **Pre-compile zsh-autoenv scripts to .zwc** — autoenv.zsh is ~500 lines; .zwc could
  save ~1-2ms on parsing. Add home.activation step: `zsh -c "zcompile ~/.config/zsh/plugins/zsh-autoenv/autoenv.zsh"`.
  Likely minimal gain vs complexity.
- **Skip direnv initial hook-env in Zellij** — direnv registers a precmd hook that runs
  on every shell. If direnv env is already active (inherited), the initial hook-env call
  is a no-op but still forks. Small gain (~1ms).

## Hard floor analysis (Zellij subshell, current best: 89ms)
- ZLE interactive-mode init: ~30ms — unavoidable
- compinit -C loading 1052-file dump: ~15ms — off-limits
- Script loading (starship 9ms + autoenv 5ms + custom-init 6ms + histdb 3ms + …): ~35ms
- Function call overhead (add-zsh-hook ×11, is-at-least ×2, etc.): ~5ms
Realistic floor without deferring compinit: ~75-80ms
Realistic floor with deferred compinit: ~60-65ms
