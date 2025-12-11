require('go').setup()

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimport()
    end,
    group = format_sync_grp,
})

-- create a new file using the package name as the package name of the file from the current buffer
-- (return an error if the current buffer is not a go file)
local function create_go_file()
    -- get the package name of the current buffer 
    local package_name = vim.fn.system("cat " .. vim.fn.expand("%") .. " | grep package | awk '{print $2}'")
    if package_name == "" then
        print("Error: the current buffer is not a go file")
        return
    end

    -- create a new file with only one line package <package_name>
    -- ask the user for the file name 
    local file_name = vim.fn.input("Enter the file name: ")
    if file_name == "" then
        print("Error: the file name cannot be empty")
        return
    end

    -- create the file
    local file_path = vim.fn.expand("%:p:h") .. "/" .. file_name
    local file = io.open(file_path, "w")
    if not file then
        print("Error: could not write to file " .. file_path)
        return
    end

    file:write("package " .. package_name)
    file:close()
end

-- create a command to create a new go file 
-- the command is :GoNewFile 
vim.api.nvim_create_user_command("GoNewFile", create_go_file, {
    nargs = 0,
})

vim.keymap.set("n", "<leader>gf", vim.cmd.GoTestFunc)
vim.keymap.set("n", "<leader>gl", vim.cmd.GoLint)
vim.keymap.set("n", "<leader>gi", vim.cmd.GoImplements)
vim.keymap.set("n", "<leader>ga", vim.cmd.GoAlt)
vim.keymap.set("n", "<leader>gn", vim.cmd.GoNewFile)


