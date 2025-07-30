{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.safeeyes;
in
{
  options.modules.services.safeeyes = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.safeeyes = {
      enable = true;
    };
  };
}
