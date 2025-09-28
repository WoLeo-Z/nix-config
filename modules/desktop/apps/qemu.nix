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
      win-virtio
      win-spice
    ];
    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}
