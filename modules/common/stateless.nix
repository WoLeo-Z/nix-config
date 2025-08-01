{
  lib,
  config,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.stateless;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.modules.stateless = {
    enable = mkEnableOption' { };
  };

  options.stateless = {
    # Defination: https://github.com/nix-community/impermanence/blob/4b3e914cdf97a5b536a889e939fb2fd2b043a170/home-manager.nix#L78
    directories = mkOption {
      type = types.listOf (
        types.coercedTo types.str (directory: { inherit directory; }) (submodule {
          options = {
            directory = mkOption {
              type = str;
              description = "The directory path to be linked.";
            };
            method = mkOption {
              type = types.enum [
                "bindfs"
                "symlink"
              ];
              default = config.defaultDirectoryMethod;
              description = ''
                The linking method to be used for this specific
                directory entry. See
                <literal>defaultDirectoryMethod</literal> for more
                information on the tradeoffs.
              '';
            };
          };
        })
      );
      default = [ ];
    };
    files = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    user = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkMerge [
    {
      # Create some aliases for the directories and files to be persisted
      environment.persistence."/persist" = {
        enable = mkDefault false;

        # sets the mount option x-gvfs-hide on all the bind mounts
        # to hide them from the file manager
        hideMounts = true;

        directories = mkAliasDefinitions options.stateless.directories;
        files = mkAliasDefinitions options.stateless.files;
        users."${config.modules.profile.user}" = mkAliasDefinitions options.stateless.user;
      };
    }

    (mkIf cfg.enable {
      environment.persistence."/persist".enable = true;

      boot.tmp.useTmpfs = true;

      environment.systemPackages = with pkgs; [
        persist
        # ncdu # `sudo ncdu -x /`
      ];

      # There are two ways to clear the root filesystem on every boot:
      ##  1. use tmpfs for /
      ##  2. (btrfs/zfs only)take a blank snapshot of the root filesystem and revert to it on every boot via:
      ##     boot.initrd.postDeviceCommands = ''
      ##       mkdir -p /run/mymount
      ##       mount -o subvol=/ /dev/disk/by-uuid/UUID /run/mymount
      ##       btrfs subvolume delete /run/mymount
      ##       btrfs subvolume snapshot / /run/mymount
      ##     '';
      #
      #  See also https://grahamc.com/blog/erase-your-darlings/

      stateless = {
        directories = [
          "/etc/NetworkManager/system-connections"
          "/etc/ssh"
          "/etc/nix/inputs"
          "/etc/secureboot" # lanzaboote - secure boot
          # my secrets
          "/etc/agenix"

          "/var/cache"
          "/var/lib"
          "/var/log"

          # created by modules/nixos/misc/fhs-fonts.nix
          # for flatpak apps
          # "/usr/share/fonts"
          # "/usr/share/icons"
        ];

        files = [ "/etc/machine-id" ];
      };

      stateless.user = {
        # the following directories will be passed to /persist/home/$USER
        directories = [
          ".cache/nix"
          ".cache/pre-commit"
          ".cache/treefmt"

          "codes"
          "nix-config"
          "tmp"

          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"

          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }

          # misc
          ".config/pulse"
          ".pki"
          ".steam" # steam games

          # remote desktop
          ".config/remmina"
          ".config/freerdp"

          # doom-emacs
          ".config/emacs"
          "org" # org files

          # vscode
          ".vscode"
          ".vscode-insiders"
          ".config/Code/User"
          ".config/Code - Insiders/User"

          # zed editor
          ".config/zed"

          # browsers
          ".mozilla"
          ".config/google-chrome"

          # neovim / remmina / flatpak / ...
          ".local/share"
          ".local/state"

          # language package managers
          ".npm"
          ".conda" # generated by `conda-shell`
          "go"
          ".cargo" # rust
          ".m2" # maven
          ".gradle" # gradle

          # neovim plugins(wakatime & copilot)
          ".wakatime"
          ".config/github-copilot"

          # others
          ".config/blender"
          ".config/LDtk"

          # IM
          ".config/QQ"
          ".xwechat"
        ];
        files = [
          ".wakatime.cfg"
          ".config/nushell/history.txt"
        ];
      };
    })
  ];
}
