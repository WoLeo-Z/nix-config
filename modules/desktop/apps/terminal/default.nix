{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.terminal;
in
{
  options.modules.desktop.apps.terminal = {
    default = mkOption {
      type = types.enum [
        "alacritty"
        "foot"
        "kitty"
      ];
      default = null;
      description = "Default terminal emulator";
    };
  };

  config = mkIf (cfg.default != null) {
    environment.variables = {
      TERMINAL = cfg.default;
    };
  };
}
