return {
	{
		"Alexis12119/nightly.nvim",
		lazy = false,
		config = function()
			local colors = require("nightly.palette").dark_colors
			require("nightly").setup({
				styles = {
					comments = { italic = true },
					functions = { italic = true },
					keywords = { italic = true },
				},
				highlights = {
					IblChar = { fg = "#414753" },
					IblScopeChar = { fg = colors.color7 },
				},
			})

			vim.cmd.colorscheme("nightly")
		end,
	},

	{
		"rebelot/heirline.nvim",
		dependencies = { "zeioth/heirline-components.nvim" },
		event = "User BaseDefered",
		opts = function()
			return require("plugins.config.heirline")
		end,
		config = function(_, opts)
			local heirline = require("heirline")
			local heirline_components = require("heirline-components.all")

			heirline_components.init.subscribe_to_events()
			heirline.load_colors(heirline_components.hl.get_colors())
			heirline.setup(opts)
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		event = "User FilePost",
		opts = {
			user_default_options = { names = false },
			filetypes = {
				"*",
				"!lazy",
			},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},
}
