{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.xiu;
in
{
  options.modules.services.xiu = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    systemd.services.xiu = {
      description = "Simple, high performance and secure live media server in pure Rust";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.xiu} --config ${./config.ini}";
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = [ 1935 ];
  };
}
