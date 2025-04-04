{
  config,
  lib,
  pkgs,
  hostname,
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
    # Bypass tenv's `terraform` for terraform-ls otherwise it can't format
    "nvim/lua/ai/nix/terraformls.lua".text = ''
      local lspinstall = require('ai/_lspinstall')
      local lspconfig = require('lspconfig')
      lspconfig.terraformls.setup(lspinstall.make_config({
        init_options = {
          terraform = {
            path = "${pkgs.terraform.out}/bin/terraform",
          }
        }
      }))
    '';
    "nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.my.configDir}/modules/home/files/nvim/lazy-lock.json";
    "nvim" = {
      recursive = true;
      source = ./files/nvim/config;
    };

    # Do each file individually so k9s can still write to other files/dirs here as my user
    "k9s/config.yaml".source = ./files/k9s/config.yaml;
    "k9s/aliases.yaml".source = ./files/k9s/aliases.yaml;
    "k9s/plugins.yaml".source = ./files/k9s/plugins.yaml;
    "k9s/skins".source = ./files/k9s/skins;
    "ghostty/config".text = ''
      cursor-style = block
      cursor-style-blink = false

      # Otherwise zsh has a blinking insert cursor
      shell-integration-features = no-cursor

      background-opacity = 0.9
      background-blur-radius = 20

      font-size = ${if hostname == "studio" then "18" else "14"}
      font-family = BerkeleyMonoVariable Nerd Font Mono

      mouse-hide-while-typing = true

      theme = catppuccin-mocha
      macos-titlebar-style = hidden
      macos-option-as-alt = true
      macos-window-shadow = false
      macos-icon = glass

      # For Zellij
      keybind = alt+left=unbind
      keybind = alt+right=unbind
      keybind = ctrl+tab=unbind

      macos-auto-secure-input = true
      macos-secure-input-indication = true

      window-padding-x = 6
      window-padding-y = 4
    '';
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
