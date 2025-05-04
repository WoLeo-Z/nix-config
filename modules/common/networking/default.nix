{ lib, config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #   networkmanagerapplet # nm-connection-editor
  # ];

  systemd = {
    services.NetworkManager-wait-online.enable = false;
    # Disables the service because it hangs on boot.
    services.NetworkManager-dispatcher.enable = false;
  };
}
