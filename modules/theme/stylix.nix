{ pkgs, ... }:
let
  theme = "flexoki-dark";

  schemes = {
    flexoki-dark = ./schemes/flexoki-dark.yaml;
    rose-pine-main = ./schemes/rose-pine-main.yaml;
    gruvbox-material-hard-dark = ./schemes/gruvbox-material-hard-dark.yaml;
  };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = schemes.${theme};
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.blex-mono;
        name = "BlexMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans JP Text";
      };
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK JP";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
