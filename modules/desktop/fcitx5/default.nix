{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.fcitx5;

  # https://github.com/xddxdd/nixos-config/blob/3704ff233cde3452040b24e86283b164d605f7ca/nixos/client-apps/fcitx/rime-lantian-custom.nix
  fcitx5-rime-with-addons =
    (pkgs.fcitx5-rime.override {
      librime = pkgs.nur.repos.xddxdd.lantianCustomized.librime-with-plugins;
      rimeDataPkgs = with pkgs; [
        nur.repos.xddxdd.rime-aurora-pinyin
        nur.repos.xddxdd.rime-custom-pinyin-dictionary
        nur.repos.xddxdd.rime-dict
        nur.repos.xddxdd.rime-ice
        nur.repos.xddxdd.rime-moegirl
        nur.repos.xddxdd.rime-zhwiki
        rime-data
      ];
    }).overrideAttrs
      (old: {
        # Prebuild schema data
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.parallel ];
        postInstall =
          (old.postInstall or "")
          + ''
            for F in $out/share/rime-data/*.schema.yaml; do
              echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
            done
            parallel -j$(nproc) < parallel.lst || true
          '';
      });
in
{
  options.modules.desktop.fcitx5 = {
    enable = lib.mkEnableOption' { };
  };

  config = lib.mkIf cfg.enable {
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
            fcitx5-gtk
            fcitx5-rime-with-addons
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

      systemd.user.services = {
        "fcitx5" = {
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
          Unit = {
            PartOf = [ "graphical-session.target" ];
            After = [
              "graphical-session.target"
              "xwayland-satellite.service"
            ];
          };
          Service = {
            ExecStart = "${lib.getExe' config.i18n.inputMethod.package "fcitx5"} --replace";
            Restart = "on-failure";
          };
        };
      };

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
    };

    # stylix.targets.fcitx5.enable = false;
  };
}
