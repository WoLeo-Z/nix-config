# ref: https://github.com/hlissner/dotfiles/blob/254aea2230e1350409a7ae7b6566bcd98f5b5360/modules/profiles/role/workstation.nix
{ lib, config, ... }:

with lib;
let
  roles = config.modules.profiles.roles;
in
mkMerge [
  (mkIf (any (s: hasPrefix "workstation" s) roles) {
    boot = {
      # HACK I used to disable mitigations for spectre, meltdown, L1TF,
      #   retbleed, and other CPU vulnerabilities for a marginal performance
      #   gain on non-servers, but it really makes little to no difference on
      #   modern CPUs. It may still be worth it on older Xeons and the like (on
      #   workstations) though. I've preserved this in comments for future
      #   reference.
      #
      #   DO NOT COPY AND UNCOMMENT IT BLINDLY! If you're looking for
      #   optimizations, these aren't the droids you're looking for!
      # kernelParams = [ "mitigations=off" ];

      # loader = {
      #   # I'm not a big fan of Grub, so if it's not in use...
      #   systemd-boot.enable = mkDefault true;
      #   # For much quicker boot up to NixOS. I can use `systemctl reboot
      #   # --boot-loader-entry=X` instead.
      #   timeout = mkDefault 1;
      # };

      # For a truly silent boot!
      # kernelParams = [
      #   "quiet"
      #   "splash"
      #   "udev.log_level=3"
      # ];
      # consoleLogLevel = 0;
      # initrd.verbose = false;

      # Common kernels across workstations
      initrd.availableKernelModules = [
        "nvme" # SSD
        "xhci_pci" # USB 3.0
        "usb_storage" # USB mass storage devices
        "usbhid" # USB human interface devices
        "ahci" # SATA devices on modern AHCI controllers
        "sd_mod" # SCSI, SATA, and IDE devices
      ];

      # The default maximum is too low, which starves IO hungry apps.
      kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    };

    # TuneD - Tuning Profile Delivery Mechanism for Linux
    # A modern replacement for PPD(power-profiles-daemon)
    services.tuned = {
      enable = true;
      settings.dynamic_tuning = true;
      ppdSupport = true; # translation of power-profiles-daemon API calls to TuneD
      ppdSettings.main.default = "balanced"; # balanced / performance / power-saver
    };
    environment.etc."tuned/profiles/.keep".text = ""; # Needed by tuned-gui when etc overlay is enabled
    # DBus service that provides power management support to applications
    # Required by `tuned-ppd` for handling power supply changes
    services.upower.enable = true;
    services.power-profiles-daemon.enable = false; # conflicts with tuned
    services.tlp.enable = false; # conflicts with tuned

    # # Use systemd-{network,resolve}d; a more unified networking backend that's
    # # easier to reconfigure downstream, especially where split-DNS setups (e.g.
    # # VPNs) are concerned.
    # networking = {
    #   useDHCP = false;
    #   useNetworkd = true;
    # };
    # systemd = {
    #   network = {
    #     networks = {
    #       "60-wired" = {
    #         enable = true;
    #         name = "en*";
    #         networkConfig.DHCP = lib.mkDefault "ipv6";
    #         networkConfig.IPv6PrivacyExtensions = "kernel";
    #         linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
    #         dhcpV4Config.RouteMetric = 1024;
    #       };
    #       # "30-wireless" = {
    #       #   enable = true;
    #       #   name = "wl*";
    #       #   networkConfig.DHCP = "yes";
    #       #   networkConfig.IPv6PrivacyExtensions = "kernel";
    #       #   linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
    #       #   dhcpV4Config.RouteMetric = 2048; # prefer wired
    #       # };
    #     };

    #     # systemd-networkd-wait-online waits forever for *all* interfaces to be
    #     # online before passing; which is unlikely to ever happen.
    #     wait-online = {
    #       anyInterface = true;
    #       timeout = 30;

    #       # The anyInterface setting is still finnicky for some networks, so I
    #       # simply turn off the whole check altogether.
    #       enable = false;
    #     };
    #   };
    # };
    # boot.initrd.systemd.network.wait-online = {
    #   anyInterface = true;
    #   timeout = 10;
    # };
  })
]
