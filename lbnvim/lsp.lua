-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

local gopls_settings = {
    gopls = {
        hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            angeVariableTypes = true,
        },
        -- verboseOutput = true,
    },
}

local bazel_utils = require('bazel_nvim.utils')
if bazel_utils.is_bazel_project() then
    local go_bazel = require('lbnvim.go_bazel')
    go_bazel.add_bazel_settings(gopls_settings)
end

local servers_list = {
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    },
    nil_ls = {
        exec = 'nil'
    },
    marksman = {
        exec = 'marksman'
    },
    rust_analyzer = {
        exec = 'rust-analyzer'
    },
    gopls = {
        exec = 'gopls',
        settings = gopls_settings,
        --        cmd = { 'gopls', '-logfile=/tmp/gopls.log' },
    },
    golangci_lint_ls = {
        exec = 'golangci-lint-langserver',
    },
    clangd = {
        exec = 'clangd',
        settings = {
            cpp = {
                completions = {
                    completeFunctionCalls = true
                }
            }
        }
    },
    pylsp = {
        exec = 'pylsp'
    },
    bashls = {
        exec = 'bash-language-server'
    },
    yamlls = {
        exec = 'yaml-language-server'
    },
    jsonls = {
        exec = 'vscode-json-languageserver',
        cmd = { 'vscode-json-languageserver', '--stdio' }
    },
    sqls = {
        exec = 'sqls',
        settings = {
            sqls = {
                connections = {
                    {
                        driver = 'postgresql',
                        dataSourceName = 'postgresql://postgres:postgres@localhost:5432'
                    }
                }
            }
        }
    },
    hls = {
        exec = 'haskell-language-server-wrapper',
    },


}

local luasnip = require 'luasnip'
local cmp = require 'cmp'

local cmp_mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { 'i', 's' }),
})

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp_mapping,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--         ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--         ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--         ["<C-Space>"] = cmp.mapping.complete(),
--     })


local sign_icons = {
    Error = '󰅚 ',
    Warn = '󰀪 ',
    Hint = '󰌶 ',
    Info = '󰋽 '
}

for type, icon in pairs(sign_icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local on_attach_server = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() require('telescope.builtin').diagnostics() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() require('telescope.builtin').lsp_references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

local enabled_server_list = {}
for server, values in pairs(servers_list) do
    if (values.exec == nil or values.exec == '' or vim.fn.executable(values.exec) == 1) then
        local server_config = {
            settings = values.settings,
            capabilities = capabilities,
        }

        -- override cmd
        if (values.cmd ~= nil) then
            server_config.cmd = values.cmd
        end

        vim.lsp.config(server, server_config)
        table.insert(enabled_server_list, server)
    end
end

if next(enabled_server_list) ~= nil then
    vim.lsp.enable(enabled_server_list)
    local autocmd = vim.api.nvim_create_autocmd
    autocmd("LspAttach", {
		callback = on_attach_server
	})
end


vim.diagnostic.config({
    virtual_text = true
})
