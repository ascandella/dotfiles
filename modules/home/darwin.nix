{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.keybindings = {
      # https://gist.github.com/trusktr/1e5e516df4e8032cbc3d
      "~b" = "moveWordBackward:";
      "~f" = "moveWordForward:";
    };

    home = {
      sessionPath = [ "/opt/homebrew/bin/" ];
      packages = with pkgs; [ jira-cli-go ];

      file = {
        ".gnupg/gpg-agent.conf".text = ''
          # Enables GPG to find gpg-agent
          use-standard-socket

          # Connects gpg-agent to the OSX keychain via the brew-installed
          # pinentry program from GPGtools. This is the OSX 'magic sauce',
          # allowing the gpg key's passphrase to be stored in the login
          # keychain, enabling automatic key signing.
          pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
        '';
        ".gnupg/gpg.conf".text = ''
          use-agent
          # This silences the "you need a passphrase" message once the passphrase handling is all set.
          # Use at your own discretion - may prevent the successful interactive use of some operations.
          # It is working fine for my use cases though.
          batch
        '';
      };
    };

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

      jiraissues = "jira issue list -a$(jira me)";
      inprog = "jiraissues -s 'In Progress' --plain --columns KEY,SUMMARY --no-headers";

      resetdns = "sudo dscacheutil -flushcache ; sudo killall -HUP mDNSResponder";
    };

    home.file = {
      "Library/Application Support/Übersicht/widgets/simple-bar".source = inputs.simple-bar-src.outPath;
      ".ignore".source = ./files/ignore;
      ".pylintrc".source = ./files/.pylintrc;
      ".luacheckrc".source = ./files/.luacheckrc;
    };
  };
}
