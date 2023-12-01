local lualine = require('lualine')

local function lsp_name()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

local config = {
    options = {
        -- set theme via env variable
        theme = os.getenv("LUALINE_THEME") or "everforest",
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 4,
            },
            {
                lsp_name,
                icon = ' LSP:',
            },
        }
    }
}

-- Now don't forget to initialize lualine
lualine.setup(config)
