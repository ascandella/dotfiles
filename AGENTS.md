# Agent Instructions — dotfiles

## Testing Changes

### Home Manager (macOS)

After modifying any home-manager modules or config, rebuild and activate with:

```sh
just home
# expands to: home-manager switch --flake ".#<hostname>"
```

### Full Darwin System

For changes that touch nix-darwin system-level config (e.g. `hosts/studio`, `hosts/workbook`):

```sh
just darwin
# expands to: sudo darwin-rebuild switch --flake ".#<hostname>"
```

### NixOS

For changes to NixOS hosts:

```sh
just nixos
# expands to: sudo nixos-rebuild switch --flake .
```

## Formatting

**Before committing any `.nix` file changes**, run the formatter:

```sh
nix fmt
```

This runs [treefmt](https://github.com/numtide/treefmt-nix) with the following formatters configured in `treefmt.nix`:

- **nixfmt** — Nix files
- **deadnix** — removes unused Nix bindings
- **stylua** — Lua files
- **mdformat** — Markdown files

## Linting

To run the full lint suite (flake checks + statix static analysis):

```sh
just lint
# expands to: nix run .#lint
```

Run this before opening a PR to catch common Nix antipatterns.
