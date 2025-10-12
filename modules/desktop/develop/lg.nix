{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.develop.lg;
  edl-udev-rules = pkgs.writeTextFile {
    name = "edl-udev-rules";
    text = builtins.readFile ./51-edl.rules;
    destination = "/lib/udev/rules.d/51-edl.rules";
  };
in
{
  options.modules.desktop.develop.lg = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    networking.modemmanager.enable = false;
    environment.systemPackages = with pkgs; [
      android-tools
      python313
      python313Packages.pip
      git
      xz
      uv
      libusb1
    ];

    services.udev.packages = [
      pkgs.android-udev-rules
      edl-udev-rules
    ];
    # services.udev.extraRules = builtins.readFile ./51-edl.rules;
    boot.kernelParams = [ "usbcore.quirks=18d1:d00d:k" ];
    user.extraGroups = [ "plugdev" ];
  };
}
