## Installing Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## First run

This is only needed once, afterwards `home-manager switch` works.

```sh
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ".#ai-studio"
```

## After the first run, you can:

```sh
darwin-rebuild switch --flake ".#ai-studio"
```
