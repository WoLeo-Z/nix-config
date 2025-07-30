{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.fcitx5;
in
{
  options.modules.desktop.fcitx5 = {
    enable = lib.mkEnableOption' { };
  };

  config = lib.mkIf cfg.enable {
    # to use svg themes
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    i18n = {
      defaultLocale = lib.mkDefault "en_US.UTF-8";
      supportedLocales = lib.mkDefault [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mellow-themes
            (fcitx5-rime.override {
              rimeDataPkgs = [
                rime-data
                nur.repos.xddxdd.rime-ice
                nur.repos.xddxdd.rime-zhwiki
                nur.repos.xddxdd.rime-moegirl
              ];
            })
          ];
          # plasma6Support = true;
        };
      };
    };

    hm = {
      # Reference: merrkry/decalratia/profiles/desktop/i18n.nix
      # https://github.com/merrkry/decalratia/blob/c25aab15b970b568f1670d655f1429a8a8a5832d/profiles/desktop/i18n.nix

      home.sessionVariables = lib.mkMerge [
        {
          # LANG = "zh_CN.UTF-8"; # not working?
          XMODIFIERS = "@im=fcitx";
        }
        (lib.optionalAttrs (!config.services.desktopManager.plasma6.enable) {
          GTK_IM_MODULE = "wayland"; # `wayland` to use tiv3, `fcitx` to use fcitx im module
          QT_IM_MODULE = "fcitx";
          QT_IM_MODULES = "wayland;fcitx;ibus";
        })
      ];

      # systemd.user.services = {
      #   "fcitx5" = {
      #     Install = {
      #       WantedBy = [ "graphical-session.target" ];
      #     };
      #     Unit = {
      #       PartOf = [ "graphical-session.target" ];
      #       After = [
      #         "graphical-session.target"
      #         "xwayland-satellite.service"
      #       ];
      #     };
      #     Service = {
      #       ExecStart = "${lib.getExe' config.i18n.inputMethod.package "fcitx5"} --replace";
      #       Restart = "on-failure";
      #     };
      #   };
      # };

      xdg.configFile."fcitx5" = {
        source = ./config;
        recursive = true;
      };

      home.activation.removeExistingFcitx5Profile = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm --recursive --force \
          "${config.home'.configDir}/fcitx5/profile" \
          "${config.home'.configDir}/fcitx5/config" \
          "${config.home'.configDir}/fcitx5/conf"
      '';

      home.file."${config.home'.dataDir}/fcitx5/rime" = {
        source = ./rime;
        recursive = true;
      };

      # home.activation.forceRebuildRime = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      #   rm --recursive --force \
      #     "${config.home'.dataDir}/fcitx5/rime"
      # '';
    };
  };
}
