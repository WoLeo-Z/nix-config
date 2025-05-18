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
        userSettings = lib.mkMerge [
          {
            autosave = "on_focus_change";
            theme = "Catppuccin Mocha";
            icon_theme = "Catppuccin Mocha";
            auto_install_extension = {
              catppuccin = true;
              catppuccin-icons = true;
              nix = true;
            };

            terminal = {
              font_family = "JetBrainsMono Nerd Font";
              env = {
                EDITOR = "zed --wait";
              };
            };

            auto_update = false;
            telemetry = {
              diagnostics = false;
              metrics = false;
            };
            # vim_mode = true;
            languages = {
              "Nix" = {
                tab_size = 2;
                # formatter = "language_server"; # seems no way to pass any args to nixd
                formatter.external = {
                  command = "${lib.getExe pkgs.nixfmt-rfc-style}";
                  arguments = [ "--strict" ];
                };
                format_on_save = "on";
                enable_language_server = true;
                hard_tabs = false;
                language_servers = [ "nixd" ];
              };
            };
            lsp = {
              "clangd" = {
                binary.path = "${lib.getExe' pkgs.clang-tools "clangd"}";
              };
              "nixd" = {
                binary.path = "${lib.getExe pkgs.nixd}";
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
                assistant = {
                  default_model = {
                    provider = "zed.dev";
                    model = "claude-3-7-sonnet-latest";
                    # provider = "copilot_chat";
                    # model = "o1-mini";
                  };
                  version = "2";
                };
                features = {
                  inline_completion_provider = "zed";
                  # inline_completion_provider = "copilot";
                };
              }
            else
              {
                # https://github.com/zed-industries/zed/issues/7121#issuecomment-2434482066

                features = {
                  inline_completion_provider = "none";
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
