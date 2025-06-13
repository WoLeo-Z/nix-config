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
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwy4TJit4vDnFEYJz1/QVvpIcpk2F//aHk0U3aNmgZ9";
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
