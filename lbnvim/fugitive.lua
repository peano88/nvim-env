vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>gp", function ()
    vim.cmd.Git [[ pull --rebase ]]
end)
vim.keymap.set("n", "<leader>gr", function ()
    vim.cmd.split()
    vim.api.nvim_command("term git review")
end)

local wk = require("which-key")

wk.register({
    g = {
        name = "Git",
        s = { "Status" },
        p = { "Pull rebase" },
        r = { "Review" },
    }
}, { prefix = "<leader>" })
