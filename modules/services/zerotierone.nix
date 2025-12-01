{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.zerotierone;
in
{
  options.modules.services.zerotierone = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
    };
  };
}
