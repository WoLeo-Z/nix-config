{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swaylock;
in
{
  options.modules.desktop.swaylock = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.swaylock = {
        enable = true;
      };

      stylix.targets.swaylock.enable = true;
    };
  };
}
