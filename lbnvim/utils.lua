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

return M
