{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.services.apollo;
  edidFile = pkgs.fetchurl {
    url = "https://git.linuxtv.org/v4l-utils.git/plain/utils/edid-decode/data/samsung-q800t-hdmi2.1?id=1cc84dfb41d88eee260827b3aca9d077ad153eb2";
    sha256 = "sha256-0KbqdA08If4BWnSCHT+/w6pI3toIO2ktbI+qeX8Ne2Q=";
  };
in
{
  imports = [
    inputs.apollo-flake.nixosModules."x86_64-linux".default
  ];

  options.modules.services.apollo = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(config.modules.services.apollo.enable && config.modules.services.sunshine.enable);
        message = "Apollo and Sunshine cannot be both enabled";
      }
    ];

    services.apollo = {
      enable = true;
      package = inputs.apollo-flake.packages.${pkgs.system}.default;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # Virtual Display
    # https://www.azdanov.dev/articles/2025/how-to-create-a-virtual-display-for-apollo-on-arch-linux
    # https://discourse.nixos.org/t/copying-custom-edid/31593/25
    boot.kernelParams = [
      "drm.edid_firmware=DP-2:edid/virtual-display.bin"
      "video=DP-2:e"
    ];
    hardware.firmware = [
      (pkgs.runCommand "edid.bin" { } ''
        mkdir -p $out/lib/firmware/edid
        cp ${edidFile} $out/lib/firmware/edid/virtual-display.bin
      '')
    ];

    hm.home.packages = with pkgs; [
      moonlight-qt # Sunshine Client
      # TODO: Artemis: https://github.com/wjbeckett/artemis
    ];
  };
}
