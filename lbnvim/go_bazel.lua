local M = {}

local function getFolderOfGoMod()
    local currentDir = io.popen('pwd'):read('*l') -- Get the current directory
    while true do
        local goModPath = currentDir .. '/go.mod'
        local goModFile = io.open(goModPath, 'r')

        if goModFile then
            goModFile:close()
            return currentDir
        else
            local _,_,parentDir = string.find(currentDir, '^/(.+)/')
            if parentDir then
                currentDir = '/'..parentDir -- Move to the parent directory
            else
                break                                              -- Reached the root directory
            end
        end
    end

    return nil -- go.mod file not found in any parent directory
end

local function getBazelEnabler()
    local goModFolder = getFolderOfGoMod()
    if goModFolder == nil then
        return nil
    end

    local goPackagesDriverPath = goModFolder .. '/tools/gopackagesdriver.sh'
    local goPackagesDriverFile = io.open(goPackagesDriverPath, 'r')
    if goPackagesDriverFile then
        return goPackagesDriverPath
    end
end

function M.add_bazel_settings(settings)

    local go_packages_driver_path = getBazelEnabler()
    if go_packages_driver_path then
        require('notify')("go Bazel found")
        local gopls_settings = settings.gopls
        gopls_settings['env'] = {
            GOPACKAGESDRIVER = go_packages_driver_path
        }
        gopls_settings['directoryFilters'] = {
            "-bazel-bin",
            "-bazel-out",
            "-bazel-testlogs",
            "-bazel-mypkg",
        }
        return
    end
    require('notify')("go Bazel not found")
end

return M
