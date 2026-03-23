{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = pkgs.config;
  };
in {
  programs.claude-code = {
    enable = true;
    package = unstable.claude-code;
  };
}
