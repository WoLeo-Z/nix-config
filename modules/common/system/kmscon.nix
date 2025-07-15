{ config, ... }:

{
  services.kmscon = {
    enable = false; # Wait for https://github.com/NixOS/nixpkgs/issues/385497
    autologinUser = config.user.name;
    hwRender = false; # Fix font blurred (maybe?)
    extraConfig = ''
      font-dpi = 120
    '';
  };

  stylix.targets.kmscon.enable = true;
}
