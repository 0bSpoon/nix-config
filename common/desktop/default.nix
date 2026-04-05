{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xwayland-satellite # X11 app support on Wayland
    fuzzel # app launcher
    wl-clipboard # clipboard manager
    nautilus # file manager, required for file chooser dialogs
    noctalia-shell
  ];

  home.pointerCursor = {
    name = "everforest-cursors";
    package = pkgs.everforest-cursors;
    size = 24;
    gtk.enable = true;
  };

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome # screencasting support
      pkgs.xdg-desktop-portal-gtk # default fallback portal
    ];
    config.niri.default = [ "gnome" "gtk" ];
  };

  # Notification daemon
  services.mako.enable = true;

  # Authentication agent for root privilege requests
  systemd.user.services.polkit-kde-agent = {
    Unit = {
      Description = "PolicyKit Authentication Agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
