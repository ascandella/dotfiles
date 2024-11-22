{
  username,
  pkgs,
  homeDirectory,
  inputs,
  system,
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
          system
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
      age # encryption
      argocd # manage argo
      awscli2
      bat
      btop
      bun
      curl
      delta
      eza # better ls
      fzf
      htop
      just
      k9s
      kubectl
      kubernetes-helm
      kustomize
      magic-wormhole
      minio-client
      most
      nixfmt-rfc-style
      ngrok
      ntfy-sh # ntfy client
      ripgrep
      scc # count lines of code
      spaceship-prompt
      ssm-session-manager-plugin # for awscli
      wezterm # superior terminal
      zellij
      zoxide

      # nix tools
      nix-search-cli

      ## Programming languages

      # Go
      go

      # Rust
      rustup
      bacon # newer watcher

      # Node
      fnm
      pnpm

      # GitHub CLI, used with Octo
      gh

      # Language servers (for Neovim)
      efm-langserver
      gopls
      shellcheck
      terraform-ls
      tflint
      shfmt # shell formatting
      ruff # python formatting
    ];

    home.shellAliases = {
      reload-home-manager-config = "home-manager switch && exec zsh -L";
    };

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
