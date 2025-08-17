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
        android-studio
        android-tools # provide adb
      ];
    };

    nixpkgs.config.android_sdk.accept_license = true;
  };
}
