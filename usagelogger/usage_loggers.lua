-- © 2016-2022 Resurface Labs Inc.

UsageLoggers = {}

-- VERSION
UsageLoggers._VERSION = "2.0-0"

UsageLoggers.__BRICKED = os.getenv("USAGE_LOGGERS_DISABLE") == 'true'
UsageLoggers.__disabled = UsageLoggers.__BRICKED

function UsageLoggers:disable ()
    self.__disabled = true
end

function UsageLoggers:enable ()
    if self.__BRICKED == false then
        self.__disabled = false
    end
end

function UsageLoggers:is_enabled ()
    return not self.__disabled
end

function UsageLoggers:url_by_default ()
    return os.getenv("USAGE_LOGGERS_URL")
end


return UsageLoggers