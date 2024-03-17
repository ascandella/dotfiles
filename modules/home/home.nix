{ username, pkgs, homeDirectory, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./shell-keybindings.nix
    ./darwin.nix
    ./git.nix
    ({ lib, ... }: import ./dotconfig.nix {
      inherit inputs lib pkgs;
    })
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    awscli2
    bat
    bun
    delta
    fnm
    fzf
    go
    htop
    kubectl
    most
    neovim
    ngrok
    ripgrep
    rustup
    spaceship-prompt
    ssm-session-manager-plugin
    zellij
    zimfw
    zoxide

    # Language servers (for Neovim)
    efm-langserver
    gopls
    shellcheck
    terraform-ls
    tflint

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

  programs.zsh = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
