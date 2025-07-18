{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.mediamtx;
in
{
  options.modules.services.mediamtx = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.mediamtx = {
      enable = true;
      settings = {
        paths = {
          mystream = {
            source = "publisher";
          };
        };
      };
    };
  };
}
