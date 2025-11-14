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

    sops.secrets.tailscale_key = {
      key = "tailscale/nix-secrets"; # TODO: don't use vostro
      restartUnits = [ config.systemd.services.tailscaled.name ];
    };
  };
}
