{
  lib,
  options,
  pkgs,
  ...
}:

{
  networking = {
    firewall.enable = lib.mkDefault false;
    firewall.checkReversePath = lib.mkDefault false;
    nftables.enable = lib.mkDefault true;
    useDHCP = false;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  # systemd.network.enable = true;
  # services.resolved.enable = false;

  # systemd.network.networks.enp1s0 = {
  #   DHCP = "yes";
  #   matchConfig.Name = "enp1s0";
  # };

  # Tools & Packages
  programs = {
    mtr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    nmap
    iperf3
  ];
}
