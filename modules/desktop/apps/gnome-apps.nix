{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.gnome-apps;
in
{
  options.modules.desktop.apps.gnome-apps = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        # GNOME Apps
        gnome-clocks
        baobab # Disk Usage Analyzer
        loupe # Image Viewer
        gnome-logs # View detailed event logs
        showtime # Video Player
        amberol # Music Player
        mousai # Identify Songs
        gnome-solanum # Pomodoro Clock
        sysprof # Profile an application or entire system
      ];

      xdg.mimeApps = {
        defaultApplications =
          let
            apply = app: mimes: lib.genAttrs mimes (_: app);
          in
          (apply "org.gnome.Loupe.desktop" [
            # fd org.gnome.Loupe.desktop /
            # cat /.../share/applications/org.gnome.Loupe.desktop | grep MimeType=
            "image/jpeg"
            "image/png"
            "image/gif"
            "image/webp"
            "image/tiff"
            "image/x-tga"
            "image/vnd-ms.dds"
            "image/x-dds"
            "image/bmp"
            "image/vnd.microsoft.icon"
            "image/vnd.radiance"
            "image/x-exr"
            "image/x-portable-bitmap"
            "image/x-portable-graymap"
            "image/x-portable-pixmap"
            "image/x-portable-anymap"
            "image/x-qoi"
            "image/qoi"
            "image/svg+xml"
            "image/svg+xml-compressed"
            "image/avif"
            "image/heic"
            "image/jxl"
          ])
          // (apply "org.gnome.Showtime.desktop" [
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
          ])
          // (apply "io.bassi.Amberol.desktop" [
            "audio/mpeg"
            "audio/wav"
            "audio/x-aac"
            "audio/x-aiff"
            "audio/x-ape"
            "audio/x-flac"
            "audio/x-m4a"
            "audio/x-m4b"
            "audio/x-mp1"
            "audio/x-mp2"
            "audio/x-mp3"
            "audio/x-mpg"
            "audio/x-mpeg"
            "audio/x-mpegurl"
            "audio/x-opus+ogg"
            "audio/x-pn-aiff"
            "audio/x-pn-au"
            "audio/x-pn-wav"
            "audio/x-speex"
            "audio/x-vorbis"
            "audio/x-vorbis+ogg"
            "audio/x-wavpack"
            "inode/directory"
          ]);
      };

      services.amberol.enable = true; # enable Amberol music player as a daemon
    };

    services.sysprof.enable = true; # System-wide profiler
  };
}
