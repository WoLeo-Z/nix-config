{ pkgs, ... }:

{
  # Use sched-ext schedulers with linux-cachyos
  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
    package = pkgs.scx_git.full;
  };

  services = {
    power-profiles-daemon.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil"; # schedutil, powersave, performance
  };

  zramSwap = {
    enable = false;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
}
