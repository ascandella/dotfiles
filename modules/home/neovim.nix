{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      sqlite
      lua-language-server
      stylua
      prettierd
      gcc

      nodejs_20 # copilot
      nodePackages.npm # mason
      nodePackages.pyright
      unzip # mason
      gnumake # mason
    ];
  };
}
