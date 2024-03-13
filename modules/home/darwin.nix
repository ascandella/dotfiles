{ pkgs, ... }:
{
  # TODO: Remove usage of homebrew
  programs.zsh.initExtra = pkgs.lib.mkIf pkgs.stdenv.isDarwin ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$PATH:/usr/local/bin"
  '';
}
