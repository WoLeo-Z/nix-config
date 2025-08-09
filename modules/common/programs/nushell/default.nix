{ pkgs, ... }:

{
  hm = {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      extraConfig = ''
        # Directories in this constant are searched by the
        # `use` and `source` commands.
        const NU_LIB_DIRS = $NU_LIB_DIRS ++ ['${pkgs.nu_scripts}/share/nu_scripts']

        # Completion

        # We use external_completer instead
        # use custom-completions/curl/curl-completions.nu *
        # use custom-completions/git/git-completions.nu *
        # use custom-completions/just/just-completions.nu *
        # use custom-completions/make/make-completions.nu *
        # use custom-completions/man/man-completions.nu *
        # use custom-completions/nix/nix-completions.nu *
        # use custom-completions/ssh/ssh-completions.nu *
        # use custom-completions/tar/tar-completions.nu *

        # external_completer
        # Source: https://www.nushell.sh/cookbook/external_completers.html

        let fish_completer = {|spans|
            fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
            | from tsv --flexible --noheaders --no-infer
            | rename value description
            | update value {|row|
              let value = $row.value
              let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
              if ($need_quote and ($value | path exists)) {
                let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
                $'"($expanded_path | str replace --all "\"" "\\\"")"'
              } else {$value}
            }
        }

        let carapace_completer = {|spans: list<string>|
            carapace $spans.0 nushell ...$spans
            | from json
            | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
        }

        # This completer will use carapace by default
        let external_completer = {|spans|
            let expanded_alias = scope aliases
            | where name == $spans.0
            | get -o 0.expansion

            let spans = if $expanded_alias != null {
                $spans
                | skip 1
                | prepend ($expanded_alias | split row ' ' | take 1)
            } else {
                $spans
            }

            match $spans.0 {
                # fish completes commits and branch names in a nicer way
                # git => $fish_completer
                _ => $fish_completer
            } | do $in $spans
        }

        $env.config.completions.external = {
            enable: true
            completer: $external_completer
        }

        # Aliases
        use aliases/git/git-aliases.nu *
        use aliases/eza/eza-aliases.nu *
        use aliases/bat/bat-aliases.nu *
      '';
    };

    stylix.targets.nushell.enable = true;
  };
}
