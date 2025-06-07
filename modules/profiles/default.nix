{ lib, ... }:

with lib;
{
  options.modules.profiles = with types; {
    user = mkOpt str "";
    role = mkOpt str "";
    platform = mkOpt str "";
    hardware = mkOpt (listOf str) [ ];
    networks = mkOpt (listOf str) [ ];
  };

  config = {
    # users.mutableUsers = false; # TODO: set user password and set this to true
  };
}
