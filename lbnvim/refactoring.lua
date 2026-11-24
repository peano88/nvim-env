require('refactoring').setup({
    prompt_func_param_type = {
        go = true
    },
    prompt_func_return_type = {
        go = true
    }
})

vim.keymap.set({'n', 'x'},'<leader>rr', function()
  -- this keymap doesn't select any textobject by default, so you may need to provide one each time you use it.
  require("refactoring").select_refactor()
end, { desc = "Select refactor" })
