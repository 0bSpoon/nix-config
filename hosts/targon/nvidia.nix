{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;                    # RTX 4070 Ti supports open kernel modules
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false; # Desktop, no power management needed
    nvidiaSettings = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}
