require("core") -- load options

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- bootstrap lazy.nvim
if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").lazy(lazypath) -- load plugins after installation of lazy.nvim
end

vim.opt.rtp:prepend(lazypath)
require("plugins") -- alwayas load plugins
require("core.autocommands")
