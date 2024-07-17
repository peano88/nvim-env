require('bazel_nvim').setup()

local wk = require("which-key")

wk.add(
    {
        { "<leader>b",  group = "Bazel" },
        { "<leader>bg", "<cmd>:BazelGazelle<cr>",     desc = "Run gazelle" },
        { "<leader>bq", "<cmd>:BazelQuery<cr>",       desc = "Run query" },
        { "<leader>bs", "<cmd>:BazelTestSelect<cr>",  desc = "Run tests selecting the folder" },
        { "<leader>bt", "<cmd>:BazelTest<cr>",        desc = "Run tests of the same level of the opened file" },
        { "<leader>bw", "<cmd>:BazelQuerySelect<cr>", desc = "Run query selecting the folder" },
    })
