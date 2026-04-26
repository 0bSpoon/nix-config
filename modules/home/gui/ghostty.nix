{ ... }:
{
  stylix.targets.ghostty = {
    enable = true;
    fonts.enable = false;
  };

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      font-family = [
        "BlexMono Nerd Font"
        "IBM Plex Sans JP"
      ];
      window-decoration = "none";
      mouse-hide-while-typing = true;
    };
  };
}
