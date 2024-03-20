{ pkgs, lib, ... }:

{
  home.activation.neovim = lib.home-manager.hm.dag.entryAfter ["linkGeneration"] ''
    #! /bin/bash
    NVIM_WRAPPER=~/.nix-profile/bin/nvim
    STATE_DIR=~/.local/state/nix/
    STATE_FILE=$STATE_DIR/lazy-lock-checksum
    LOCK_FILE=~/.config/nvim/lazy-lock.json
    HASH=$(nix-hash --flat $LOCK_FILE)

    [ ! -d $STATE_DIR ] && mkdir -p $STATE_DIR
    [ ! -f $STATE_FILE ] && touch $STATE_FILE

    if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
      echo "Syncing neovim plugins"
      PATH="$PATH:${pkgs.git}/bin" $DRY_RUN_CMD $NVIM_WRAPPER --headless "+Lazy! restore" +qa
      $DRY_RUN_CMD echo $HASH >$STATE_FILE
    else
      $VERBOSE_ECHO "Neovim plugins already synced, skipping"
    fi
  '';
};
