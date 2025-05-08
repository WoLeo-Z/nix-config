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
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.modules.desktop.appearance = {
    enable = mkEnableOption' { default = config.modules.desktop.enable; };
    image = mkOption {
      type = types.path;
      default = ../../assets/wallpapers/nix-black-4k.png;
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      image = cfg.image;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      opacity = {
        terminal = 0.9;
        popups = 0.8;
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      fonts = {
        serif = {
          package = pkgs.noto-fonts-cjk-sans;
          name = "Noto Sans CJK SC";
        };
        sansSerif = {
          package = pkgs.noto-fonts-cjk-serif;
          name = "Noto Serif CJK SC";
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
    };
  };
}
