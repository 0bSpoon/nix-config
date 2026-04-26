{ config, homeDirectory, inputs, pkgs, username, ... }:
let
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./sops.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  gtk.gtk4.theme = config.gtk.theme;

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

  programs.opencode = {
    enable = true;
    package = llmAgentsPkgs.opencode;
  };

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
      cc = "CLAUDE_CODE_TMUX_TRUECOLOR=1 claude";
      ccc = "CLAUDE_CODE_TMUX_TRUECOLOR=1 ANTHROPIC_BASE_URL=http://127.0.0.1:8317 ANTHROPIC_AUTH_TOKEN=sk-dummy ANTHROPIC_DEFAULT_OPUS_MODEL='gpt-5.4(high)' ANTHROPIC_DEFAULT_SONNET_MODEL='gpt-5.4(medium)' ANTHROPIC_DEFAULT_HAIKU_MODEL='gpt-5.4(low)' claude";
      ccd = "CLAUDE_CODE_TMUX_TRUECOLOR=1 claude --dangerously-skip-permissions";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
  };
}
