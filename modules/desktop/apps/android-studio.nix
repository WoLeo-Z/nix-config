{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.android-studio;
in
{
  options.modules.desktop.apps.android-studio = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        (android-studio.override {
          # Fix Wayland HiDPI, scaling too large
          # https://wiki.archlinux.org/title/HiDPI#JetBrains_IDEs
          forceWayland = true;
        })
      ];
    };

    nixpkgs.config.android_sdk.accept_license = true;

    programs.adb.enable = true;
    user.extraGroups = [ "adbusers" ];
  };
}
