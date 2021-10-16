-- © 2016-2021 Resurface Labs Inc.

local lunajson = require 'lunajson'

BaseLogger = require('usagelogger.base_logger')
HttpRules = require('usagelogger.http_rules')

local HttpLogger = BaseLogger:new()
    local httplogger = HttpLogger:new{}
    local rules = HttpRules:new{}

    function HttpLogger:applyRules()
    end

    function HttpLogger:submitIfPassing(details)
        details = rules.apply(details)
        if details == nil then
            return
        end

        -- Append

        httplogger.submit(lunajson.decode.encode(details))
    end

return HttpLogger