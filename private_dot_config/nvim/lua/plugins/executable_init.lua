local plugins = {

	"nvim-lua/plenary.nvim",
	---------------------------- notice --------------------------------------
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
	---------------------------- ui --------------------------------------
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		config = function(_, opts)
			require("which-key").setup(opts)
		end,
	},
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		local opts = require("plugins.config.kanagawa")
	-- 		require("kanagawa").setup(opts)
	-- 		vim.cmd.colorscheme("kanagawa")
	-- 	end,
	-- },
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
	---------------------------- comment --------------------------------------
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
	----------------------------- git signs --------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		init = function()
			-- load gitsigns only when a git file is opened
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
					if vim.v.shell_error == 0 then
						vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
						vim.schedule(function()
							require("lazy").load({ plugins = { "gitsigns.nvim" } })
						end)
					end
				end,
			})
		end,
		opts = function()
			return require("plugins.config.others").gitsigns
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
	----------------------------- LSP --------------------------------------------
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
	------------------------- Debug Adapter Protocol -----------------------------
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
	},
	------------------------- file managing and searching ------------------------
	{
		"mikavilpas/yazi.nvim",
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>-",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				-- NOTE: this requires a version of yazi that includes
				-- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
				"<c-up>",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		config = require("plugins.config.telescope").telescope,
	},
}

local config = require("core.utils").load_config()

require("lazy").setup(plugins, config.lazy_nvim)
