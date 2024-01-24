vim.notify = require('notify')

local function requirements()
    local required_exec = { 'npm', 'node' }

    for _, e in pairs(required_exec) do
        if vim.fn.executable(e) ~= 1 then
            vim.notify(e .. " not installed", "warn")
            return false
        end
    end
    return true
end

if requirements() then
    require('copilot').setup(
        {
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
                    position = "bottom", -- | top | left | right
                    ratio = 0.3
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<M-l>",
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
            copilot_node_command = 'node', -- Node.js version must be > 18.x
            server_opts_overrides = {},
        })

    vim.keymap.set('n', '<leader>cc', function()
        if vim.fn.winnr('$') == 1 then
            vim.cmd.vsplit()
        end
        vim.cmd.wincmd('l')
        if vim.api.nvim_get_mode().mode == 'v' then
            local bufnr = vim.api.nvim_get_current_buf()
            local start_pos = vim.api.nvim_buf_get_mark(bufnr, "<")
            local end_pos = vim.api.nvim_buf_get_mark(bufnr, ">")
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, end_pos[1], false)
            local selected_text = table.concat(lines, "\n")
            vim.cmd.CopilotChat(selected_text)
        else
            local user_input = vim.fn.input("Copilot prompt > ")
            vim.cmd.CopilotChat(user_input)
        end
    end)

    vim.keymap.set('v', '<leader>cc', function()
        print("visual mode")
    end)
end
