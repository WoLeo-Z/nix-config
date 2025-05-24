{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.kernel;
in
{
  options.modules.kernel = mkOpt types.str "default";

  config = mkMerge [
    (mkIf (cfg == "default") { boot.kernelPackages = pkgs.linuxPackages; })
    (mkIf (cfg == "xanmod") { boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; })
  ];
}
