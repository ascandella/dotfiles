{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile = {
    "efm-langserver".source = ./files/efm-langserver;
    "selene".source = ./files/selene;
    "skhd".source = ./files/skhd;
    "stylua".source = ./files/stylua;
    "wezterm".source = ./files/wezterm;
    "yazi".source = ./files/yazi;
    "nvim/lua/ai/nix/tools.lua".text = ''
      vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'

      return {
        gcc = '${lib.getExe pkgs.gcc}';
      }
    '';
    "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.my.configDir}/modules/home/files/nvim/lazy-lock.json";
    "nvim" = {
      recursive = true;
      source = ./files/nvim/config;
    };
  };

  home.file = {
    ".npmrc".text = ''
      update-notifier=false
    '';
  };
}
