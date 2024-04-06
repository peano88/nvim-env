require('go').setup()

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimport()
    end,
    group = format_sync_grp,
})

vim.keymap.set("n", "<leader>gf", vim.cmd.GoTestFunc)
vim.keymap.set("n", "<leader>gl", vim.cmd.GoLint)
vim.keymap.set("n", "<leader>gi", vim.cmd.GoImplements)


