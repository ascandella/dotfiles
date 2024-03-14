{ pkgs, ... }:
{
  # TODO: Remove usage of homebrew
  programs.zsh.initExtra = pkgs.lib.mkIf pkgs.stdenv.isDarwin ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # NOT related to homebrew, this is stuff like docker
    export PATH="$PATH:/usr/local/bin"
  '';
}
