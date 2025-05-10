{ lib, ... }:

{
  networking = {
    firewall.enable = lib.mkDefault false;
    firewall.checkReversePath = lib.mkDefault false;
    nftables.enable = lib.mkDefault true;
    useDHCP = false;
  };

  # systemd.network.enable = true;
  # services.resolved.enable = false;

  # systemd.network.networks.enp1s0 = {
  #   DHCP = "yes";
  #   matchConfig.Name = "enp1s0";
  # };
}
