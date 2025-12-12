{ lib, config, ... }:

with lib;
let
  roles = config.modules.profiles.roles;
in
mkMerge [
  (mkIf (any (s: hasPrefix "cn" s) roles) {
    networking = {
      timeServers = [
        "ntp1.aliyun.com"
        "ntp.tuna.tsinghua.edu.cn"
        "time.cloudflare.com"
        "time.apple.com"
      ];
      nameservers = [
        # IPv4
        "223.5.5.5#dns.alidns.com" # AliDNS
        "1.12.12.21#dot.pub" # DNSPOD
        "1.1.1.1" # Cloudflare
        "8.8.8.8" # Google

        # IPv6
        "2400:3200::1" # AliDNS
        "2606:4700:4700::1111" # Cloudflare
        "2001:4860:4860::8888" # Google
      ];
    };

    nix.settings.substituters = lib.mkBefore [
      # Status: https://mirrors.cernet.edu.cn/list/nix-channels
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      # "https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
    ];
  })
]
