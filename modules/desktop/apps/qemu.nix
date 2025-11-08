{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.qemu;
in
{
  options.modules.desktop.apps.qemu = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    user.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
    ];
    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          vhostUserPackages = with pkgs; [
            virtiofsd # for Shared folders
          ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
  };
}
