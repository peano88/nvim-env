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

    -- check if deactivated by env variable
    if os.getenv("GO_BAZEL_DISABLE") == "1" then
        require('notify')("go Bazel disabled by env variable")
        return
    end

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
        }
        return
    end
    require('notify')("go Bazel not found")
end

return M
