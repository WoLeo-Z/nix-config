{ lib }:

let
  inherit (lib) mkOption types;
in
{
  mkOpt = type: default: mkOption { inherit type default; };

  mkOpt' =
    type: default: description:
    mkOption { inherit type default description; };

  mkEnableOption' =
    {
      default ? false,
    }:
    mkOption {
      inherit default;
      type = types.bool;
      example = true;
    };
}
