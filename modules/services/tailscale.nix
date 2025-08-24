{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.tailscale;
in
{
  options.modules.services.tailscale = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.sops.secrets.tailscale_key.path;
      useRoutingFeatures = "none";
    };

    systemd.services.tailscaled.serviceConfig = {
      TimeoutStopSec = 1; # It hangs on shutdown
    };

    # nixos/tailscale: tailscaled-autoconnect.service prevents multi-user.target from reaching "active" state
    # REVIEW: https://github.com/nixos/nixpkgs/issues/430756
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "simple";

    sops.secrets.tailscale_key = {
      key = "tailscale_key/vostro"; # TODO: don't use vostro
      restartUnits = [ config.systemd.services.tailscaled.name ];
    };
  };
}
