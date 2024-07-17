local wk = require("which-key")

wk.add({
    { "<leader>g",  group = "Git" },
    { "<leader>gl", "<cmd>Git pull<cr>",    desc = "Pull rebase" },
    { "<leader>gp", "<cmd>Git push<cr>",    desc = "Push" },
    { "<leader>gr", function()
        vim.cmd.split()
        vim.api.nvim_command("term git review")
    end, desc = "Review" },
    { "<leader>gs", "<cmd>Git<cr>",  desc = "Status" },
})
