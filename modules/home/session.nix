{ config, ... }:

{
  config = {
    home.sessionVariables = { DOTFILES_DIR = "${config.my.configDir}"; };
  };
}
