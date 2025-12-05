{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.syncthing;
in
{
  options.modules.services.syncthing = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.user.name;
      group = config.user.group;
      configDir = "${config.home'.configDir}/syncthing";
      dataDir = "${config.home'.dataDir}/syncthing";
    };
  };
}
