{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = pkgs.config;
  };
in {
  programs.vscode = {
    enable = true;
    package = unstable.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        anthropic.claude-code
        jnoortheen.nix-ide
      ];
      userSettings = {
        "terminal.integrated.sendKeybindingsToShell" = true;
        "editor.fontFamily" = "'CommitMono Nerd Font', 'IBM Plex Sans JP Text', monospace";
        "terminal.integrated.fontFamily" = "'CommitMono Nerd Font', 'IBM Plex Sans JP Text', monospace";
        "chat.disableAIFeatures" = true;
        "terminal.integrated.enablePersistentSessions" = false;
      };
    };
  };
}
