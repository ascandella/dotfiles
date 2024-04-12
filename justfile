deploy:
  nix run .#deploy-rs -- --skip-checks

darwin-name:
  #!/usr/bin/env bash
  if [[ "$(hostname)" =~ ^Aidens-MacBook ]] ; then 
    echo "workbook"
  else
    echo "studio" 
  fi

darwin:
  darwin-rebuild switch --flake ".#$(just darwin-name)"

lint:
  nix run .#lint
