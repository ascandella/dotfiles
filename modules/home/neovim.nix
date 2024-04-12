{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = inputs.neovim-flake.packages.${pkgs.system}.neovim;

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
