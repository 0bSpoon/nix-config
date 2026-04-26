{ ... }:
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
    autoEnable = false;
    polarity = "dark";
    base16Scheme = schemes.${theme};
  };
}
