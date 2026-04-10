{ config, pkgs, ... }:
{
  time.hardwareClockInLocalTime = true; # Prevent clock drift with Windows
  boot.supportedFilesystems = [ "ntfs" ]; # Access Windows drives
}
