-- © 2016-2021 Resurface Labs Inc.

local lu = require('luaunit')

local UsageLoggers = require('usagelogger.usage_loggers')


TestUsageLogger = {}

function TestUsageLogger:testEnableDisable()
    UsageLoggers:disable()
    lu.assertEquals(UsageLoggers.__disabled, true)
    UsageLoggers:enable()
    lu.assertEquals(UsageLoggers.__disabled, false)
end

