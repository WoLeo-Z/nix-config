{ lib, config, ... }:

with lib;
let
  cfg = config.modules.template;
in
{
  options.modules.template = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {

  };
}
