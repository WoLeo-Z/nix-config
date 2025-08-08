{
  options,
  pkgs,
  ...
}:

{
  networking = {
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    nameservers = [
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

  # systemd.network.enable = true;

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
