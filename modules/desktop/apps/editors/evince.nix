{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.evince;
in
{
  options.modules.desktop.apps.editors.evince = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ evince ];

      xdg.mimeApps =
        let
          value = "org.gnome.Evince.desktop";

          associations = builtins.listToAttrs (
            map
              (name: {
                inherit name value;
              })
              [
                "application/pdf"
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
