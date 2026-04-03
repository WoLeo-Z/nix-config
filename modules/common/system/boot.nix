{ lib, pkgs, ... }:

{
  boot = {
    # Kernel

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_cachyos-lto;
    # kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "nowatchdog"
      "pcie_aspm=off" # Fix: log spam: PCIe Bus Error ...
    ];
  };

  # Bootloader
  boot.loader = {
    timeout = 3;
    efi = {
      canTouchEfiVariables = true;
    };

    # grub = {
    #   efiSupport = true;
    #   devices = [ "nodev" ];
    #   useOSProber = lib.mkDefault false;
    #   # extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
    #   # configurationName = "${host}";
    #   extraConfig = ''
    #     insmod kbd
    #     set keymap=us
    #   '';
    #   extraEntries = ''
    #     menuentry "Reboot" {
    #       reboot
    #     }
    #     menuentry "Poweroff" {
    #       halt
    #     }
    #     menuentry "UEFI Firmware Settings" {
    #       fwsetup
    #     }
    #   '';
    # };

    systemd-boot = {
      enable = false;
      editor = false; # for security
      # we use Git for version control, so we don't need to keep too many generations.
      configurationLimit = lib.mkDefault 10;
      # pick the highest resolution for systemd-boot's console.
      consoleMode = lib.mkDefault "max";
      memtest86.enable = true;
    };

    limine = {
      enable = true;
      maxGenerations = lib.mkDefault 10;
      secureBoot.enable = false;

      # Extra entries
      additionalFiles = {
        "efi/memtest86plus/memtest86plus.efi" = pkgs.memtest86plus.efi;
        "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
      };
      extraEntries = ''
        /MemTest86+
          protocol: efi
          comment: ${pkgs.memtest86plus.meta.description}
          path: boot():/limine/efi/memtest86plus/memtest86plus.efi
        /netboot.xyz
          protocol: efi
          comment: ${pkgs.netbootxyz-efi.meta.description}
          path: boot():/limine/efi/netbootxyz/netboot.xyz.efi
      '';
    };
  };

  stylix.targets.grub.enable = true;
  stylix.targets.limine.enable = true;
}
