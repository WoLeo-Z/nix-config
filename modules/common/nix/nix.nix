# Referenced from: https://github.com/sukhmancs/nixos-configs/blob/4578594ef84c39e4e92558fa45e99dfebc5dc635/modules/shared/nix/default.nix
{ pkgs, config, ... }:

{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    # Run the Nix daemon on lowest possible priority so that my system
    # stays responsive during demanding tasks such as GC and builds.
    # This is especially useful while auto-gc and auto-upgrade are enabled
    # as they can be quite demanding on the CPU.
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # Garbage collection weekly and delete generations
    # older than 10 days
    gc = {
      automatic = !config.programs.nh.clean.enable;
      dates = "Sat *-*-* 03:00";
      options = "--delete-older-than 10d";
    };

    # Optimise nix store. Manual way: nix-store --optimise
    optimise = {
      automatic = true;
      dates = [ "04:00" ];
    };

    # We use flakes, so we do need tools related to nix-channel
    channel.enable = false;

    settings = {
      # tell nix to use the xdg spec for base directories
      # while transitioning, any state must be carried over
      # manually, as Nix won't do it for us
      use-xdg-base-directories = true;

      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # automatically optimise symlinks
      auto-optimise-store = true;

      # allow sudo users to mark the following values as trusted
      allowed-users = [
        "root"
        "@wheel"
        "nix-builder"
      ];

      # only allow sudo users to manage the nix store
      trusted-users = [
        "root"
        "@wheel"
        "nix-builder"
      ];

      # let the system decide the number of max jobs
      max-jobs = "auto";

      # build inside sandboxed environments
      sandbox = true;
      sandbox-fallback = false;

      # supported system features
      system-features = [
        "nixos-test"
        "kvm"
        "recursive-nix"
        "big-parallel"
      ];

      # continue building derivations if one fails
      keep-going = true;

      # bail early on missing cache hits
      connect-timeout = 5;

      # show more log lines for failed builds
      log-lines = 30;

      # enable new nix command and flakes
      # and also "unintended" recursion as well as content addressed nix
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        # "recursive-nix" # let nix invoke itself # Lix 2.93 does not support this
        # "ca-derivations" # content addressed nix # removed since Lix 2.94
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "cgroups" # allow nix to execute builds inside cgroups
      ];

      # don't warn me that my git tree is dirty, I know
      warn-dirty = false;

      # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
      http-connections = 50;

      # whether to accept nix configuration from a flake without prompting
      accept-flake-config = false;

      # execute builds inside cgroups
      use-cgroups = true;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # use binary cache, this is not gentoo
      # external builders can also pick up those substituters
      builders-use-substitutes = true;

      # the maximum number of substitution jobs Nix will run in parallel
      max-substitution-jobs = 50;

      # substituters to use
      substituters = [
        # Status: https://mirrors.cernet.edu.cn/list/nix-channels
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"

        # Cache
        "https://cache.nixos.org" # funny binary cache
        "https://nix-community.cachix.org" # nix-community cache
        "https://cache.garnix.io" # garnix binary cache, hosts prismlauncher
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}
