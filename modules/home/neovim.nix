{ pkgs, ... }:

{
  programs.neovim = {
    extraPackages = with pkgs; [
      sqlite
      lua-language-server
      stylua
      prettierd
    ];
  };
}
