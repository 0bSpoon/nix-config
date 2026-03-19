{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;                   # Proprietary driver for better suspend/resume stability
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;  # Preserve VRAM on suspend to prevent display corruption
    nvidiaSettings = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}
