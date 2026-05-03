{ lib, config, ... }:

with lib;
let
  cfg = config.modules.virtualisation.podman;
in
{
  options.modules.virtualisation.podman = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      containers = {
        enable = true;
        registries.search = [ "docker.io" ];
      };
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };

    user.extraGroups = [ "podman" ];
  };
}
