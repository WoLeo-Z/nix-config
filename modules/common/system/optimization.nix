{
  boot.kernelParams = [ "intel_pstate=active" ]; # TODO: Move to profiles.hardware.cpu.intel

  services = {
    power-profiles-daemon.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil"; # schedutil, powersave, performance
  };

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
}
