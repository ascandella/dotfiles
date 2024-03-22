{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # utilities
    bc
    pv
    zsh
    dmidecode
    # monitoring
    htop
    iotop
    # dev tools
    jq
    ripgrep
    zellij
    sqlite
    delta
    # security
    gnupg
    pinentry-curses
    # networking
    wget
    curl
    iperf
    dnsutils
  ];
  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellInit = ''
      bindkey -e
    '';
    shellAliases = {
      g = "git";
    };
  };
  users.defaultUserShell = pkgs.zsh;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedTCPPortRanges = [
      { from = 5201; to = 5210; }
    ];
  };
}
