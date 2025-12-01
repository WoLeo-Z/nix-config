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

    # speed up entering multi-user.target
    systemd.services.tailscaled-autoconnect.wantedBy = mkForce [ ];

    sops.secrets.tailscale_key = {
      key = "tailscale/nix-secrets";
      restartUnits = [ config.systemd.services.tailscaled.name ];
    };
  };
}
