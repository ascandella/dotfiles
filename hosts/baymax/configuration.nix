# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/roles/base.nix
      ../../modules/nixos/roles/podman.nix
      ../../modules/nixos/roles/users.nix
      ../../modules/nixos/roles/nvidia.nix
      ../../modules/nixos/roles/nas-mounts.nix
      ../../modules/common
      ../../modules/deploy
      ../../modules/plex
      ../../modules/torrenting
    ];

  # Bootloader.
  boot.loader = {
    timeout = 2;
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      configurationLimit = 5;
    };
  };

  networking.hostName = "baymax";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    # Configure keymap in X11
    # services.xserver = {
    #   xkb = {
    #     layout = "us";
    #     variant = "dvorak";
    #   };
    # };
  };
  # Configure console keymap
  console.keyMap = "dvorak";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nixos/roles/base.nix contains most of the base config

  # PROXMOOOOOX
  services.qemuGuest.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
