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
    nerd-fonts.blex-mono
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
  };
}
