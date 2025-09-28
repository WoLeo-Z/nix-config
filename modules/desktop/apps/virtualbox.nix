{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.virtualbox;
in
{
  options.modules.desktop.apps.virtualbox = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

    # VirtualBox conflicts with kvm
    boot.blacklistedKernelModules = [
      "kvm"
      "kvm_intel"
      "kvm_amd"
    ];
  };
}
