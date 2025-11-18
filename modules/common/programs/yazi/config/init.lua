require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

require("git"):setup()

require("restore"):setup({
    -- Set the position for confirm and overwrite prompts.
    -- Don't forget to set height: `h = xx`
    -- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
    position = { "center", w = 70, h = 40 }, -- Optional

    -- Show confirm prompt before restore.
    -- NOTE: even if set this to false, overwrite prompt still pop up
    show_confirm = true,  -- Optional

    -- Suppress success notification when all files or folder are restored.
    suppress_success_notification = true,  -- Optional

    -- colors for confirm and overwrite prompts
    theme = { -- Optional
      -- Default using style from your flavor or theme.lua -> [confirm] -> title.
      -- If you edit flavor or theme.lua you can add more style than just color.
      -- Example in theme.lua -> [confirm]: title = { fg = "blue", bg = "green"  }
      title = "blue", -- Optional. This value has higher priority than flavor/theme.lua

      -- Default using style from your flavor or theme.lua -> [confirm] -> content
      -- Sample logic as title above
      header = "green", -- Optional. This value has higher priority than flavor/theme.lua

      -- header color for overwrite prompt
      -- Default using color "yellow"
      header_warning = "yellow", -- Optional
      -- Default using style from your flavor or theme.lua -> [confirm] -> list
      -- Sample logic as title and header above
      list_item = { odd = "blue", even = "blue" }, -- Optional. This value has higher priority than flavor/theme.lua
    },
})

require("yatline"):setup({
	show_background = false,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{type = "line", custom = false, name = "tabs", params = {"left"}},
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
				-- {type = "string", custom = false, name = "date", params = {"%A, %d %B %Y"}},
			},
			section_b = {
				-- {type = "string", custom = false, name = "date", params = {"%X"}},
			},
			section_c = {
			}
		}
	},

	status_line = {
		left = {
			section_a = {
				{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
				{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
				{type = "string", custom = false, name = "hovered_path"},
				{type = "coloreds", custom = false, name = "count"},
			}
		},
		right = {
			section_a = {
				{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
				{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
				{type = "string", custom = false, name = "hovered_file_extension", params = {true}},
				{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})
