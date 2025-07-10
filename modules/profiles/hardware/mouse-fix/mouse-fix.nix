{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "mouse-fix" s) hardware) {
    services.libinput = {
      enable = true;
    };
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Logitech G500s Laser Gaming Mouse]
      MatchName=Logitech G500s Laser Gaming Mouse
      ModelBouncingKeys=0
    '';
    nixpkgs.overlays = [
      (final: prev: {
        libinput = prev.libinput.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [ ./increase-debounce-time.patch ];
        });
      })
    ];
  })
]
