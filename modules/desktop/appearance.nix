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
      default = "${inputs.self.outPath}/assets/wallpapers/wall1.png";
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
          name = "JetBrains Mono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    # GTK
    hm = {
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
          # Papirus-Dark papirus-icon-theme
          # kora kora-icon-theme
          # ? fluent-icon-theme
          # ? adwaita-icon-theme
        };
      };

      stylix.targets.gtk.enable = true; # Home-manager options
      stylix.targets.gnome.enable = true; # Needed by some apps (e.g. bottles, ...)
    };
    stylix.targets.gtk.enable = true; # NixOS options

    # QT
    hm.stylix.targets.qt.enable = true;
    stylix.targets.qt.enable = true;
  };
}
