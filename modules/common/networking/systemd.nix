{ lib, ... }:

{
  networking = {
    useDHCP = lib.mkDefault false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSOverTLS = "opportunistic";
        DNSSEC = "false"; # one of "true", "allow-downgrade", "false"
      };
    };
  };
}
