{ ... }:
{
  imports = [
    ../../modules/nixos/base.nix
    ../../modules/nixos/sops.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/fonts.nix
  ];
}
