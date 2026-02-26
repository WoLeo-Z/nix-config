{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.media.gpu-screen-recorder;
in
{
  options.modules.desktop.apps.media.gpu-screen-recorder = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs.gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

    environment.systemPackages = with pkgs; [
      gpu-screen-recorder-gtk # GUI app
    ];
  };
}
