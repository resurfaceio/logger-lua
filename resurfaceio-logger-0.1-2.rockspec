package = "resurfaceio-logger"
version = "0.1-2"
source = {
   url = "git+https://github.com/resurfaceio/logger-lua"
}
description = {
   summary = "Log API requests and responses with Lua",
   detailed = "...",
   homepage = "https://github.com/resurfaceio/logger-lua",
   license = "Apache-2.0"
}
dependencies = {
   "lua ~> 5.3"
}
build = {
   type = "builtin",
   modules = {
      ["usagelogger.base_logger"] = "usagelogger/base_logger.lua",
      ["usagelogger.http_logger"] = "usagelogger/http_logger.lua",
      ["usagelogger.http_message"] = "usagelogger/http_message.lua",
      ["usagelogger.http_request_impl"] = "usagelogger/http_request_impl.lua",
      ["usagelogger.http_response_impl"] = "usagelogger/http_response_impl.lua",
      ["usagelogger.http_rule"] = "usagelogger/http_rule.lua",
      ["usagelogger.http_rules"] = "usagelogger/http_rules.lua",
      ["usagelogger.usage_loggers"] = "usagelogger/usage_loggers.lua"
   }
}
