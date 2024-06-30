-- TODO themes, grep for colors and replace accordingly
local colors = require("base16-colorscheme").colors

local components = {
	active = { {}, {}, {} },
	inactive = {},
}

-- Disable status bar on these buffers
local disable = {
	filetypes = {
		"^NvimTree$",
		"^packer$",
		"^startify$",
		"^fugitive$",
		"^fugitiveblame$",
		"^qf$",
		"^help$",
		"^minimap$",
		"^Trouble$",
		"^dap-repl$",
		"^dapui_watches$",
		"^dapui_stacks$",
		"^dapui_breakpoints$",
		"^dapui_scopes$",
	},
	buftypes = {
		"^terminal$",
	},
	bufnames = {},
}

-- Better lsp client retrieval than built in
local get_lsp_client = function(component)
	local msg = "No Active Lsp"

	local clients = vim.lsp.buf_get_clients()
	if next(clients) == nil then
		return msg
	end

	local client_names = ""
	for _, client in pairs(clients) do
		if string.len(client_names) < 1 then
			client_names = client_names .. client.name
		else
			client_names = client_names .. ", " .. client.name
		end
	end
	return string.len(client_names) > 0 and client_names or msg
end

-- LEFT
-- Circle icon
components.active[1][1] = {
	provider = "",
	hl = {
		fg = colors.base03,
		bg = colors.base05,
	},
	left_sep = {
		str = "left_rounded",
		hl = {
			fg = colors.base03,
			bg = colors.base00,
		},
	},
	right_sep = {
		str = " ",
		hl = {
			fg = colors.base03,
			bg = colors.base05,
		},
	},
}

-- File icon, name, status
components.active[1][2] = {
	provider = {
		name = "file_info",
		opts = {
			file_readonly_icon = "",
			file_modified_icon = "",
		},
	},
	-- enabled = buffer_not_empty,
	hl = {
		fg = colors.base06,
		bg = colors.base03,
	},
	left_sep = {
		str = " ",
		hl = {
			fg = colors.base03,
			bg = colors.base03,
		},
	},
	right_sep = {
		str = " ",
		hl = {
			fg = colors.base03,
			bg = colors.base03,
		},
	},
}

-- File size
components.active[1][3] = {
	provider = "file_size",
	-- enabled = buffer_not_empty,
	hl = {
		fg = colors.base06,
		bg = colors.base03,
	},
}

-- End of left side
components.active[1][4] = {
	provider = "",
	hl = {
		fg = colors.base03,
		bg = colors.base00,
	},
}

-- Middle
-- LSP icon
components.active[2][1] = {
	provider = "",
	hl = {
		fg = colors.base0F,
		bg = colors.base03,
	},
	left_sep = {
		str = "left_rounded",
		hl = {
			fg = colors.base03,
			bg = colors.base00,
		},
	},
	right_sep = {
		str = " ",
		hl = {
			fg = colors.base03,
			bg = colors.base03,
		},
	},
}

-- LSP client names
components.active[2][2] = {
	provider = get_lsp_client,
	hl = {
		fg = colors.base0F,
		bg = colors.base03,
	},
}

-- LSP errors
components.active[2][3] = {
	provider = "diagnostic_errors",
	hl = {
		fg = colors.base0B,
		bg = colors.base03,
	},
}

-- LSP warns
components.active[2][4] = {
	provider = "diagnostic_warnings",
	hl = {
		fg = colors.base0C,
		bg = colors.base03,
	},
}

-- LSP infos
components.active[2][5] = {
	provider = "diagnostic_info",
	hl = {
		fg = colors.base0E,
		bg = colors.base03,
	},
}

-- LSP hints
components.active[2][6] = {
	provider = "diagnostic_hints",
	hl = {
		fg = colors.base0A,
		bg = colors.base03,
	},
}

-- End of middle
components.active[2][7] = {
	provider = "",
	hl = {
		fg = colors.base03,
		bg = colors.base00,
	},
}

-- Right
-- Git branch
components.active[3][1] = {
	provider = "git_branch",
	enabled = require("feline.providers.git").git_info_exists,
	hl = {
		fg = colors.base0A,
		bg = colors.base00,
	},
}

-- # added lines
components.active[3][2] = {
	provider = "git_diff_added",
	hl = {
		fg = colors.base0E,
		bg = colors.base00,
	},
}

-- # changed lines
components.active[3][3] = {
	provider = "git_diff_changed",
	hl = {
		fg = colors.base0C,
		bg = colors.base00,
	},
}

-- # removed linces
components.active[3][4] = {
	provider = "git_diff_removed",
	hl = {
		fg = colors.base0D,
		bg = colors.base00,
	},
}

-- Extra space
components.active[3][5] = {
	provider = " ",
	hl = {
		fg = colors.base00,
		bg = colors.base00,
	},
}

-- VI mode name
components.active[3][6] = {
	provider = "vi_mode",
	icon = "",
	hl = {
		fg = colors.base03,
		bg = colors.base08,
	},
	left_sep = {
		str = "left_rounded",
		hl = {
			fg = colors.base08,
			bg = colors.base00,
		},
	},
	right_sep = {
		str = " ",
		hl = {
			fg = colors.base08,
			bg = colors.base08,
		},
	},
}

-- Line percent
components.active[3][7] = {
	provider = "line_percentage",
	hl = {
		fg = colors.base03,
		bg = colors.base05,
	},
	left_sep = {
		str = " ",
		hl = {
			fg = colors.base05,
			bg = colors.base05,
		},
	},
	right_sep = {
		str = "right_rounded",
		hl = {
			fg = colors.base05,
			bg = colors.base00,
		},
	},
}

-- Disable bar on inactive windows
components.inactive = components.active

require("feline").setup({
	components = components,
	disable = disable,
})
