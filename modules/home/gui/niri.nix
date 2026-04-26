{ pkgs, ... }:
let
  noArg = name: {
    action = {
      ${name} = [ ];
    };
  };
  action = name: value: {
    action = {
      ${name} = value;
    };
  };
  spawn = command: action "spawn" command;
  spawnSh = command: action "spawn-sh" command;
in
{
  programs.dank-material-shell = {
    enable = true;
    package = pkgs.dms-shell;
    quickshell.package = pkgs.quickshell;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
      includes.enable = false;
    };
  };

  programs.niri = {
    package = pkgs.niri;
    settings = {
      input = {
        keyboard = {
          xkb = { };
          numlock = true;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse.accel-speed = -0.7;
        trackpoint.enable = true;
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        always-center-single-column = true;

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width.proportion = 0.5;

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#878580";
          inactive.color = "#505050";
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#ffc87f";
          inactive.color = "#505050";
          urgent.color = "#9b0000";
        };

        shadow = {
          enable = true;
          softness = 20;
          spread = 8;
          offset = {
            x = 0;
            y = 8;
          };
          draw-behind-window = true;
          color = "#000000b0";
          inactive-color = "#00000080";
        };

        struts = { };
      };

      workspaces = {
        browser = { };
        standby = { };
      };

      spawn-at-startup = [
        { argv = [ "google-chrome-stable" ]; }
        { argv = [ "keepassxc" ]; }
        { argv = [ "spotify" ]; }
        {
          sh = "niri msg action focus-workspace 3 && niri msg action move-workspace-up && exec ghostty -e tmux";
        }
      ];

      hotkey-overlay = { };
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      environment.NIXOS_OZONE_WL = "1";

      cursor = {
        theme = "everforest-cursors";
        size = 24;
        hide-when-typing = true;
        hide-after-inactive-ms = 1000;
      };

      animations = { };

      window-rules = [
        {
          matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
          default-column-width = { };
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              at-startup = true;
              app-id = "^google-chrome(-stable)?$";
            }
          ];
          open-on-workspace = "browser";
        }
        {
          matches = [
            {
              at-startup = true;
              app-id = "^org\\.keepassxc\\.KeePassXC$";
            }
            {
              at-startup = true;
              app-id = "(?i)^spotify$";
            }
          ];
          open-on-workspace = "standby";
          open-focused = false;
        }
      ];

      binds = {
        "Mod+Shift+Slash" = noArg "show-hotkey-overlay";

        "Mod+T" = (spawn "ghostty") // {
          "hotkey-overlay".title = "Open a Terminal: ghostty";
        };
        "Mod+D" = (spawn "fuzzel") // {
          "hotkey-overlay".title = "Run an Application: fuzzel";
        };
        "Super+Alt+S" = (spawnSh "pkill orca || exec orca") // {
          "allow-when-locked" = true;
          "hotkey-overlay".hidden = true;
        };

        "Mod+O" = (noArg "toggle-overview") // {
          repeat = false;
        };
        "Mod+Q" = (noArg "close-window") // {
          repeat = false;
        };

        "Mod+Left" = noArg "focus-column-left";
        "Mod+Down" = noArg "focus-window-down";
        "Mod+Up" = noArg "focus-window-up";
        "Mod+Right" = noArg "focus-column-right";
        "Mod+H" = noArg "focus-column-left";
        "Mod+J" = noArg "focus-window-down";
        "Mod+K" = noArg "focus-window-up";
        "Mod+L" = noArg "focus-column-right";

        "Mod+Ctrl+Left" = noArg "move-column-left";
        "Mod+Ctrl+Down" = noArg "move-window-down";
        "Mod+Ctrl+Up" = noArg "move-window-up";
        "Mod+Ctrl+Right" = noArg "move-column-right";
        "Mod+Ctrl+H" = noArg "move-column-left";
        "Mod+Ctrl+J" = noArg "move-window-down";
        "Mod+Ctrl+K" = noArg "move-window-up";
        "Mod+Ctrl+L" = noArg "move-column-right";

        "Mod+Home" = noArg "focus-column-first";
        "Mod+End" = noArg "focus-column-last";
        "Mod+Ctrl+Home" = noArg "move-column-to-first";
        "Mod+Ctrl+End" = noArg "move-column-to-last";

        "Mod+Shift+Left" = noArg "focus-monitor-left";
        "Mod+Shift+Down" = noArg "focus-monitor-down";
        "Mod+Shift+Up" = noArg "focus-monitor-up";
        "Mod+Shift+Right" = noArg "focus-monitor-right";
        "Mod+Shift+H" = noArg "focus-monitor-left";
        "Mod+Shift+J" = noArg "focus-monitor-down";
        "Mod+Shift+K" = noArg "focus-monitor-up";
        "Mod+Shift+L" = noArg "focus-monitor-right";

        "Mod+Shift+Ctrl+Left" = noArg "move-column-to-monitor-left";
        "Mod+Shift+Ctrl+Down" = noArg "move-column-to-monitor-down";
        "Mod+Shift+Ctrl+Up" = noArg "move-column-to-monitor-up";
        "Mod+Shift+Ctrl+Right" = noArg "move-column-to-monitor-right";
        "Mod+Shift+Ctrl+H" = noArg "move-column-to-monitor-left";
        "Mod+Shift+Ctrl+J" = noArg "move-column-to-monitor-down";
        "Mod+Shift+Ctrl+K" = noArg "move-column-to-monitor-up";
        "Mod+Shift+Ctrl+L" = noArg "move-column-to-monitor-right";

        "Mod+Page_Down" = noArg "focus-workspace-down";
        "Mod+Page_Up" = noArg "focus-workspace-up";
        "Mod+U" = noArg "focus-workspace-down";
        "Mod+I" = noArg "focus-workspace-up";
        "Mod+Ctrl+Page_Down" = noArg "move-column-to-workspace-down";
        "Mod+Ctrl+Page_Up" = noArg "move-column-to-workspace-up";
        "Mod+Ctrl+U" = noArg "move-column-to-workspace-down";
        "Mod+Ctrl+I" = noArg "move-column-to-workspace-up";

        "Mod+Shift+Page_Down" = noArg "move-workspace-down";
        "Mod+Shift+Page_Up" = noArg "move-workspace-up";
        "Mod+Shift+U" = noArg "move-workspace-down";
        "Mod+Shift+I" = noArg "move-workspace-up";

        "Mod+WheelScrollDown" = (noArg "focus-workspace-down") // {
          "cooldown-ms" = 150;
        };
        "Mod+WheelScrollUp" = (noArg "focus-workspace-up") // {
          "cooldown-ms" = 150;
        };
        "Mod+Ctrl+WheelScrollDown" = (noArg "move-column-to-workspace-down") // {
          "cooldown-ms" = 150;
        };
        "Mod+Ctrl+WheelScrollUp" = (noArg "move-column-to-workspace-up") // {
          "cooldown-ms" = 150;
        };

        "Mod+WheelScrollRight" = noArg "focus-column-right";
        "Mod+WheelScrollLeft" = noArg "focus-column-left";
        "Mod+Ctrl+WheelScrollRight" = noArg "move-column-right";
        "Mod+Ctrl+WheelScrollLeft" = noArg "move-column-left";

        "Mod+Shift+WheelScrollDown" = noArg "focus-column-right";
        "Mod+Shift+WheelScrollUp" = noArg "focus-column-left";
        "Mod+Ctrl+Shift+WheelScrollDown" = noArg "move-column-right";
        "Mod+Ctrl+Shift+WheelScrollUp" = noArg "move-column-left";

        "Mod+1" = action "focus-workspace" 1;
        "Mod+2" = action "focus-workspace" 2;
        "Mod+3" = action "focus-workspace" 3;
        "Mod+4" = action "focus-workspace" 4;
        "Mod+5" = action "focus-workspace" 5;
        "Mod+6" = action "focus-workspace" 6;
        "Mod+7" = action "focus-workspace" 7;
        "Mod+8" = action "focus-workspace" 8;
        "Mod+9" = action "focus-workspace" 9;
        "Mod+Ctrl+1" = action "move-column-to-workspace" 1;
        "Mod+Ctrl+2" = action "move-column-to-workspace" 2;
        "Mod+Ctrl+3" = action "move-column-to-workspace" 3;
        "Mod+Ctrl+4" = action "move-column-to-workspace" 4;
        "Mod+Ctrl+5" = action "move-column-to-workspace" 5;
        "Mod+Ctrl+6" = action "move-column-to-workspace" 6;
        "Mod+Ctrl+7" = action "move-column-to-workspace" 7;
        "Mod+Ctrl+8" = action "move-column-to-workspace" 8;
        "Mod+Ctrl+9" = action "move-column-to-workspace" 9;

        "Mod+BracketLeft" = noArg "consume-or-expel-window-left";
        "Mod+BracketRight" = noArg "consume-or-expel-window-right";
        "Mod+Alt+Comma" = noArg "consume-window-into-column";
        "Mod+Period" = noArg "expel-window-from-column";

        "Mod+R" = noArg "switch-preset-column-width";
        "Mod+Shift+R" = noArg "switch-preset-window-height";
        "Mod+Ctrl+R" = noArg "reset-window-height";
        "Mod+Z" = noArg "maximize-window-to-edges";
        "Mod+Shift+Z" = noArg "fullscreen-window";
        "Mod+Alt+Z" = noArg "expand-column-to-available-width";
        "Mod+C" = noArg "center-column";
        "Mod+Ctrl+C" = noArg "center-visible-columns";
        "Mod+Minus" = action "set-column-width" "-10%";
        "Mod+Equal" = action "set-column-width" "+10%";
        "Mod+Shift+Minus" = action "set-window-height" "-10%";
        "Mod+Shift+Equal" = action "set-window-height" "+10%";

        "Mod+Alt+V" = noArg "toggle-window-floating";
        "Mod+Shift+V" = noArg "switch-focus-between-floating-and-tiling";

        "Mod+W" = noArg "toggle-column-tabbed-display";

        "Mod+Shift+S" = noArg "screenshot";
        "Ctrl+Print" = noArg "screenshot-screen";
        "Alt+Print" = noArg "screenshot-window";

        "Mod+Escape" = (noArg "toggle-keyboard-shortcuts-inhibit") // {
          "allow-inhibiting" = false;
        };
        "Mod+Shift+E" = noArg "quit";
        "Ctrl+Alt+Delete" = noArg "quit";
        "Mod+Shift+P" = noArg "power-off-monitors";
      };
    };
  };
}
