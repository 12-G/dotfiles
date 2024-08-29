return {
	"nvim-lua/plenary.nvim",

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = function()
			return require("plugins.config.others").noice
		end,
		config = function(_, opts)
			require("noice").setup(opts)
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		config = function(_, opts)
			require("which-key").setup(opts)
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		-- event = "VeryLazy",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 400,
				lsp_format = "fallback",
			},
		},
	},
}
