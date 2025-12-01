# _disabled

{ pkgs, ... }:

{
  # NetworkManager
  networking.networkmanager.enable = true;

  # GUI
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  systemd = {
    services.NetworkManager-wait-online.enable = false;
    # Disables the service because it hangs on boot.
    services.NetworkManager-dispatcher.enable = false;
  };

  user.extraGroups = [ "networkmanager" ];

  # use systemd-resolved
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    dnssec = "false"; # one of "true", "allow-downgrade", "false"
    dnsovertls = "opportunistic";
  };

  # use NetworkManager internal DHCP
  # networking.useDHCP = false;
  # networking.networkmanager.dhcp = "internal";

  # use dhcpcd
  networking.useDHCP = false;
  networking.dhcpcd = {
    enable = true;
    IPv6rs = true;
  };
  networking.networkmanager.dhcp = "dhcpcd";
}
