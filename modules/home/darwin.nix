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

      # from: https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd#file-keychain-environment-variables-sh

      ### Functions for setting and getting environment variables from the OSX keychain ###
      ### Adapted from https://www.netmeister.org/blog/keychain-passwords.html ###

      # Use: keychain-environment-variable SECRET_ENV_VAR
      function keychain-environment-variable () {
        security find-generic-password -w -a ''${USER} -D "environment variable" -s "''${1}"
      }

      # Use: set-keychain-environment-variable SECRET_ENV_VAR
      #   provide: super_secret_key_abc123
      function set-keychain-environment-variable () {
        [ -n "$1" ] || print "Missing environment variable name"

        # Note: if using bash, use `-p` to indicate a prompt string, rather than the leading `?`
        read -s "?Enter Value for ''${1}: " secret

        ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
        security add-generic-password -U -a ''${USER} -D "environment variable" -s "''${1}" -w "''${secret}"
      }
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
