local M = {}

local utils = require('lbnvim.utils')

local function get_bazel_enabler()
    local current_folder = io.popen('pwd'):read('*l')
    local go_mod_folder = utils.get_first_folder_with_file(current_folder, 'go.mod')
    if go_mod_folder == nil then
        return nil
    end

    local go_packages_driver_path = go_mod_folder .. '/tools/gopackagesdriver.sh'
    local go_packages_driver_file = io.open(go_packages_driver_path, 'r')
    if go_packages_driver_file then
        return go_packages_driver_path
    end
end

function M.add_bazel_settings(settings)

    local go_packages_driver_path = get_bazel_enabler()
    if go_packages_driver_path then
        require('notify')("go Bazel found")
        -- name of the project based on the folder name
        -- todo: maybe use a bazel parser?
        local path_parts = utils.split_string(go_packages_driver_path, '/')
        local project_name = path_parts[#path_parts - 2]

        local gopls_settings = settings.gopls
        gopls_settings['env'] = {
            GOPACKAGESDRIVER = go_packages_driver_path
        }
        gopls_settings['directoryFilters'] = {
            "-bazel-bin",
            "-bazel-out",
            "-bazel-testlogs",
            "-bazel-"..project_name,
            "-**/sqitch",
        }
        return
    end
    require('notify')("go Bazel not found")
end

local function get_relative_path_to_go_mod()
    local openend_file = vim.api.nvim_buf_get_name(0)
    local go_mod_folder = utils.get_first_folder_with_file(openend_file, 'go.mod')
    if go_mod_folder == nil then
        return
    end

    return utils.get_relative_directory(openend_file, go_mod_folder)
end

function M.bazel_test()
    local relative_path = get_relative_path_to_go_mod()
    local test_command = 'bazel test //'..relative_path..'/...'
    require('notify')("Running "..test_command)
    vim.cmd.split()
    vim.api.nvim_command('term '..test_command)
end

function M.bazel_test_select()
    local relative_path = get_relative_path_to_go_mod()
    local new_relative_path = vim.fn.input('Test path: ', relative_path)
    -- secure the input by adding ... if not present
    if not (new_relative_path:sub(-3) == '...') then
        print(new_relative_path)
        new_relative_path = new_relative_path..'/...'
        print(new_relative_path)
    end
    print(new_relative_path)
    local test_command = 'bazel test //'..new_relative_path
    require('notify')("Running "..test_command)
    vim.cmd.split()
    vim.api.nvim_command('term '..test_command)
end

function M.bazel_gazelle()
    local test_command = 'bazel run //:gazelle'
    require('notify')("Running "..test_command)
    vim.cmd.split()
    vim.api.nvim_command('term '..test_command)
end

return M
