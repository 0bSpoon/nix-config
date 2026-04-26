{ pkgs, ... }:
{
  imports = [
    ./gui/niri.nix
    ./gui/vscode.nix
    ./gui/ghostty.nix
  ];

  home.packages = with pkgs; [
    fuzzel
    nautilus
    wl-clipboard
    xwayland-satellite
  ];

  home.pointerCursor = {
    name = "everforest-cursors";
    package = pkgs.everforest-cursors;
    size = 24;
    gtk.enable = true;
  };

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

  programs.keepassxc = {
    enable = true;
    autostart = false;
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
