{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.sessionPath = ["/opt/homebrew/bin/"];
    programs.zsh.initExtra = ''
      # NOT related to homebrew, this is stuff like docker
      export PATH="$PATH:/usr/local/bin"
      _iterm2_shell="''${HOME}/.iterm2_shell_integration.$(basename "''${SHELL}")"
      if [[ -e "''${_iterm2_shell}" ]] ; then
        source "''${_iterm2_shell}"
      fi
      unset _iterm2_shell
    '';
  };
}
