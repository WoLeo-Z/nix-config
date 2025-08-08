{
  lib,
  config,
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
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };

    # NetworkManager
    networking.networkmanager = {
      enable = true;
      unmanaged = [ "interface-type:ethernet" ]; # use systemd-networkd for ethernet
    };

    programs.nm-applet.enable = true; # GUI

    systemd = {
      services.NetworkManager-wait-online.enable = false;
      # Disables the service because it hangs on boot.
      services.NetworkManager-dispatcher.enable = false;
    };

    user.extraGroups = [ "networkmanager" ];
  })
]
