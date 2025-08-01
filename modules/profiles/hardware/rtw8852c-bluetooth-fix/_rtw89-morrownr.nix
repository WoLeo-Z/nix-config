# Modified from https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/os-specific/linux/rtw89/default.nix

{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw89";
in
stdenv.mkDerivation {
  pname = "rtw89-morrownr";
  version = "b82ae7d9";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtw89";
    rev = "b82ae7d948534d4abc94c90c67639b23d0d065b4";
    sha256 = "ClSk/5IfmmdHkjfKW1cKYjCPIpOgRjdUmFxSauvnF30=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "FWDIR=${kernel.dev}/lib/firmware/rtw89"
  ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "/lib/modules/\$(KVER)" "${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = " Driver for Realtek 8852AE, 8852BE, and 8853CE, 802.11ax devices";
    homepage = "https://github.com/morrownr/rtw89";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ woleo-z ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.7";
    priority = -1;
  };
}
