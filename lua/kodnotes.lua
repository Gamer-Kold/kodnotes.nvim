local M = {}


local function do_autocmds(dir, prefix)
	vim.api.nvim_create_autocmd({"BufEnter",},
		{
			pattern = dir .. "/*.md",
			callback = function()
				local buffer = vim.api.nvim_win_get_buf(0)
				vim.keymap.set("n", prefix .. "f", ":KodnotesFollowLink<CR>", {buffer = buffer})
				vim.keymap.set("n", "<C-]>",       ":KodnotesFollowLink<CR>", {buffer = buffer})
				vim.keymap.set("n", prefix .. "l", ":KodnotesInsertLink<CR>", {buffer = buffer})
				vim.keymap.set("n", prefix .. "n", ":KodnotesNewNote<CR>",    {buffer = buffer})
				vim.api.nvim_create_user_command("KodnotesNewNote", function ()
					local buf = vim.api.nvim_create_buf(true,false)
					vim.api.nvim_win_set_buf(0, buf)
					vim.api.nvim_command(table.concat({"edit ", dir, "/", os.date("!%Y%m%d%H%M%S"), ".md"}))
				end, {})

				vim.api.nvim_create_user_command("KodnotesNewNoteDir", function (opts)
					local buf = vim.api.nvim_create_buf(true,false)
					vim.api.nvim_win_set_buf(0, buf)
					vim.api.nvim_command(table.concat({"edit ", dir, "/", opts.fargs[1], "/", os.date("!%Y%m%d%H%M%S"), ".md"}))
				end, {nargs = 1})

				vim.api.nvim_create_user_command("KodnotesNewLitNote", function ()
					vim.api.nvim_command("KodnotesNewNoteDir literature_notes")
				end, {})

				vim.api.nvim_create_user_command("KodnotesInsertLink", function()
					require("telescope.builtin").live_grep({
						cwd = dir,
						glob_pattern = "*.md",
						attach_mappings = function(_, map)
							map("i","<CR>", function(bufnr)
								local action_state = require("telescope.actions.state")
								local selection = action_state.get_selected_entry()
								require("telescope.actions").close(bufnr)
								vim.fn.setreg("m", "[[" .. string.match(selection.filename, "%d+") .. "]]")
								vim.api.nvim_command("norm \"mp")
							end)
							return true
						end
					})
				end, {})
				vim.api.nvim_create_user_command("KodnotesFollowLink", function()
					vim.api.nvim_command("normal \"myi]")
					local note_name = vim.fn.getreg('m')
					if vim.fn.filereadable(dir .. "/" .. note_name .. ".md") then
						vim.api.nvim_command("edit " .. dir .. "/" .. note_name .. ".md")
					elseif vim.fn.filereadable(dir .. "/" .. note_name) then
					end
				end, {})
			end,
			group = "kodnotes",
		})
end

function M.setup(config) 
	vim.api.nvim_create_augroup("kodnotes", {clear = true})
	for key, dir in pairs(config.dirs) do
		do_autocmds(vim.fn.expand(dir), config.prefix)
	end
end
return M
