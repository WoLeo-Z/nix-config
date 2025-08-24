{
  # Use sched-ext schedulers with linux-cachyos
  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_rusty";
  #   package = pkgs.scx_git.full;
  # };

  zramSwap = {
    enable = false;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
}
