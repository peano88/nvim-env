vim.notify = require("notify")

local function show_timer(opts)
    local timer = vim.loop.new_timer()

    local driver_time_left = 0
    if opts.driver_time_minutes ~= nil then
        driver_time_left = opts.driver_time_minutes * 60;
    end
    if opts.driver_time_seconds ~= nil then
        driver_time_left = driver_time_left + opts.driver_time_seconds;
    end

    if driver_time_left == 0 then
        return
    end

    local notifier = vim.notify("... Ready ...", "info", {
        title = "Mob programming timer"
    })

    timer:start(1000, 1000, vim.schedule_wrap(function()
        driver_time_left = driver_time_left - 1
        local minutes = math.floor(driver_time_left / 60)
        local seconds = driver_time_left % 60

        notifier = vim.notify("Next driver change in " .. string.format("%02d:%02d", minutes, seconds) .. "", "info", {
            title = "Mob programming timer",
            replace = notifier
        })

        if driver_time_left == 0 then
            timer:close()
            notifier = vim.notify("Change the driver", "warn", {
                title = "Mob programming timer",
                replace = notifier
            })
        end
    end)
    )
end

local function validate_minutes(minutes)
    if minutes < 0 or minutes > 99 then
        return "minutes needs to be 0 <= x < 99"
    end
end

local function validate_seconds(seconds)
    if seconds < 0 or seconds > 59 then
        return "seconds needs to be 0 <= x <= 60"
    end
end

local function prompt(minutes, seconds)
        local error_msg = validate_minutes(minutes)
        if error_msg ~= nil then
            vim.notify(error_msg, 'err')
            return
        end

        error_msg = validate_seconds(minutes)
        if error_msg ~= nil then
            vim.notify(error_msg, 'err')
            return
        end

        show_timer({
            driver_time_minutes = minutes,
            driver_time_seconds = seconds,
        })
end

vim.api.nvim_create_user_command('MOBTimer',
    function(opts)
        local pattern = "^(%d+)%s*(%d+)%s*$"

        -- lua does not allow use of | in regexp
        local input = opts.fargs[1]
        input = input:gsub("seconds", "")
        input = input:gsub("sec", "")
        input = input:gsub("s", "")
        input = input:gsub("minutes", "")
        input = input:gsub("min", "")
        input = input:gsub("m", "")

        local minutes, seconds = input:match(pattern)

        if minutes == nil then
            vim.notify("Error with timer parameters " .. opts.fargs[1], "error")
            return
        end

        prompt(minutes, seconds)

    end,
    {
        nargs = 1,
    }
)

vim.api.nvim_create_user_command('MOBTimerInteractive',
    function()
        local minutes = tonumber(vim.fn.input('Enter number of minutes (0-99):'))
        if minutes == nil then
            vim.notify("minutes should be an integer value", "error")
            return
        end
        local seconds = tonumber(vim.fn.input('Enter number of seconds (0-59):'))
        if seconds == nil then
            vim.notify("seconds should be an integer value", "error")
            return
        end

        prompt(minutes, seconds)
    end,
    {}
)
