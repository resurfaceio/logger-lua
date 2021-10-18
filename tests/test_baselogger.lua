local luaunit = require('luaunit')

local BaseLogger = require('usagelogger.base_logger')


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