local r = require "resurfaceio-logger"

local DEFAULT_CONFIG = {
    url="http://127.0.0.1:4001/message",
    rules="include debug"
}

local _M = {
    logger = r.HttpLogger:new(r.config or DEFAULT_CONFIG)
}

return _M

