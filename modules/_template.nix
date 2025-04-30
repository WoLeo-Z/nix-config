{ lib, config, ... }:

with lib;
let
  cfg = config.modules.template;
in
{
  options.modules.template = {
    enable = mkEnableOption "Enable Template";
  };

  config = mkIf cfg.enable {
    
  };
}
