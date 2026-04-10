{ homeDirectory, username, ... }:
{
  imports = [
    ./sops.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gh-dash.enable = true;
  programs.lazygit.enable = true;
  programs.fzf.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
  };

  programs.codex.enable = true;
  programs.opencode.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    shellAliases = {
      ll = "ls -alh --color=auto";
      la = "ls -A --color=auto";
      l = "ls -CF --color=auto";
      cc = "env -u TMUX claude";
      ccd = "env -u TMUX claude --dangerously-skip-permissions";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
  };
}
