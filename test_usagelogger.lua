luaunit = require('luaunit')


BaseLogger = require('usagelogger.base_logger')

TestBaseLogger = {}

    function TestBaseLogger:testHttpFalseStatus()
        kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/500"}

        b = BaseLogger:new(kwargs)
        status = b:submit("hello")
        luaunit.assertEquals(status, false)
    end
-- print("Response from server " .. table.concat(response_body))

    function TestBaseLogger:testHttpTrueStatus()
        kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/204"}

        b = BaseLogger:new(kwargs)
        status = b:submit("hello")
        luaunit.assertEquals(status, true)
    end

    luaunit.run()