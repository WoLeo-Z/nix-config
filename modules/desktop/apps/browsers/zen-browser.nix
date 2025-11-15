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
        # inputs.zen-browser.homeModules.beta
        inputs.zen-browser.homeModules.twilight
        # inputs.zen-browser.homeModules.twilight-official
      ];

      programs.zen-browser = {
        enable = true;
        policies = {
          AutofillAddressesEnabled = false;
          AutoFillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          FirefoxHome = {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            Locked = true;
          };
          Homepage = {
            URL = "about:home";
            Locked = true;
            StartPage = "homepage";
          };
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          SearchBar = "unified";
          SearchSuggestEnabled = true;
          ShowHomeButton = false;
        };
      };

      xdg.mimeApps =
        let
          value =
            let
              zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight; # or beta
            in
            zen-browser.meta.desktopFileName;

          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name value;
              })
              [
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
