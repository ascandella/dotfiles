{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  xdg.configFile = {
    "television".source = ./files/television;
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
      -- Configure terraform-ls via the new vim.lsp.config() API
      -- (nvim-lspconfig's `require('lspconfig').*.setup` framework is
      -- deprecated in nvim-lspconfig v3). mason-lspconfig auto-enables
      -- installed servers, so we only need to register overrides here.
      local util = require('lspconfig.util')
      vim.lsp.config('terraformls', {
        -- Scope terraform-ls to the .tf file's own directory (the module
        -- boundary in terraform) so it doesn't index the whole monorepo.
        -- Large workspaces like monitoring-as-code freeze the UI on every
        -- keystroke when terraform-ls walks hundreds of .tf files rooted
        -- at the repo's .git.
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          on_dir(util.root_pattern('.terraform')(fname) or vim.fs.dirname(fname))
        end,
        workspace_required = false,
        init_options = {
          terraform = {
            path = "${pkgs.terraform.out}/bin/terraform",
          },
        },
        -- Semantic tokens are computed on every edit and are the usual
        -- source of UI stalls in large terraform workspaces. Treesitter
        -- already provides good highlighting.
        on_attach = function(client, bufnr)
          require('ai/lsp-shared').on_attach(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
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

      theme = Catppuccin Mocha
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

      # For Claude code
      keybind = shift+enter=text:\n
    '';
  };

  home = {
    file = {
      ".npmrc".text = ''
        update-notifier=false
        ${if config.my.caCert.enable then "cafile=${config.my.caCert.path}" else ""}
      '';
      ".editorconfig".source = ./files/editorconfig;
    };

    sessionVariables = {
      # Workaround issue on mac where it's trying to use ~/Library/Application Support/k9s
      K9S_CONFIG_DIR = "${config.xdg.configHome}/k9s";
    };
  };
}
