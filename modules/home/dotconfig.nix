{ config, lib, pkgs, inputs, ... }: {
  xdg.configFile = {
    "efm-langserver".source = ./files/efm-langserver;
    "selene".source = ./files/selene;
    "skhd".source = ./files/skhd;
    "stylua".source = ./files/stylua;
    "yabai".source = ./files/yabai;
    "yazi".source = ./files/yazi;
    "nvim/lua/ai/nix/tools.lua".text = ''
      vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'

      return {
        gcc = '${lib.getExe pkgs.gcc}';
      }
    '';
    "nvim/foo".text = ''
      ${config.my.configDir}
    '';
    "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.my.configDir}/modules/home/files/nvim/lazy-lock.json";
    "nvim" = {
      recursive = true;
      source = ./files/nvim/config;
    };
    "zellij".source = ./files/zellij;
  };

  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Application Support/Übersicht/widgets/simple-bar".source =
      inputs.simple-bar-src.outPath;
    ".ignore".source = ./files/ignore;
    ".pylintrc".source = ./files/.pylintrc;
    ".luacheckrc".source = ./files/.luacheckrc;
  };
}
