local luaunit = require('luaunit')
local cjson = require('cjson')


local HttpLogger = require('usagelogger.http_logger')

TestHttpLogger = {}

    function TestHttpLogger:testSubmitIfPassing()
        local queue = {}
        local logger = HttpLogger:new{queue=queue}
        
        local msg = "world"
        logger:submitIfPassing(msg)
        luaunit.assertEquals(#queue, 1)
        local decoded = cjson.decode(queue[1])
        luaunit.assertEquals(decoded[2][1], msg)
    end

    