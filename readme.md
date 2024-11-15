## Installing Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## First run

This is only needed once

```sh
nix run nix-darwin \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes -- \
    switch --flake ".#studio"
```

## After the first run, you can:

```sh
just darwin
# short for
darwin-rebuild switch --flake ".#studio"
```
