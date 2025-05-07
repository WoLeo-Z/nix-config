{
  lib,
  config,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.media.spotify;
  spicePkgs = inputs.spicetify-nix.legacyPackages."x86_64-linux";
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  options.modules.desktop.apps.media.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        ncsVisualizer
      ];
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
        betterGenres
      ];
      experimentalFeatures = true;
      # Managed by stylix
      # theme = spicePkgs.themes.catppuccin;
      # colorScheme = "mocha";
    };

    # Local discovery https://nixos.wiki/wiki/Spotify
    networking.firewall.allowedTCPPorts = [
      57621 # To sync local tracks from your filesystem with mobile devices in the same network
      5353 # To enable discovery of Google Cast devices (and possibly other Spotify Connect devices) in the same network
    ];
  };
}
