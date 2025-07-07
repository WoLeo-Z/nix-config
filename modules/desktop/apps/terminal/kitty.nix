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
          # dim_opacity = 0.8; # increase dim opacity # FIXME: not working
          cursor_trail = 3;
        };
        keybindings = {
          # Switch Ctrl+C & Ctrl+Shift+C
          "ctrl+c" = "copy_to_clipboard";
          "ctrl+v" = "paste_from_clipboard";
          "ctrl+shift+c" = "send_text all \\u0003"; # send SIGINT
        };
      };

      stylix.targets.kitty.enable = true;
    };
  };
}
