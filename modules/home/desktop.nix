{ pkgs, ... }:
{
  imports = [
    ./gui/vscode.nix
    ./gui/ghostty.nix
  ];

  home.packages = with pkgs; [
    fuzzel
    nautilus
    noctalia-shell
    quickshell
    wl-clipboard
    xwayland-satellite
  ];

  home.pointerCursor = {
    name = "everforest-cursors";
    package = pkgs.everforest-cursors;
    size = 24;
    gtk.enable = true;
  };

  xdg.autostart.enable = true;
  xdg.configFile."niri/config.kdl".source = ./gui/assets/niri/config.kdl;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.niri.default = [
      "gnome"
      "gtk"
    ];
  };

  services.mako.enable = true;

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
    Install.WantedBy = [ "graphical-session.target" ];
  };

  programs.keepassxc = {
    enable = true;
    autostart = true;
  };

  programs.google-chrome.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-mozc-ut ];
      settings.globalOptions = {
        "Hotkey/TriggerKeys"."0" = "Muhenkan";
        Behavior = {
          resetStateWhenFocusIn = "All";
          ShareInputState = "All";
        };
      };
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "mozc";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "mozc";
          Layout = "";
        };
      };
    };
  };
}
