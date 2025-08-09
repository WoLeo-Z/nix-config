{
  # NetworkManager
  networking.networkmanager.enable = true;

  programs.nm-applet.enable = true; # GUI

  systemd = {
    services.NetworkManager-wait-online.enable = false;
    # Disables the service because it hangs on boot.
    services.NetworkManager-dispatcher.enable = false;
  };

  user.extraGroups = [ "networkmanager" ];

  # dhcpcd
  networking.useDHCP = false;
  networking.dhcpcd = {
    enable = true;
    IPv6rs = true;
  };
  networking.networkmanager.dhcp = "dhcpcd";
}
