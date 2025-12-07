{
  username,
  pkgs,
  homeDirectory,
  hostname,
  inputs,
  system,
  ...
}:

{
  imports = [
    ./shell.nix
    ../home-options
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
          system
          hostname
          ;
      }
    )
    (
      { lib, config, ... }:
      import ./zellij.nix {
        inherit
          inputs
          lib
          pkgs
          config
          system
          ;
      }
    )
    ./session.nix
  ];

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
      awscli2
      bat
      btop
      bun
      cosign # OCI container signing
      clock-rs
      curl
      delta
      difftastic # treesitter-aware diffs
      eza # better ls
      fd # better find
      fzf
      television # better fzf
      gnupg
      home-manager
      htop
      just
      magic-wormhole
      minio-client
      most
      nixfmt-rfc-style
      nix-tree # show why a nix package is installed
      nixd
      ntfy-sh # ntfy client
      ripgrep
      scc # count lines of code
      spaceship-prompt
      ssm-session-manager-plugin # for awscli
      vault
      yq # yaml jq
      zellij
      inputs.zjstatus.packages.${system}.default
      zoxide

      # nix tools
      nix-search-cli
      nix-search-tv

      ## Programming languages

      exercism # exercism.org -- learn languages

      # Go
      go

      # Rust
      rustup
      bacon # newer watcher
      cargo-nextest # better test runner

      # Node
      fnm
      pnpm

      # GitHub CLI, used with Octo
      gh

      # Gitlab CLI
      glab

      # Kubernetes
      argocd # manage argo
      k9s
      kubectl
      kubelogin-oidc # OIDC login for k8s api (e.g. authentik)
      kubernetes-helm
      kubeseal # sealed secrets
      kustomize
      pv-migrate
      talosctl
      cilium-cli # CNI
      hubble # Cilium observability
      # Kubernetes development
      kind # Kubernetes in Docker
      velero # backup and restore k8s clusters

      # Python
      uv
      python313

      # Terraform
      tenv # newer tfenv
      tflint # linting

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
  };
}
