local luaunit = require('luaunit')

local UsageLoggers = require('usagelogger.usage_loggers')




TestUsageLogger = {}

function TestUsageLogger:testEnableDisable()
    UsageLoggers:disable()
    luaunit.assertEquals(UsageLoggers.__disabled, true)
    UsageLoggers:enable()
    luaunit.assertEquals(UsageLoggers.__disabled, false)
end

