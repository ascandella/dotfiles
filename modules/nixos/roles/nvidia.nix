{ config, pkgs, ... }:
{

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # Enable auto-generation of CDI for nvidia
    nvidia-container-toolkit.enable = true;

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
  ];

  services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470" etc.
}
