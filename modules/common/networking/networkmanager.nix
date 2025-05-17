{
  lib,
  config,
  pkgs,
  ...
}:

{
  networking = {
    networkmanager.enable = true;

    # iwd
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  systemd = {
    services.NetworkManager-wait-online.enable = false;
    # Disables the service because it hangs on boot.
    services.NetworkManager-dispatcher.enable = false;
  };

  user.extraGroups = [ "networkmanager" ];
}
