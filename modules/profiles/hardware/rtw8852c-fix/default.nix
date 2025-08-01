{
  lib,
  config,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "rtw8852c-fix" s) hardware) {
    # Use old firmware (0.27.56.14 (1942d927))
    # TODO: REVIEW: https://bugzilla.redhat.com/show_bug.cgi?id=2349675
    nixpkgs.overlays = [
      (self: super: {
        linux-firmware = super.linux-firmware.overrideAttrs (oldAttrs: {
          postInstall = ''
            rm $out/lib/firmware/rtw89/rtw8852c_*.bin
            cp ${./rtw8852c_fw-fallback.bin} $out/lib/firmware/rtw89/rtw8852c_fw.bin
          '';
        });
      })
    ];

    # Use another rtw89 driver -- Not Working
    # https://bbs.archlinux.org/viewtopic.php?id=302036
    # https://aur.archlinux.org/packages/rtw89-dkms-git

    # boot.extraModulePackages = [
    #   pkgs.rtw89-morrownr
    # ];

    # nixpkgs.overlays = [
    #   (self: super: {
    #     rtw89-morrownr = super.callPackage ./_rtw89-morrownr.nix {
    #       kernel = super.linuxPackages_latest.kernel;
    #       kernelModuleMakeFlags = super.linuxPackages_latest.kernelModuleMakeFlags;
    #     };
    #   })
    # ];

    # boot.blacklistedKernelModules = [ "rtw89_8852ce" ];

    # boot.extraModprobeConfig = ''
    #   options rtw89_core_git debug_mask=0x0
    #   options rtw89_core_git disable_ps_mode=n

    #   options rtw89_pci_git disable_clkreq=n
    #   options rtw89_pci_git disable_aspm_l1=n
    #   options rtw89_pci_git disable_aspm_l1ss=n
    # '';
  })
]
