{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.claude-code;
in
{
  options.modules.desktop.apps.claude-code = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
        claude-code
        claude-code-router
        # pkgs.cherry-studio
      ];
    };
  };
}
