{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.papers;
in
{
  options.modules.desktop.apps.editors.papers = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ papers ];
    hm.xdg.mimeApps =
      let
        value = "org.gnome.Papers.desktop";

        associations = builtins.listToAttrs (map (name: { inherit name value; }) [ "application/pdf" ]);
      in
      {
        # associations.added = associations;
        defaultApplications = associations;
      };
  };
}
