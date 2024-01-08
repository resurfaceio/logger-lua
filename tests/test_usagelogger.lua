-- © 2016-2024 Graylog, Inc.

local lu = require('luaunit')

local UsageLoggers = require('usagelogger.usage_loggers')


TestUsageLogger = {}

function TestUsageLogger:testEnableDisable()
    UsageLoggers:disable()
    lu.assertEquals(UsageLoggers.__disabled, true)
    UsageLoggers:enable()
    lu.assertEquals(UsageLoggers.__disabled, false)
end

