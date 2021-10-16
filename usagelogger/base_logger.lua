-- © 2016-2021 Resurface Labs Inc.

local ltn12 = require "ltn12"
local http = require "socket.http"
local url_parser = require ("socket.url").parse
local dns = require("socket").dns
local zlib = require "zlib"

-- VERSION
local VERSION = "0.1.0"

-- Prototype metatable
local BaseLogger = {}

-- Constructor
function BaseLogger:new(o, agent, enabled, queue, url, skip_compression, skip_submission)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.agent = agent or o.agent
    o.host = self:host_lookup()
    o.skip_compression = skip_compression or o.skip_compression or false
    o.skip_submission = skip_submission or o.skip_submission or false
    o.version = self:version_lookup()

    o.url = url or o.url or UsageLoggers:url_by_default()
    o.enabled = enabled or o.enabled
    o.queue = queue or o.queue
    if o.queue ~= nil then
        o.url = nil
    elseif o.url ~= nil and type(o.url) == "string" then
        local parsed_url = url_parser(o.url)
        assert(parsed_url ~= nil, "invalid URL")
        assert(parsed_url.scheme == "http" or parsed_url.scheme == "https", "incorrect URL scheme")
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
function BaseLogger:submit(msg)
    if msg == nil or self.skip_submission == true or self.enabled == false then

    elseif self.queue ~= nil then
        table.insert(self.queue, msg)
    else
        local headers = {
            ["Connection"] =  "keep-alive",
            ["User-Agent"] = string.format("Resurface/%s (%s)", self.version, self.agent),
            ["Content-Type"] = "application/json; charset=UTF-8",
            ["Content-Length"] = string.len(msg)
        }

        local body
        if not self.skip_compression then
            body = msg
        else
            headers["Content-Encoding"] = "deflate"
            body = zlib.deflate()(msg, "finish")
        end

        local response_body = {}
        local _, code = http.request
            {
                url = self.url,
                method = "POST",
                headers = headers,
                source = ltn12.source.string(body),
                sink = ltn12.sink.table(response_body)
            }
        if code == 204 then
            return true, response_body
        else
            return false, response_body
        end

    end
end

function BaseLogger:disable()
    self.enabled = false
    return self
end

function BaseLogger:enable()
    if self.enableable then
        self.enabled = true
    end
    return self
end

function BaseLogger:enabled()
    return self.enabled and UsageLoggers:is_enabled()
end

function BaseLogger:host_lookup()
    local dyno = os.getenv("DYNO")
    if dyno ~= nil then
        return dyno
    end
    return dns.gethostname() or "unknown"
end

function BaseLogger:version_lookup()
    return os.getenv("VERSION") or VERSION
end

return BaseLogger
-- TODO private fields, concurrency locks
