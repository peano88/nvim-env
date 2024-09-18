local telescope = require('telescope')
local builtin = require('telescope.builtin')
local telescopeConfig = require("telescope.config")
local utils = require("lbnvim.utils")

-- Clone the default Telescope configuration
local vimgrep_arguments = {}
for _,v in ipairs(telescopeConfig.values.vimgrep_arguments) do
    table.insert(vimgrep_arguments, v)
end

utils.insert_if_not_exists(vimgrep_arguments, "--hidden", "--glob", "!**/.git/*")

telescope.setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
    extensions = {
        file_browser = {
            hijack_netrw = true,
            display_stat = { date = false, size = false, mode = false }
        },
    },
})

telescope.load_extension "file_browser"

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fp', builtin.document_symbols, {})
vim.keymap.set('n', '<leader>fs', function()
	builtin.live_grep({ glob_pattern = "!.git/*" });
end)
vim.keymap.set('n', '<leader>fw', function()
    builtin.grep_string({search = vim.fn.expand('<cword>')})
end)

-- grep in selected folder
vim.keymap.set('n', '<leader>fr', function()
    -- curernt file directory
    local current_dir = vim.fn.expand('%:p:h')
    local dir = vim.fn.input("Folder: ", current_dir)
    builtin.live_grep({ glob_pattern = "!.git/*", cwd = dir})
end)


vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function (args)
        if vim.fn.isdirectory(args.data.bufname) ~= 0 then
            vim.wo.wrap = true
            vim.wo.number = true
        end
    end,
})
