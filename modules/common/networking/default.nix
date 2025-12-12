{ pkgs, lib, ... }:

{
  networking = {
    timeServers = lib.mkDefault [
      "time.cloudflare.com"
      "pool.ntp.org"
      "time.apple.com"
      "time.nist.gov"
    ];
    nameservers = lib.mkDefault [
      # IPv4
      "1.1.1.1" # Cloudflare
      "8.8.8.8" # Google

      # IPv6
      "2606:4700:4700::1111" # Cloudflare
      "2001:4860:4860::8888" # Google
    ];
  };

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
    ethtool
  ];
}
