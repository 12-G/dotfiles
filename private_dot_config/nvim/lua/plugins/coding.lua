return {

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			indent = { char = "│", highlight = "IblChar" },
			scope = { char = "│", highlight = "IblScopeChar" },
		},
		config = function(_, opts)
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = "User BaseDefered",
		-- event = { "BufReadPost", "BufNewFile", "BufWritePost" },
		lazy = vim.fn.argc(-1) == 0,
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSInstall", "TSUpdate", "TSInstall" },
		build = ":TSUpdate",
		opts = function()
			return require("plugins.config.ui").treesitter
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
}
