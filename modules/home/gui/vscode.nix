{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
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
