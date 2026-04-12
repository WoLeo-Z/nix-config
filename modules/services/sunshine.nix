{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.sunshine;
  edidFile = builtins.path { path = ../../assets/edid/mbp14inch.bin; };
in
{
  options.modules.services.sunshine = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # Virtual Display
    # https://www.azdanov.dev/articles/2025/how-to-create-a-virtual-display-for-sunshine-on-arch-linux
    # https://discourse.nixos.org/t/copying-custom-edid/31593/25
    boot.kernelParams = [
      "drm.edid_firmware=DP-2:edid/virtual-display.bin"
      "video=DP-2:e"
    ];
    hardware.firmware = [
      (pkgs.runCommand "edid.bin" { } ''
        install -Dm444 ${edidFile} $out/lib/firmware/edid/virtual-display.bin
      '')
    ];

    user.packages = with pkgs; [
      moonlight-qt # Sunshine Client
    ];
  };
}
