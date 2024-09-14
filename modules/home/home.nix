{
  username,
  pkgs,
  homeDirectory,
  inputs,
  ...
}:

{
  imports = [
    ./shell.nix
    ./shell-keybindings.nix
    ({ pkgs, ... }: import ./neovim.nix { inherit pkgs inputs; })
    { my.configDir = "${homeDirectory}/src/dotfiles"; }
    (
      { lib, ... }:
      import ./darwin.nix {
        inherit
          lib
          pkgs
          homeDirectory
          inputs
          ;
      }
    )
    ./git.nix
    (
      { lib, config, ... }:
      import ./dotconfig.nix {
        inherit
          inputs
          lib
          pkgs
          config
          ;
      }
    )
    ({ config, ... }: import ./session.nix { inherit config; })
  ];

  options.my = {
    configDir = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "/etc/nixos";
      description = "Location of the nix config directory (this repo)";
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home = {
      inherit username homeDirectory;

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      stateVersion = "23.11"; # Please read the comment before changing.
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      awscli2
      bat
      btop
      bun
      curl
      delta
      eza # better ls
      fnm
      fzf
      go
      htop
      just
      k9s
      kubectl
      kustomize
      magic-wormhole
      most
      nixfmt-rfc-style
      ngrok
      ripgrep
      rustup
      spaceship-prompt
      ssm-session-manager-plugin # for awscli
      wezterm # superior terminal
      zellij
      zoxide

      gh # GitHub CLI, used with Octo

      # Language servers (for Neovim)
      efm-langserver
      gopls
      shellcheck
      terraform-ls
      tflint
      shfmt # shell formatting
      ruff # python formatting

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    home.shellAliases = {
      reload-home-manager-config = "home-manager switch && exec zsh -L";
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/aiden/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      EDITOR = "nvim";
      CLICOLOR = "1";
      GREP_OPTIONS = "--color=always";
      GREP_COLOR = "1;35;40";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
