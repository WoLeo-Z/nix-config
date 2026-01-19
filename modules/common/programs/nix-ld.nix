{
  lib,
  pkgs,
  config,
  ...
}:

{
  services.envfs.enable = lib.mkDefault true;

  programs.nix-ld = {
    enable = lib.mkDefault true;
    libraries =
      with pkgs;
      [
        acl
        attr
        bzip2
        dbus
        expat
        fontconfig
        freetype
        fuse3
        glib
        icu
        libnotify
        libsodium
        libssh
        libunwind
        libusb1
        libuuid
        libxcb
        libxi
        libxrender
        libxtst
        nspr
        nss
        stdenv.cc.cc
        util-linux
        zlib
        zstd
      ]
      ++ lib.optionals (config.modules.desktop.enable) [
        pipewire
        cups
        mesa
        libdrm
        libglvnd
        libpulseaudio
        libGL
        libappindicator-gtk3
      ];
  };
}
