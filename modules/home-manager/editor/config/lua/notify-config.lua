require("notify").setup({})

-- TODO fix colors, grep for colors and fix accordingly
local colors = require("base16-colorscheme").colors
local util = require("util")
util.colorize({
	-- Error
	NotifyERRORBorder = { fg = colors.base0B },
	NotifyERRORIcon = { fg = colors.base0B },
	NotifyERRORTitle = { fg = colors.base0B },
	-- Warn
	NotifyWARNBorder = { fg = colors.baseD },
	NotifyWARNIcon = { fg = colors.baseD },
	NotifyWARNTitle = { fg = colors.baseD },
	-- Info
	NotifyINFOBorder = { fg = colors.base0E },
	NotifyINFOIcon = { fg = colors.base0E },
	NotifyINFOTitle = { fg = colors.base0E },
	-- Debug
	NotifyDEBUGBorder = { fg = colors.base0A },
	NotifyDEBUGIcon = { fg = colors.base0A },
	NotifyDEBUGTitle = { fg = colors.base0A },
	-- Trace
	NotifyTRACEBorder = { fg = colors.base0F },
	NotifyTRACEIcon = { fg = colors.base0F },
	NotifyTRACETitle = { fg = colors.base0F },
})
