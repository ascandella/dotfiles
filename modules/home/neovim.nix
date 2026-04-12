{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = true;

    extraPackages = with pkgs; [
      sqlite
      lua-language-server
      lua54Packages.luacheck
      stylua
      eslint_d
      yamllint
      prettierd
      gcc

      pyright
      unzip # mason
      gnumake # mason
    ];
  };
}
