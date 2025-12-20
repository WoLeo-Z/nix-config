{ pkgs, ... }:

{
  systemd.settings.Manager = {
    DefaultLimitNOFILE = "2048:2097152";
  };

  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
    package = pkgs.scx.full;
  };

  zramSwap = {
    enable = false;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
}
