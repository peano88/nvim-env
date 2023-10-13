require('refactoring').setup({
    prompt_func_param_type = {
        go = true
    },
    prompt_func_return_type = {
        go = true
    }
})

require('telescope').load_extension('refactoring')

vim.keymap.set({'n', 'x'},'<leader>rr', function() require('telescope').extensions.refactoring.refactors() end)
