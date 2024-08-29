return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		opts = function()
			return require("plugins.lsp.mason")
		end,
		config = function(_, opts)
			require("mason").setup(opts)

			-- custom nvchad cmd to install all mason binaries listed
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end, {})

			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},
	{
		"folke/neodev.nvim",
		init = function()
			require("core.utils").lazy_load("neodev.nvim")
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = function()
			return { override = require("plugins.config.ui").devicons.override }
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = { "LSPAttach" },
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = {
					hide_keyword = true,
				},
				outline = {
					layout = "float",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			require("plugins.lsp.lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					require("plugins.config.others").luasnip(opts)
				end,
			},

			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		opts = function()
			return require("plugins.lsp.cmp")
		end,
	},
}
