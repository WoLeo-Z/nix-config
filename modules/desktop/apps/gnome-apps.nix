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
    user.packages = with pkgs; [
      # GNOME Apps
      gnome-clocks
      baobab # Disk Usage Analyzer
      loupe # Image Viewer
      gnome-logs # View detailed event logs
      showtime # Video Player
      gnome-solanum # Pomodoro Clock
      sysprof # Profile an application or entire system
      file-roller # Archive Manager

      # GTK Apps
      amberol # Music Player
      turnon # Utility to send Wake On LAN magic packets
      morphosis # Documents Converter (using Pandoc)
      rnote # Sketch and take handwritten notes
    ];

    hm = {
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
          // (apply "org.gnome.FileRoller.desktop" [
            "application/bzip2"
            "application/gzip"
            "application/vnd.android.package-archive"
            "application/vnd.ms-cab-compressed"
            "application/vnd.debian.binary-package"
            "application/vnd.rar"
            "application/x-7z-compressed"
            "application/x-7z-compressed-tar"
            "application/x-ace"
            "application/x-alz"
            "application/x-apple-diskimage"
            "application/x-ar"
            "application/x-archive"
            "application/x-arj"
            "application/x-brotli"
            "application/x-bzip-brotli-tar"
            "application/x-bzip"
            "application/x-bzip-compressed-tar"
            "application/x-bzip1"
            "application/x-bzip1-compressed-tar"
            "application/x-bzip3"
            "application/x-bzip3-compressed-tar"
            "application/x-cabinet"
            "application/x-cd-image"
            "application/x-compress"
            "application/x-compressed-tar"
            "application/x-cpio"
            "application/x-chrome-extension"
            "application/x-deb"
            "application/x-ear"
            "application/x-ms-dos-executable"
            "application/x-gtar"
            "application/x-gzip"
            "application/x-gzpostscript"
            "application/x-java-archive"
            "application/x-lha"
            "application/x-lhz"
            "application/x-lrzip"
            "application/x-lrzip-compressed-tar"
            "application/x-lz4"
            "application/x-lzip"
            "application/x-lzip-compressed-tar"
            "application/x-lzma"
            "application/x-lzma-compressed-tar"
            "application/x-lzop"
            "application/x-lz4-compressed-tar"
            "application/x-ms-wim"
            "application/x-rar"
            "application/x-rar-compressed"
            "application/x-rpm"
            "application/x-source-rpm"
            "application/x-rzip"
            "application/x-rzip-compressed-tar"
            "application/x-tar"
            "application/x-tarz"
            "application/x-tzo"
            "application/x-stuffit"
            "application/x-war"
            "application/x-xar"
            "application/x-xz"
            "application/x-xz-compressed-tar"
            "application/x-zip"
            "application/x-zip-compressed"
            "application/x-zstd-compressed-tar"
            "application/x-zoo"
            "application/zip"
            "application/zstd"
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
          ]);
      };

      dconf.settings = {
        "org/gnome/file-roller/ui" = {
          view-sidebar = "true";
        };
      };

      services.amberol.enable = true; # enable Amberol music player as a daemon
    };

    services.sysprof.enable = true; # System-wide profiler
  };
}
