package = "logger-lua"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   summary = "...",
   detailed = "...",
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
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
