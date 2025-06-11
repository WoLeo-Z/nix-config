{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.media.obs-studio;
in
{
  options.modules.desktop.apps.media.obs-studio = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
        obs-teleport
        obs-vkcapture
        obs-gstreamer
        droidcam-obs
        # obs-3d-effect
        # input-overlay
        # obs-multi-rtmp
        # obs-source-clone
        # obs-shaderfilter
        # obs-source-record
        # obs-livesplit-one
        # looking-glass-obs
        # obs-vintage-filter
        # obs-command-source
        # obs-move-transition
        # obs-backgroundremoval
      ];
    };
  };
}
