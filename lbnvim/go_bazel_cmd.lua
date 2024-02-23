local go_bazel = require('lbnvim.go_bazel')

vim.api.nvim_create_user_command('BazelTest',
function()
    go_bazel.bazel_test()
end, {})

vim.api.nvim_create_user_command('BazelTestSelect',
function()
    go_bazel.bazel_test_select()
end, {})

vim.api.nvim_create_user_command('BazelGazelle',
function()
    go_bazel.bazel_gazelle()
end, {})

local wk = require("which-key")

wk.register({
    ["<leader>"] = {
        b = {
            name = "Bazel",
            t = {"<cmd>:BazelTest<cr>", "Run tests of the same level of the opened file"},
            s = {"<cmd>:BazelTestSelect<cr>", "Run tests selecting the folder"},
            g = {"<cmd>:BazelGazelle<cr>", "Run gazelle"},
        },
    },
})
