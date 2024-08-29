local E = {}

E.lazy_load = function(plugin)
	vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
		callback = function()
			local file = vim.fn.expand("%") -- find explanation in ":h expand"
			-- when the cursor in nvimtree plugin, the buffer name changes to NvimTree_1.
			-- Also, when opening the Lazy profile, the buffer name changes to "".
			local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

			if condition then
				vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

				-- dont defer for treesitter as it will show slow highlighting
				-- This deferring only happens only when we do "nvim filename"
				if plugin ~= "nvim-treesitter" then
					vim.schedule(function()
						require("lazy").load({ plugins = plugin })

						if plugin == "nvim-lspconfig" then
							vim.cmd("silent! do FileType")
						end
					end)
				else
					require("lazy").load({ plugins = plugin })
				end
			end
		end,
	})
end

E.lsp_ft = function(type)
	type = type or nil
	local ft = {}
	ft.backend = {
		"go",
		"lua",
		"sh",
		"rust",
		"c",
		"cpp",
		"zig",
		"python",
	}

	ft.frontend = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"json",
	}
	if not type then
		return vim.list_extend(ft.backend, ft.frontend)
	end
	return ft[type]
end

E.diag_config = function()
	local t = {
		"Error",
		"Warn",
		"Info",
		"Hint",
	}
	for _, type in ipairs(t) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = "⯈", texthl = hl, numhl = hl })
	end

	vim.diagnostic.config({
		signs = true,
		severity_sort = true,
		virtual_text = true,
	})

	vim.lsp.set_log_level("OFF")

	--disable diagnostic in neovim test file *_spec.lua
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("DisableInSpec", { clear = true }),
		pattern = "lua",
		callback = function(opt)
			local fname = vim.api.nvim_buf_get_name(opt.buf)
			if fname:find("%w_spec%.lua") then
				vim.diagnostic.disable(opt.buf)
			end
		end,
	})
end

E.run_cmd = function(cmd, show_error)
	if type(cmd) == "string" then
		cmd = vim.split(cmd, " ")
	end
	if vim.fn.has("win32") == 1 then
		cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
	end
	local result = vim.fn.system(cmd)
	local success = vim.api.nvim_get_vvar("shell_error") == 0
	if not success and (show_error == nil or show_error) then
		vim.api.nvim_err_writeln(
			("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result)
		)
	end
	return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

E.trigger_event = function(event, is_urgent)
	-- define behavior
	local function trigger()
		local is_user_event = string.match(event, "^User ") ~= nil
		if is_user_event then
			event = event:gsub("^User ", "")
			vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
		else
			vim.api.nvim_exec_autocmds(event, { modeline = false })
		end
	end

	-- execute
	if is_urgent then
		trigger()
	else
		vim.schedule(trigger)
	end
end

return E
