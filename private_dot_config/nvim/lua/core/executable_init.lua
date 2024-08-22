local opt = vim.opt
local g = vim.g
local o = vim.o

-------------------------------------- globals -----------------------------------------
g.mapleader = " "
g.toggle_theme_icon = "   "
-------------------------------------- options -----------------------------------------
o.laststatus = 3
o.showmode = false
o.scrolloff = 4
o.sidescrolloff = 8
o.termguicolors = true
o.showtabline = 2
-- o.statusline = "%!v:lua.require('plugins.statusline.st').run()"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- characters to fill the statuslines
-- 'eob' uses for empty lines at the end of a buffer
opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
-- 'a' means mouse support for normal mode, visual mode, insert mode and command-line mode
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.ruler = false -- show the line and column number of the cursor position

-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.swapfile = false
o.backup = false

opt.whichwrap:append("<>[]hl")

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-------------------------------------- commands ------------------------------------------
local new_cmd = vim.api.nvim_create_user_command

new_cmd("LazyUpdate", function()
	require("lazy").update()
end, {})

new_cmd("LazyProfile", function()
	require("lazy").profile()
end, {})
