require('refactoring').setup({
    prompt_func_param_type = {
        go = true
    },
    prompt_func_return_type = {
        go = true
    }
})

local telescope = require('telescope')
telescope.load_extension('refactoring')

vim.keymap.set({'n', 'x'},'<leader>rr', function() telescope.extensions.refactoring.refactors() end)
