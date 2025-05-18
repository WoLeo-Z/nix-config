{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.media.cavalier;
in
{
  options.modules.desktop.apps.media.cavalier = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.cavalier = {
        enable = true;
        settings.general = {
          ShowControls = true;
          ColorProfiles = [
            {
              Name = "Default";
              FgColors = [
                "#ff00ffff"
                "#ff62a0ea"
                "#ff6b72e6"
              ];
              BgColors = [ "#ff1e1e2e" ];
              Theme = 1;
            }
          ];
          ActiveProfile = mkForce 1;
        };
      };

      stylix.targets.cavalier.enable = true;
    };
  };
}
