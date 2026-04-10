{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    commit-mono
    corefonts
    ibm-plex
    ipafont
    jetbrains-mono
    monaspace
    nerd-fonts.commit-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    antialias = true;
    hinting = {
      enable = true;
      autohint = false;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    defaultFonts = {
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
      ];
    };
  };
}
