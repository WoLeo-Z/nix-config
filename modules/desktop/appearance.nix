{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.appearance;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.modules.desktop.appearance = {
    enable = mkEnableOption' { default = config.modules.desktop.enable; };
    image = mkOption {
      type = types.path;
      default = "${config.programs.nh.flake}/assets/wallpapers/nix-wallpaper-nineish-catppuccin-mocha-alt.png";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      polarity = "dark";
      image = cfg.image;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      fonts = {
        sizes = {
          applications = 12;
          desktop = 10;
          terminal = 12;
        };
        serif = {
          package = pkgs.noto-fonts-cjk-serif;
          name = "Noto Serif CJK SC";
        };
        sansSerif = {
          package = pkgs.noto-fonts-cjk-sans;
          name = "Noto Sans CJK SC";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    hm.stylix.icons = {
      enable = true;

      # Papirus
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";

      # Adwaita
      # package = pkgs.adwaita-icon-theme;
      # light = "Adwaita";
      # dark = "Adwaita-dark";

      # Kora
      # package = pkgs.kora-icon-theme;
      # light = "kora-light";
      # dark = "kora";
    };

    # GTK
    stylix.targets.gtk.enable = true; # NixOS options
    hm.stylix.targets.gtk.enable = true; # Home-manager options
    hm.stylix.targets.gnome.enable = true; # Needed by some apps (e.g. bottles, ...)

    # QT
    hm.stylix.targets.qt.enable = true;
    stylix.targets.qt.enable = true;

    # Wallpapers Symlink
    hm.home.file = {
      "Pictures/Wallpapers" = {
        source = mkOutOfStoreSymlink "${config.programs.nh.flake}/assets/wallpapers";
        recursive = true;
      };
    };
  };
}
