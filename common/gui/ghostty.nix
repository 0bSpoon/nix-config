{ ... }:

{
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      font-family = ["CommitMono Nerd Font" "IBM Plex Sans JP"];
      theme = "Everforest Dark Hard";
      window-decoration = "none";
      mouse-hide-while-typing = true;
    };
  };
}
