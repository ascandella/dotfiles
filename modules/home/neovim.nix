{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      sqlite
      lua-language-server
      lua54Packages.luacheck
      stylua
      eslint_d
      yamllint
      prettierd
      gcc

      nodejs_20 # copilot
      nodePackages.npm # mason
      pyright
      unzip # mason
      gnumake # mason
    ];
  };
}
