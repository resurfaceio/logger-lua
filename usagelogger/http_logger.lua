-- © 2016-2021 Resurface Labs Inc.

local cjson = require 'cjson'

local BaseLogger = require('usagelogger.base_logger')
local HttpRules = require('usagelogger.http_rules')


local HttpLogger = BaseLogger:new()
HttpLogger.AGENT = "http_logger.lua"

function HttpLogger:new (o, enabled, queue, url, skip_compression, skip_submission, rules)
    -- non-nil default values
    enabled = enabled ~= nil and enabled or true
    skip_compression = skip_compression or false
    skip_submission = skip_submission or false

    o = o or {}
    o = BaseLogger.new(self, o, self.AGENT, enabled, queue, url, skip_compression, skip_submission)

    o.rules = HttpRules:new{rules=rules}
    return o
end

function HttpLogger:submitIfPassing (details)
    details = self.rules:apply(details)
    if details == nil then
        return
    end

    table.insert(details, {"host", self.host})

    self:submit(cjson.encode(details))
    -- print(cjson.encode(details))
end

return HttpLogger
