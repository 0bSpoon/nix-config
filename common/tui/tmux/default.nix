{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";

    extraConfig = ''
      set -as terminal-features ",xterm-ghostty:RGB"
      set -g focus-events on
      set -g set-clipboard on

      # ペイン番号を 1 始まりに
      setw -g pane-base-index 1
      set -g renumber-windows on

      # === コピーモード (vi) ===
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi C-v send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"

      # === ペイン操作 ===
      # 分割 (カレントディレクトリを引き継ぐ)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # ペイン移動 (矢印キー)
      bind Left select-pane -L
      bind Down select-pane -D
      bind Up select-pane -U
      bind Right select-pane -R

      # ペインリサイズ (矢印キー)
      bind -r M-Left resize-pane -L 5
      bind -r M-Down resize-pane -D 5
      bind -r M-Up resize-pane -U 5
      bind -r M-Right resize-pane -R 5

      # === ペインボーダー ===
      set -g pane-border-style "fg=colour238"
      set -g pane-active-border-style "fg=cyan"
      set -g pane-border-lines heavy
      set -g pane-border-status top
      set -g pane-border-format " #{pane_index}: #{pane_current_command} "
      set -g pane-border-indicators off

      # === ステータスバー ===
      set -g status-position bottom
      set -g status-style "bg=default,fg=white"
      set -g status-left "#[bold]#S "
      set -g status-right "%H:%M"
      set -g status-left-length 20
    '';
  };
}
