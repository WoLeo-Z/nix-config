{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.safeeyes;
in
{
  options.modules.services.safeeyes = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    # we start safeeyes in window manager
    # to fix "safeeyes: couldn't open display"
    #
    # services.safeeyes = {
    #   enable = true;
    # };

    environment.systemPackages = with pkgs; [ safeeyes ];
  };
}
