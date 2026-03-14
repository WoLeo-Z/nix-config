{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.media.mpv;
in
{
  options.modules.desktop.apps.media.mpv = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm.programs.mpv = {
      enable = true;
      config = {
        # OSD configs.
        osd-font = config.stylix.fonts.sansSerif.name;
        osd-bar = false;
        # NOTE: if set border to false, uosc will draw its own window decorations,
        # while we prefer window manager's decorations
        border = true;

        # Disable builtin OSC
        osc = false;

        # Subtitles.
        sub-align-x = "left";
        sub-font-size = 36;
        sub-justify = "auto";
        sub-font = config.stylix.fonts.sansSerif.name;
        sub-border-size = 1;
        sub-border-color = "#C0808080";
        sub-color = "#FF6699";

        osd-border-size = 1;
        osd-border-color = "#C0808080";

        hwdec = "vaapi";
        vo = "gpu-next";
      };
      scriptOpts = {
        console = {
          font = config.stylix.fonts.monospace.name;
          font_size = 24;
        };
        stats = {
          font = config.stylix.fonts.sansSerif.name;
          font_mono = config.stylix.fonts.monospace.name;
        };
        uosc = {
          timeline_size = 24;
          timeline_style = "bar";
          scale_fullscreen = 1;
          text_border = 0.5;
          controls = "menu,gap,subtitles,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,gap,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
          refine = "text_width";
        };
        thumbfast = {
          spawn_first = false;
          network = true;
          hwdec = true;
        };
      };
      profiles = {
        bilibili = {
          profile-desc = "[BiliBili] Videos";
          profile-cond = "path:match('https://www.bilibili.com')~=nil or path:match('https://bilibili.com')~=nil";
          profile-restore = "copy";
          referrer = "https://www.bilibili.com/";
          ytdl-raw-options = "cookies-from-browser=firefox,sub-lang=[all,-danmaku],write-sub=";
        };
        bililive = {
          profile-desc = "[BiliBili] Livestream";
          profile-cond = "path:match('https://live.bilibili.com')~=nil";
          profile-restore = "copy";
          ytdl-raw-options = "cookies-from-browser=firefox";
          ytdl-format = "best[protocol=https]";
        };
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
        thumbfast
      ];
    };

    hm = {
      xdg.mimeApps = {
        defaultApplications =
          let
            apply = app: mimes: lib.genAttrs mimes (_: app);
          in
          (apply "mpv.desktop" [
            "video/3gp"
            "video/3gpp"
            "video/3gpp2"
            "video/dv"
            "video/divx"
            "video/fli"
            "video/flv"
            "video/mp2t"
            "video/mp4"
            "video/mp4v-es"
            "video/mpeg"
            "video/mpeg-system"
            "video/msvideo"
            "video/ogg"
            "video/quicktime"
            "video/vivo"
            "video/vnd.divx"
            "video/vnd.mpegurl"
            "video/vnd.rn-realvideo"
            "video/vnd.vivo"
            "video/webm"
            "video/x-anim"
            "video/x-avi"
            "video/x-flc"
            "video/x-fli"
            "video/x-flic"
            "video/x-flv"
            "video/x-m4v"
            "video/x-matroska"
            "video/x-mjpeg"
            "video/x-mpeg"
            "video/x-mpeg2"
            "video/x-ms-asf"
            "video/x-ms-asf-plugin"
            "video/x-ms-asx"
            "video/x-msvideo"
            "video/x-ms-wm"
            "video/x-ms-wmv"
            "video/x-ms-wvx"
            "video/x-nsv"
            "video/x-ogm+ogg"
            "video/x-theora"
            "video/x-theora+ogg"
          ]);
      };
    };
  };
}
