{ lib, pkgs, ... }:

let
  allowedSigners = pkgs.writeText "git-allowed-signers" ''
    ${lib.constants.users.wol.email} ${lib.constants.users.wol.publicKey}
  '';
  signingKey = pkgs.writeText "git-signing-key" ''
    ${lib.constants.users.wol.publicKey}
  '';
in
{
  hm = {
    home.packages = with pkgs; [
      git
      git-lfs
      gh
    ];

    xdg.configFile."git/config".text = ''
      [user]
          name = ${lib.constants.users.wol.usernames.github}
          email = ${lib.constants.users.wol.email}
      [github]
          user = ${lib.constants.users.wol.usernames.github}
      [gitlab]
          user = ${lib.constants.users.wol.usernames.gitlab}

      [user]
          signingKey = "${signingKey}"

      [gpg]
          format = "ssh"

      [gpg "ssh"]
          allowedSignersFile = "${allowedSigners}"

      [commit]
          gpgSign = true

      [tag]
          gpgSign = true

      # ---

      [merge]
          conflictstyle = "diff3"

      [diff]
          mnemonicPrefix = true
          renames = true
          algorithm = histogram
          colorMoved = plain

      [branch]
          sort = -committerdate

      [tag]
          sort = version:refname

      [pull]
          rebase = true

      [push]
          default = simple
          # Auto create branches and tag on remote
          # might cause problem?
          autoSetupRemote = true
          followTags = true

      [fetch]
          prune = true
          pruneTags = true
          all = true

      [rebase]
          autoSquash = true
          autoStash = true
          updateRefs = true

      [status]
          showUntrackedFiles = "all"

      [init]
          defaultBranch = "main"

      [core]
          quotePath = false
          pager = "${lib.getExe pkgs.delta}"
          # fsmonitor = "{lib.getExe pkgs.rs-git-fsmonitor}"
          # untrackedCache = true

      [gc]
          auto = 0

      [interactive]
          diffFilter = delta --color-only

      [delta]
          navigate = true
          hyperlinks = true
          line-numbers = true;

      [column]
          ui = auto

      [help]
          autocorrect = prompt

      [commit]
          verbose = true

      [rerere]
          enabled = true
          autoupdate = true

      [url "ssh://git@ssh.github.com:443/"]
          insteadOf = https://github.com/
          insteadOf = git@github.com:

      # Alias
      [alias]
          kill-reflog = "reflog expire --all --expire=now --expire-unreachable=now"
    '';
  };
}
