local vim = vim
local notify = require('notify')

local function is_executable(executable)
    return vim.fn.executable(executable) == 1
end

local function check_requirements(required_exec)
    for _, exec in pairs(required_exec) do
        if not is_executable(exec) then
            notify(exec .. " not installed", "warn")
            return false
        end
    end
    return true
end

local function setup_copilot()
    require('copilot').setup({
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>"
            },
            layout = {
                position = "bottom",
                ratio = 0.3
            },
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
                accept = "<C-l>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
        },
        filetypes = {
            yaml = true,
            markdown = true,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
        },
        copilot_node_command = 'node',
        server_opts_overrides = {},
    })

    require('CopilotChat').setup()

    vim.keymap.set('n', '<leader>cc', function()
            vim.cmd("CopilotChatOpen")
    end)
    vim.keymap.set('n', '<leader>ct', function()
            vim.cmd("CopilotChatTest")
    end)
end

if check_requirements({ 'npm', 'node' }) then
    setup_copilot()
end
