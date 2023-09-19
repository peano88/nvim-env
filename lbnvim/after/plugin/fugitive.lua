vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>gmc", function ()
    vim.cmd.Git [[ config --global user.email lorenzo.bompani@ingenico.com ]]
    vim.cmd.Git [[ config --global user.name Lorenzo BOMPANI ]]
end)
