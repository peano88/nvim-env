require("oil").setup({
    keymaps = {
        ["q"] = "actions.close",
    },
})

-- whichkey
require("which-key").add({
    { "<leader>m", "<cmd>Oil --float<cr>", desc = "Oil files in floating window" },
    { "<leader>M", "<cmd>Oil<cr>", desc = "Oil files" },
})
