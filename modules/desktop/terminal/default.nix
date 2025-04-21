{ lib, config, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.terminal;
in {
  options.modules.desktop.terminal = {
    default = mkOption {
      type = types.enum [ "foot" "kitty" ];
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
