{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.terminal.kitty;
in
{
  options.modules.desktop.apps.terminal.kitty = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.kitty = {
        enable = true;
        enableGitIntegration = true;
        settings = {
          window_padding_width = "3 5";
          # background_blur = 64; # not working

          cursor_shape = "block";
          cursor_trail = 3;
          cursor_trail_decay = "0.1 0.3";
          cursor_trail_start_threshold = 0;
          shell_integration = "no-cursor";
        };
        keybindings = {
          # Switch Ctrl+C & Ctrl+Shift+C
          "ctrl+c" = "copy_to_clipboard";
          "ctrl+v" = "paste_from_clipboard";
          "ctrl+shift+c" = "send_text all \\u0003"; # send SIGINT
        };

        themeFile = "Catppuccin-Mocha";
        font = {
          inherit (config.stylix.fonts.monospace) package name;
          size = config.stylix.fonts.sizes.terminal;
        };
        settings.background_opacity = toString config.stylix.opacity.terminal;
      };

      # stylix.targets.kitty.enable = true;

      # Fix: E558: Terminal entry not found in terminfo
      # 'xterm-kitty' not known.
      programs.ssh.matchBlocks = {
        "*" = {
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };
  };
}
