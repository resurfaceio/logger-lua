local luaunit = require('luaunit')


BaseLogger = require('usagelogger.base_logger')
UsageLoggers = require('usagelogger.usage_loggers')


TestBaseLogger = {}

function TestBaseLogger:testHttpFailure()
    local b = BaseLogger:new{agent="usagelogger 0.1", url="https://httpbin.org/status/500"}

    b:submit("hello")
    luaunit.assertEquals(b.submit_failures, 1)
end

function TestBaseLogger:testHttpSuccess()
    local b = BaseLogger:new{agent="usagelogger 0.1", url="https://httpbin.org/status/204"}

    b:submit("hello")
    luaunit.assertEquals(b.submit_successes, 1)
end


TestUsageLogger = {}

function TestUsageLogger:testEnableDisable()
    UsageLoggers:disable()
    luaunit.assertEquals(UsageLoggers.__disabled, true)
    UsageLoggers:enable()
    luaunit.assertEquals(UsageLoggers.__disabled, false)
end


luaunit.run()