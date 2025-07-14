{
  hm = {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = true;

        format =
          "[╭](fg:base02)"
          + "$status"
          + "$directory"
          + "$git_branch"
          + "$git_status"
          + "$fill"
          + "$cmd_duration"
          + "$time"
          + "$line_break"
          + "[╰](fg:base02)"
          + "$character";

        palettes.catppuccin_mocha = {
          white = "#D9E0EE";
          base02 = "#2E2E3E";
          blue = "#8AADF4";
          cyan = "#76E3F6";
          green = "#A6E3A1";
          orange = "#F9AF74";
          pink = "#F5BDE6";
          magenta = "#CBA6F7";
          red = "#F38BA8";
          yellow = "#F9E2AF";
          status = "#E23140";
        };

        status = {
          format = "[─](fg:base02)[](fg:orange)[](fg:base02 bg:orange)[](fg:orange bg:base02)[ $status](fg:white bg:base02)[](fg:base02)";
          pipestatus = true;
          pipestatus_separator = "-";
          pipestatus_segment_format = "$status";
          pipestatus_format = "[─](fg:base02)[](fg:orange)[](fg:base02 bg:orange)[](fg:orange bg:base02)[ $pipestatus](fg:white bg:base02)[](fg:base02)";
          disabled = false;
        };

        directory = {
          format = "[─](fg:base02)[](fg:white)[](fg:base02 bg:white)[](fg:white bg:base02)[ $read_only$truncation_symbol$path](fg:white bg:base02)[](fg:base02)";
          truncation_length = 0;
        };

        git_branch = {
          format = "[─](fg:base02)[](fg:green)[$symbol](fg:base02 bg:green)[](fg:green bg:base02)[ $branch](fg:white bg:base02)";
          symbol = "";
        };

        git_status = {
          format = "[$all_status](fg:green bg:base02)[](fg:base02)";
          conflicted = " =";
          up_to_date = "";
          untracked = " ?\${count}";
          stashed = " $";
          modified = " !\${count}";
          staged = " +";
          renamed = " »";
          deleted = " ✘";
          ahead = " ⇡\${count}";
          diverged = " ⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = " ⇣\${count}";
        };

        fill = {
          symbol = "─";
          style = "fg:base02";
        };

        cmd_duration = {
          min_time = 500;
          format = "[─](fg:base02)[](fg:orange)[](fg:base02 bg:orange)[](fg:orange bg:base02)[ $duration](fg:white bg:base02)[](fg:base02)";
        };

        time = {
          format = "[─](fg:base02)[](fg:magenta)[󰥔](fg:base02 bg:magenta)[](fg:magenta bg:base02)[ $time](fg:white bg:base02)[](fg:base02)";
          time_format = "%H:%M";
          disabled = false;
        };

        character = {
          success_symbol = "[](fg:bold white)";
          error_symbol = "[×](fg:bold red)";
        };
      };
    };

    stylix.targets.starship.enable = true;
  };
}
