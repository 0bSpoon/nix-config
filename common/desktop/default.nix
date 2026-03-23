{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xwayland-satellite
    fuzzel
    wl-clipboard
  ];

  # xdg.configFile."niri/config.kdl".source = ./config.kdl;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.niri.default = [ "gnome" "gtk" ];
  };
}
