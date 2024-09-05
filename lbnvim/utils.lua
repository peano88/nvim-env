local M = {}

function M.get_first_folder_with_file(start, file)
    local current_folder = start -- Get the current directory
    while true do
        local file_path = current_folder .. '/' .. file
        local file_obj = io.open(file_path, 'r')

        if file_obj then
            file_obj:close()
            return current_folder
        else
            local _, _, parent_folder = string.find(current_folder, '^/(.+)/')
            if parent_folder then
                current_folder = '/' .. parent_folder -- Move to the parent directory
            else
                break                                 -- Reached the root directory
            end
        end
    end

    return nil -- file not found in any parent directory
end

-- return the lines starting with the line atching `match_start` and
-- ending either with a `match_end_condition` (not included) function either with last line
function M.get_lines_after_match(lines, match_start, match_end_condition)
    local lines_after_match = nil
    for _, l in pairs(lines) do
        if string.match(l, match_start) then
            lines_after_match = {}
        end

        if match_end_condition(l) then
            return lines_after_match
        end

        if lines_after_match then
            table.insert(lines_after_match, l)
        end
    end

    return lines_after_match
end

function M.split_string(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for field, s in string.gmatch(inputstr, "([^" .. sep .. "]*)(" .. sep .. "?)") do
        table.insert(t, field)
        if s == "" then
            return t
        end
    end
end

function M.join_strings(tokens, sep)
    if #tokens == 0 then
        return ''
    end

    local joined = ''
    local tmp_sep = ''
    for _, t in pairs(tokens) do
        joined = joined .. tmp_sep .. t
        tmp_sep = sep
    end
    return joined
end

function M.get_relative_directory(path, relative_to)
    local _, _, relative_path = string.find(path, relative_to .. '/(.+)')
    local directory = string.match(relative_path, '(.*)/')
    return directory
end

function M.issue_silent_command(command)
    -- should run the command silently an return the output

    local handle = io.popen(command)
    if not handle then
        return nil
    end
    local result = handle:read('*a')
    handle:close()
    return result
end

function M.insert_if_not_exists(tbl,...)
    local values = {...}
    local function insert_if_not_exists_single(value)
        for _, v in pairs(tbl) do
            if v == value then
                return
            end
        end
        table.insert(tbl, value)
    end
    for _, v in pairs(values) do
        insert_if_not_exists_single(v)
    end
end

function Test_get_relative_directory()
    local path = '/home/user/project/src/main.go'
    local relative_to = '/home/user/project'
    local expected = 'src'
    local result = M.get_relative_directory(path, relative_to)
    assert(result == expected, 'get_relative_directory failed')
end

function Test_issue_silent_command()
    local command = 'echo "hello"'
    local expected = 'hello\n'
    local result = M.issue_silent_command(command)
    assert(result == expected, 'issue_silent_command failed')
    local output = M.issue_silent_command('ls')
    assert(output ~= nil, 'issue_silent_command failed')
    local table_output = M.split_string(output, '\n')
    print(table_output[1])
end

function M.select_buffer_by_name(name)
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_get_name(buf) == name then
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end
end

return M
