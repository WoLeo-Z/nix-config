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

    # Important note:
    # If you don't use the Sway module (programs.sway.enable)
    # you need to set "security.pam.services.swaylock = {};" manually.
    security.pam.services.swaylock = { };
  };
}
