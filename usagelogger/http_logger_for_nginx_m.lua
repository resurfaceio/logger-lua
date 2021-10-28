local r = require "resurfaceio-logger"

local CONFIG = {
    url=os.getenv("USAGE_LOGGERS_URL") or "http://127.0.0.1:4001/message",
    rules=os.getenv("USAGE_LOGGERS_RULES") or"include debug"
}

local _M = {
    logger = r.HttpLogger:new(CONFIG)
}

return _M

