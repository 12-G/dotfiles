local map = function(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- general
map("n", "<Esc>", ":noh <CR>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- substitute content with space + s
map("n", "<leader>y", [["+y]]) -- yank into system clipboard
map("n", "<leader>d", [["_d]]) -- black hole register
map("n", "J", "mzJ`z") -- press J and won't change your cursor location
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv") -- make your cursor in the middle screen when search
map("n", "N", "Nzzzv") -- make your cursor in the middle screen when search
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<leader>b", "<cmd> enew <CR>") -- new buffer

-- telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files() <CR>")
map("n", "<leader>fg", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
map("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>")

-- git(telescope)
map("n", "<leader>gc", "<cmd> Telescope git_commits <CR>")
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>")
map("n", "<leader>ma", "<cmd> Telescope marks <CR>")

-- buffer
-- close the current buffer
map("n", "<leader>w", "<cmd>lua require('heirline-components.buffer').close(0) <CR>")
-- close the chosen buffer
map("n", "<leader>wd", function()
	require("heirline-components.all").heirline.buffer_picker(function(bufnr)
		require("heirline-components.buffer").close(bufnr)
	end)
end)
map("n", "<Tab>", function()
	require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
end)
map("n", "<S-Tab>", function()
	require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
end)
