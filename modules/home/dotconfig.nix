{ lib, pkgs, inputs, ... }:
{
  xdg.configFile = {
    "efm-langserver".source = ./files/efm-langserver;
    "selene".source = ./files/selene;
    "skhd".source = ./files/skhd;
    "stylua".source = ./files/stylua;
    "yabai".source = ./files/yabai;
    "yazi".source = ./files/yazi;
    "nvim".source = ./files/nvim;
    "zellij".source = ./files/zellij;
    ".ignore".source = ./files/ignore;
    ".pylintrc".source = ./files/.pylintrc;
    ".stylua.toml".source = ./files/.stylua.toml;
  };
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Application Support/Übersicht/widgets/simple-bar".source = inputs.simple-bar-src.outPath;
  };
}
