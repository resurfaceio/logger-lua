-- © 2016-2022 Resurface Labs Inc.

local r = require "resurfaceio-logger"

local DEFAULT_CONFIG = {
    url="http://127.0.0.1:7701/message",
    rules="include debug"
}

local _M = {
    logger = r.HttpLogger:new(r.config or DEFAULT_CONFIG)
}

return _M

