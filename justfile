deploy:
  nix run .#deploy-rs -- --skip-checks

darwin-name:
  #!/usr/bin/env bash
  if [[ "$(hostname)" =~ ^Aidens-Mac ]] ; then 
    echo "studio" 
  else
    echo "workbook"
  fi

darwin:
  darwin-rebuild switch --flake ".#$(just darwin-name)"

lint:
  nix run .#lint
