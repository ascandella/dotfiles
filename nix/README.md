## Installing Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## First run

This is only needed once, afterwards `home-manager switch` works.

```sh
ln -s $PWD $HOME/.config/home-manager
```

## Old way:

```sh
nix build ".#homeConfigurations.${USER}.activationPackage"  && ./result/activate
```
