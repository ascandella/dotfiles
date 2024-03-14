{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.sessionPath = ["/opt/homebrew/bin/"];
    home.packages = with pkgs; [
      jira-cli-go
    ];

    programs.zsh.initExtra = ''
      # NOT related to homebrew, this is stuff like docker
      export PATH="$PATH:/usr/local/bin"
      _iterm2_shell="''${HOME}/.iterm2_shell_integration.$(basename "''${SHELL}")"
      if [[ -e "''${_iterm2_shell}" ]] ; then
        source "''${_iterm2_shell}"
      fi
      unset _iterm2_shell
    '';

    programs.zsh.shellAliases = {
      # TODO: remove these, I'm not using them
      topbar = "yabai -m config external_bar all:38:0";
      bottombar = "yabai -m config external_bar all:0:30";

      # TODO: not currently installing
      jiraissues = "jira issue list -a$(jira me)";
      inprog = "jiraissues -s 'In Progress' --plain --columns KEY,SUMMARY --no-headers";
    };
  };
}
