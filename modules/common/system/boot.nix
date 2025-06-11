{ lib, pkgs, ... }:

with lib;
{
  boot = {
    # Kernel

    # kernelPackages = pkgs.linuxPackages
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_cachyos-lto;

    # Bootloader: Grub
    loader = {
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";

        useOSProber = mkDefault false;

        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
      };
    };
  };

  stylix.targets.grub.enable = true;
}
