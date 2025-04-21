default:
  @just --list

deploy:
  nix run .#deploy-rs -- --skip-checks

darwin-name:
  #!/usr/bin/env bash
  if [[ "$(hostname)" =~ ^GFT- ]] ; then 
    echo "workbook"
  else
    echo "studio" 
  fi

darwin:
  darwin-rebuild switch --flake ".#$(just darwin-name)"

home:
  home-manager switch --flake ".#$(just darwin-name)"

lint:
  nix run .#lint

nixos:
  sudo nixos-rebuild switch --flake .
