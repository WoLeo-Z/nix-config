{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "wifi" s) hardware) {
    # iwd
    networking = {
      wireless.enable = true;
      wireless.iwd.enable = true;
    };
    networking.networkmanager.wifi.backend = "iwd";

    # NetworkManager
    networking.networkmanager.enable = true;
    networking.networkmanager.dns = lib.mkDefault "default";

    environment.systemPackages = with pkgs; [ networkmanagerapplet ];

    systemd = {
      services.NetworkManager-wait-online.enable = false;
      # Disables the service because it hangs on boot.
      services.NetworkManager-dispatcher.enable = false;
    };

    user.extraGroups = [ "networkmanager" ];
  })
]
