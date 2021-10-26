local r = require "resurfaceio-logger"

local config = {
    url="http://127.0.0.1:4001/message",
    rules="include debug"
}

local _M = {
    logger = r.HttpLogger:new(config)
}

return _M

