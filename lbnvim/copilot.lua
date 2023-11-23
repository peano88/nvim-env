vim.notify = require('notify')

local function requirements()
    local required_exec = { 'npm', 'node' }

    for _,e in pairs(required_exec) do
        if vim.fn.executable(e) ~= 1 then
            vim.notify(e .. " not installed", "warn")
            return false
        end
    end
    return true
end

if requirements() then
    require('copilot').setup()
end
