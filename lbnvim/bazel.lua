require('bazel_nvim').setup()

local wk = require("which-key")

wk.register({
    ["<leader>"] = {
        b = {
            name = "Bazel",
            t = {"<cmd>:BazelTest<cr>", "Run tests of the same level of the opened file"},
            s = {"<cmd>:BazelTestSelect<cr>", "Run tests selecting the folder"},
            g = {"<cmd>:BazelGazelle<cr>", "Run gazelle"},
            q = {"<cmd>:BazelQuery<cr>", "Run query"},
            w = {"<cmd>:BazelQuerySelect<cr>", "Run query selecting the folder"},
        },
    },
})
