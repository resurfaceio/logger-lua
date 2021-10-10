
lunajson = require 'lunajson'

BaseLogger = require('usagelogger.base_logger')
HttpRules = require('usagelogger.http_rules')

local HttpLogger = BaseLogger:new()
    httplogger = HttpLogger:new{}
    rules = HttpRules:new{}

    function HttpLogger:applyRules()
    end

    function HttpLogger:submitIfPassing(details)
        details = rules.apply(details)
        if details is nil then
            return
        end

        -- Append

        httplogger.submit(lunajson.decode.encode(details))
    end

return HttpLogger