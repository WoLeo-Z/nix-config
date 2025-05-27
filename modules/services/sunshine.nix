{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.sunshine;
in
{
  options.modules.services.sunshine = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # hm.home.packages = with pkgs; [
    #   moonlight # Sunshine Client
    # ];
  };
}
