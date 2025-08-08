{
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    dnssec = "false"; # one of "true", "allow-downgrade", "false"
    dnsovertls = "opportunistic";
    fallbackDns = [
      # IPv4
      "1.1.1.1" # Cloudflare
      "8.8.8.8" # Google
      "114.114.114.114" # 114DNS
      "223.5.5.5" # AliDNS

      # IPv6
      "2606:4700:4700::1111" # Cloudflare
      "2001:4860:4860::8888" # Google
      "240c::6666" # 114DNS
      "2400:3200::1" # AliDNS
    ];
  };
}
