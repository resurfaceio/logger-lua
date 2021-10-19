-- © 2016-2021 Resurface Labs Inc.

local lu = require('luaunit')
local cjson = require('cjson')

local HttpLogger = require('usagelogger.http_logger')


TestHttpLogger = {}

function TestHttpLogger:testSubmitIfPassing()
    local queue = {}
    local logger = HttpLogger:new{queue=queue, rules="include debug"}
    local t = {{"foo"}, {"bar", "baz"}}
    logger:submitIfPassing(t)
    lu.assertEquals(#queue, 1)
    local decoded = cjson.decode(queue[1])
    lu.assertEquals(decoded, t)
end
