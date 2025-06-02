{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.terminal.alacritty;
in
{
  options.modules.desktop.apps.terminal.alacritty = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.alacritty = {
        enable = true;
        settings = {
          env = {
            TERM = "xterm-256color";
          };
          cursor = {
            style = {
              shape = "Block";
              blinking = "Off";
            };
          };
          font = {
            size = 12;
            # Managed by stylix
            # normal = {
            #   family = "JetBrainsMono Nerd Font";
            # };
          };
          mouse.hide_when_typing = true;
          keyboard.bindings = [
            # Switch interrupt and copy
            {
              key = "C";
              mods = "Control|Shift";
              chars = "\\u0003"; # \u0003
            }
            {
              key = "C";
              mods = "Control";
              action = "Copy";
            }
            {
              key = "V";
              mods = "Control";
              action = "Paste";
            }
          ];
          window = {
            dynamic_padding = true;
            padding = {
              x = 5;
              y = 3;
            };
          };
        };
      };

      stylix.targets.alacritty.enable = true;
    };
  };
}
