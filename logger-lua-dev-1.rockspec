package = "logger-lua"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/resurfaceio/logger-lua.git"
}
description = {
   summary = "...",
   detailed = "...",
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua ~> 5.3",
   "lua-cjson=2.1.0-1",
   "lua-zlib",
   "regex",
   "luasocket"

}
build = {
   type = "builtin",
   modules = {
      ["logger-tests"] = "logger-tests.lua",
      ["resurfaceio-logger"] = "resurfaceio-logger.lua",
      ["tests.test_baselogger"] = "tests/test_baselogger.lua",
      ["tests.test_httplogger"] = "tests/test_httplogger.lua",
      ["tests.test_usagelogger"] = "tests/test_usagelogger.lua",
      ["usagelogger.base_logger"] = "usagelogger/base_logger.lua",
      ["usagelogger.http_logger"] = "usagelogger/http_logger.lua",
      ["usagelogger.http_message"] = "usagelogger/http_message.lua",
      ["usagelogger.http_request_impl"] = "usagelogger/http_request_impl.lua",
      ["usagelogger.http_response_impl"] = "usagelogger/http_response_impl.lua",
      ["usagelogger.http_rule"] = "usagelogger/http_rule.lua",
      ["usagelogger.http_rules"] = "usagelogger/http_rules.lua",
      ["usagelogger.usage_loggers"] = "usagelogger/usage_loggers.lua",
      ["usagelogger.utils.re"] = "usagelogger/utils/re.lua"
   },
   copy_directories = {
      "tests"
   }
}
