{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "mouse/button-remap" s) hardware) {
    # > lsusb
    # ID 258a:1007 SINOWEALTH Game Mouse

    # > cat /sys/class/input/eventX/device/modalias
    # input:b0003v258Ap1007e0111-e0,1,2,4,k9F,110,111,112,114,r0,1,6,8,B,C,am4,lsfw

    # > sudo evtest
    # (use `evtest` to find the scancodes, like `70029`)

    environment.systemPackages = with pkgs; [
      evtest
    ];

    environment.etc."udev/hwdb.d/99-mouse-button-remap.hwdb".text = ''
      evdev:input:b0003v258Ap1007e0111*
        KEYBOARD_KEY_70029=back
        KEYBOARD_KEY_90004=btn_extra
    '';
  })
]
