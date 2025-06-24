{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "qemu-guest" s) hardware) {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    # "/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/profiles/qemu-guest.nix"
    # Common configuration for virtual machines running under QEMU (using virtio).
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
  })
]
