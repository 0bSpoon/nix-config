{ ... }:
{
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      window-decoration = "none";
      mouse-hide-while-typing = true;
    };
  };
}
