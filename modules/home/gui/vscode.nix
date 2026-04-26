{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "terminal.integrated.sendKeybindingsToShell" = true;
        "chat.disableAIFeatures" = true;
        "terminal.integrated.enablePersistentSessions" = false;
      };
    };
  };
}
