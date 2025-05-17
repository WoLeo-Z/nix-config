{ lib, config, ... }:

with lib;
let
  cfg = config.modules.system.boot.loader.grub;
in
{
  options.modules.system.boot.loader.grub = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    boot.loader = {
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

    stylix.targets.grub.enable = true;
  };
}
