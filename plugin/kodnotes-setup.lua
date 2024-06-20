---@diagnostic disable: undefined-global
vim.g.kodnotes_root = vim.g.kodnotes_root or vim.fn.expand("~/notes")
vim.api.nvim_create_autocmd({"BufEnter",},
	{
		pattern = vim.g.kodnotes_root .. "/*.md",
		callback = function()
			local buffer = vim.api.nvim_win_get_buf(0)
			vim.keymap.set("n", vim.g.kodnotes_prefix .. "f", ":KodnotesFollowLink<CR>", {buffer = buffer})
			vim.keymap.set("n", "<C-]>", ":KodnotesFollowLink<CR>", {buffer = buffer})
			vim.keymap.set("n", vim.g.kodnotes_prefix .. "l", ":KodnotesInsertLink<CR>", {buffer = buffer})
			vim.keymap.set("n", vim.g.kodnotes_prefix .. "n", ":KodnotesNewNote<CR>", {buffer = buffer})
		end,
})

vim.api.nvim_create_user_command("KodnotesNewNote", function ()
	local buf = vim.api.nvim_create_buf(true,false)
	vim.api.nvim_win_set_buf(0, buf)
	-- TODO: replace with nvim_cmd
	vim.api.nvim_command(table.concat({"edit ", vim.g.kodnotes_root, "/", os.date("!%Y%m%d%H%M%S"), ".md"}))
end, {})

vim.api.nvim_create_user_command("KodnotesInsertLink", function()
	require("telescope.builtin").live_grep({
		cwd = vim.g.kodnotes_root,
		glob_pattern = "*.md",
		attach_mappings = function(_, map)
			map("i","<CR>", function(bufnr)
				local action_state = require("telescope.actions.state")
				local selection = action_state.get_selected_entry()
				require("telescope.actions").close(bufnr)
				vim.fn.setreg("m", selection.filename)
				vim.api.nvim_command("norm \"mp")
			end)
			return true
		end
	})
end, {})
vim.api.nvim_create_user_command("KodnotesFollowLink", function()
	vim.api.nvim_command("normal yi]")
	local note_name = vim.fn.getreg(0)
	if vim.fn.filereadable(vim.g.kodnotes_root .. "/" .. note_name .. ".md") then
		vim.api.nvim_command("edit " .. vim.g.kodnotes_root .. "/" .. note_name .. ".md")
	end
end, {})
