{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.browsers.zen-browser;
in
{
  options.modules.desktop.apps.browsers.zen-browser = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      imports = [
        inputs.zen-browser.homeModules.beta
        # inputs.zen-browser.homeModules.twilight
        # inputs.zen-browser.homeModules.twilight-official
      ];

      programs.zen-browser = {
        enable = true;
        # profiles.default.settings = { };
      };

      xdg.mimeApps =
        let
          value =
            let
              zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta; # or twilight
            in
            zen-browser.meta.desktopFileName;

          associations = builtins.listToAttrs (
            map (name: { inherit name value; }) [
              "application/x-extension-shtml"
              "application/x-extension-xhtml"
              "application/x-extension-html"
              "application/x-extension-xht"
              "application/x-extension-htm"
              "x-scheme-handler/unknown"
              "x-scheme-handler/mailto"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "application/xhtml+xml"
              "application/json"
              "text/plain"
              "text/html"
            ]
          );
        in
        {
          # associations.added = associations;
          defaultApplications = associations;
        };
    };
  };
}
