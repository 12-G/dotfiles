------------------------------------ autocommands ----------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local utils = require("core.utils")

-- redraw statusline on LspProgressUpdaate
autocmd("User", {
	pattern = "LspProgressUpdate",
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("NvFilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})

				if vim.g.editorconfig then
					require("editorconfig").config(args.buf)
				end
			end)
		end
	end,
})

-- ## EXTRA LOGIC -----------------------------------------------------------
-- 1. Events to load plugins faster → 'BaseFile'/'BaseGitFile'/'BaseDefered':
--    this is pretty much the same thing as the event 'BufEnter',
--    but without increasing the startup time displayed in the greeter.
autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
	desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
	callback = function(args)
		local empty_buffer = vim.fn.resolve(vim.fn.expand("%")) == ""
		local greeter = vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
		local git_repo = utils.run_cmd(
			{ "git", "-C", vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("%")), ":p:h"), "rev-parse" },
			false
		)

		-- For any file exept empty buffer, or the greeter (alpha)
		if not (empty_buffer or greeter) then
			utils.trigger_event("User BaseFile")

			-- Is the buffer part of a git repo?
			if git_repo then
				utils.trigger_event("User BaseGitFile")
			end
		end
	end,
})

autocmd({ "VimEnter" }, {
	desc = "Nvim user event that trigger a few ms after nvim starts",
	callback = function()
		-- If nvim is opened passing a filename, trigger the event inmediatelly.
		if #vim.fn.argv() >= 1 then
			-- In order to avoid visual glitches.
			utils.trigger_event("User BaseDefered", true)
			utils.trigger_event("BufEnter", true) -- also, initialize tabline_buffers.
		else -- Wait some ms before triggering the event.
			vim.defer_fn(function()
				utils.trigger_event("User BaseDefered")
			end, 70)
		end
	end,
})
