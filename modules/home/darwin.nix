{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.sessionPath = ["/opt/homebrew/bin/"];
    programs.zsh.initExtra = ''
      # NOT related to homebrew, this is stuff like docker
      export PATH="$PATH:/usr/local/bin"
    '';
  };
}
