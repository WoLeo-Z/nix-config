{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.zed;
in
{
  options.modules.desktop.apps.editors.zed = {
    enable = mkEnableOption' { };
    enableAI = mkEnableOption' { default = true; };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "catppuccin"
          "catppuccin-icons"
          "nix"
        ];
        mutableUserSettings = false;
        userSettings = lib.mkMerge [
          {
            autosave = "on_focus_change";
            theme = "Catppuccin Mocha";
            icon_theme = "Catppuccin Mocha";
            auto_install_extensions = {
              catppuccin = true;
              catppuccin-icons = true;
              nix = true;
            };

            buffer_font_family = config.stylix.fonts.monospace.name;
            buffer_font_size = 16;
            ui_font_family = ".ZedSans";
            ui_font_size = 16;

            tabs = {
              "file_icons" = false;
              "git_status" = true;
              "show_diagnostics" = "all";
            };

            terminal = {
              font_family = config.stylix.fonts.monospace.name;
              env = {
                EDITOR = "${lib.getExe pkgs.zed-editor} --wait";
              };
            };

            auto_update = false;
            telemetry = {
              diagnostics = false;
              metrics = false;
            };

            title_bar = {
              "show_branch_icon" = false;
              "show_branch_name" = true;
              "show_project_items" = true;
              "show_onboarding_banner" = true;
              "show_user_picture" = false;
              "show_sign_in" = true;
              "show_menus" = false;
            };

            # vim_mode = true;

            project_panel = {
              indent_size = 12;
            };

            git = {
              path_style = "file_name_first";
            };

            git_panel = {
              default_width = 360;
              status_style = "label_color";
            };

            outline_panel = {
              indent_size = 12;
            };

            format_on_save = "off";
            languages = {
              "Nix" = {
                tab_size = 2;
                # formatter = "language_server"; # seems no way to pass any args to nixd
                formatter.external = {
                  command = "${lib.getExe pkgs.nixfmt}";
                  arguments = [ "--strict" ];
                };
                format_on_save = "on";
                enable_language_server = true;
                hard_tabs = false;
                language_servers = [ "nixd" ];
              };
            };
            lsp = {
              nixd = {
                binary.path = "${lib.getExe pkgs.nixd}";
              };
              package-version-server = {
                binary = {
                  path = "${lib.getExe pkgs.package-version-server}";
                };
              };
            };

            notification_panel = {
              dock = "left";
              button = false;
            };

            collaboration_panel.button = false;
          }
          (
            if cfg.enableAI then
              {
                agent = {
                  default_model = {
                    provider = "zed.dev";
                    model = "claude-3-7-sonnet-latest";
                    # provider = "copilot_chat";
                    # model = "o1-mini";
                  };
                };
                features = {
                  edit_prediction_provider = "zed";
                  # edit_prediction_provider = "copilot";
                };
              }
            else
              {
                # https://github.com/zed-industries/zed/issues/7121#issuecomment-2434482066

                features = {
                  edit_prediction_provider = "none";
                  copilot = false;
                };
                assistant = {
                  enabled = false;
                  dock = "left";
                  version = "2";
                };
                assistant_v2.enabled = false;
                chat_panel = {
                  dock = "left";
                  button = "never";
                };
              }
          )
        ];
      };
    };
  };
}
