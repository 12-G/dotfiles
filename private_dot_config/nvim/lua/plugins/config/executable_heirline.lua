local lib = require("heirline-components.all")
local frappe_base = "#303446"
local frappe_green = "#a6d189"
local frappe_maroon = "#ea999c"

return {
	tabline = { -- UI upper bar
		lib.component.tabline_conditional_padding(),
		lib.component.tabline_buffers(),
		lib.component.fill({ hl = { bg = frappe_base } }),
		lib.component.tabline_tabpages(),
	},

	statusline = { -- UI statusbar
		hl = { fg = "fg", bg = "bg" },
		lib.component.mode({ mode_text = {} }),
		lib.component.git_branch(),
		lib.component.file_info({
			filename = {},
			filetype = false,
		}),
		lib.component.git_diff(),
		lib.component.diagnostics(),
		lib.component.fill(),
		lib.component.cmd_info(),
		lib.component.fill(),
		lib.component.lsp({ hl = { fg = frappe_green } }),
		lib.component.compiler_state(),
		lib.component.virtual_env(),
		lib.component.nav({ hl = { fg = frappe_maroon } }),
		lib.component.mode({ surround = { separator = "right" } }),
	},
}
