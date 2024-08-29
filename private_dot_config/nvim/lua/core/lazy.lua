local E = {}

E.echo = function(str) -- used for show messages in cmdline.
	vim.cmd("redraw")
	vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

--------- lazy.nvim ---------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	E.echo("  Installing lazy.nvim & plugins ...")
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local config = require("plugins.config.lazy_nvim")
require("lazy").setup({
	spec = { { import = "plugins" } },
	config,
})

require("core.keymap")
