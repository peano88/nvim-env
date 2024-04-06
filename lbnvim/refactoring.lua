require('refactoring').setup({
    prompt_func_param_type = {
        go = true
    },
    prompt_func_return_type = {
        go = true
    }
})

local telescope_module = require('telescope')
telescope_module.load_extension('refactoring')

vim.keymap.set({'n', 'x'},'<leader>rr', function() telescope_module.extensions.refactoring.refactors() end)
