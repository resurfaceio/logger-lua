-- © 2016-2022 Resurface Labs Inc.

local cjson = require 'cjson'

local BaseLogger = require('usagelogger.base_logger')
local HttpRules = require('usagelogger.http_rules')

local AGENT = "http_logger.lua"
-- Prototype metatable: instance of "parent class"
local HttpLogger = BaseLogger:new{agent = AGENT}

-- Constructor
function HttpLogger:new (o, enabled, queue, url, skip_compression, skip_submission, rules)
    -- non-nil default values
    enabled = enabled ~= nil and enabled or true
    skip_compression = skip_compression or false
    skip_submission = skip_submission or false

    o = o or {}
    o = BaseLogger.new(self, o, self.AGENT, enabled, queue, url, skip_compression, skip_submission)
    rules = rules or o.rules

    o.rules = HttpRules:new{rules=rules}
    return o
end

function HttpLogger:submitIfPassing (details, custom_fields)
    details = self.rules:apply(details)
    if details == nil then
        return
    end
    if custom_fields ~= nil then
        for k, v in pairs(custom_fields) do
            table.insert(details, {"custom_field:" .. k, v})
        end
    end

    table.insert(details, {"host", self.host})

    self:submit(cjson.encode(details))
end

return HttpLogger
