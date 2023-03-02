-- © 2016-2023 Resurface Labs Inc.

local http = require "resty.http"
local zlib = require "usagelogger.utils.zlib"

local UsageLoggers = require "usagelogger.usage_loggers"

-- Prototype metatable
local BaseLogger = {}

-- Constructor
function BaseLogger:new (o, agent, enabled, queue, url, skip_compression, skip_submission)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.agent = assert(agent or o.agent, "agent is required")
    o.host = self.host_lookup()
    o.skip_compression = skip_compression or o.skip_compression or false
    o.skip_submission = skip_submission or o.skip_submission or false
    o.version = self.version_lookup()

    o.url = url or o.url or UsageLoggers:url_by_default()
    o.enabled = enabled or o.enabled or true
    o.queue = queue or o.queue
    if o.queue ~= nil then
        o.url = nil
    elseif o.url ~= nil and type(o.url) == "string" then
        local parsed_url = http:parse_uri(o.url)
        if parsed_url ~= nil then
            assert(parsed_url[1] == "http" or parsed_url[1] == "https", "incorrect URL scheme")
        else
            self.enabled = false
            self.url = nil
        end
    else
        o.enabled = false
        o.url = nil
    end

    o.enableable = o.queue ~= nil or o.url ~= nil
    o.submit_failures = 0
    o.submit_successes = 0

    return o
end

-- Submits JSON message to intended destination.
function BaseLogger:submit (msg)
    if msg == nil or self.skip_submission == true or self.enabled == false then

    elseif self.queue ~= nil then
        table.insert(self.queue, msg)
        self.submit_successes = self.submit_successes + 1
    else
        local headers = {
            ["Connection"] =  "keep-alive",
            ["User-Agent"] = string.format("Resurface/%s (%s)", self.version, self.agent),
            ["Content-Type"] = "application/json; charset=UTF-8",
        }

        local body
        if not self.skip_compression then
            body = msg
        else
            headers["Content-Encoding"] = "deflated"
            body = zlib.deflate(msg)
        end
        headers["Content-Length"] = #body

        local res, _ = http.new():request_uri(self.url, {
            method = "POST",
            headers = headers,
            body = body,
        })
        if res and res.status == 204 then
            self.submit_successes = self.submit_successes + 1
        else
            self.submit_failures = self.submit_failures + 1
        end

    end
end

function BaseLogger:disable ()
    self.enabled = false
    return self
end

function BaseLogger:enable ()
    if self.enableable then
        self.enabled = true
    end
    return self
end

--[[
    function BaseLogger:enabled ()
        return self.enabled and UsageLoggers:is_enabled()
    end
--]]

function BaseLogger.host_lookup ()
    local dyno = os.getenv("DYNO")
    if dyno ~= nil then
        return dyno
    end
    local hostname_file = io.open("/etc/hostname", "r")
    local hostname = nil
    if hostname_file then
        hostname = hostname_file:read("*line")
        hostname_file:close()
    end
    return hostname or "unknown"
end

function BaseLogger.version_lookup ()
    return os.getenv("VERSION") or UsageLoggers._VERSION
end

return BaseLogger
-- TODO private fields, concurrency locks
