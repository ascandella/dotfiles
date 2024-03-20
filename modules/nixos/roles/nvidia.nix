{ environment, config, pkgs, ... }:
{

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    nvidia-podman
    nvidia-container-toolkit
  ];

  # Unstable only; enable auto-generation of CDI for nvidia
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470 etc.

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
