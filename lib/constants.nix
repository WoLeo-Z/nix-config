{ ... }:

{
  constants = {
    users = {
      wol = {
        usernames = {
          github = "WoLeo-Z";
          gitlab = "w0l";
        };
        email = "me@w0l.top";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+VeoTKwffaTAmxbe2lM2jN63/WkO2ytaeb6eTfMfx6 wol";
      };
    };

    chromiumArgs = [
      "--ozone-platform-hint=auto"
      "--enable-features=WaylandWindowDecorations"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
    ];
  };
}
