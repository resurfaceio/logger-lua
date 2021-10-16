local luaunit = require('luaunit')


BaseLogger = require('usagelogger.base_logger')
UsageLoggers = require('usagelogger.usage_loggers')


TestBaseLogger = {}

    function TestBaseLogger:testHttpFalseStatus()
        local kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/500"}

        local b = BaseLogger:new(kwargs)
        local status = b:submit("hello")
        luaunit.assertEquals(status, false)
    end
-- print("Response from server " .. table.concat(response_body))

    function TestBaseLogger:testHttpTrueStatus()
        local kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/204"}

        local b = BaseLogger:new(kwargs)
        local status = b:submit("hello")
        luaunit.assertEquals(status, true)
    end


    TestUsageLogger = {}
        function TestUsageLogger:testEnableDisable()
            UsageLoggers:disable()
            luaunit.assertEquals(UsageLoggers.__disabled, true)
            UsageLoggers:enable()
            luaunit.assertEquals(UsageLoggers.__disabled, false)
        end



    luaunit.run()