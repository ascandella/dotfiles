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

    # Do each file individually so k9s can still write to other files/dirs here as my user
    "k9s/config.yaml".source = ./files/k9s/config.yaml;
    "k9s/aliases.yaml".source = ./files/k9s/aliases.yaml;
    "k9s/plugins.yaml".source = ./files/k9s/plugins.yaml;
    "k9s/skins".source = ./files/k9s/skins;
  };

  home = {
    file = {
      ".npmrc".text = ''
        update-notifier=false
      '';
    };

    sessionVariables = {
      # Workaround issue on mac where it's trying to use ~/Library/Application Support/k9s
      K9S_CONFIG_DIR = "${config.xdg.configHome}/k9s";
    };
  };
}
