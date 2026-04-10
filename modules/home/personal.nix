{ pkgs, ... }:
{
  imports = [
    ./gui/obsidian.nix
  ];

  home.packages = [ pkgs.spotify ];

  programs.spotify-player.enable = true;
}
