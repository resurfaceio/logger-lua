package = "resurfaceio-logger"
version = "0.1-5"
source = {
   url = "git+https://github.com/resurfaceio/logger-lua"
}
description = {
   summary = "Log API requests and responses with Lua",
   detailed = [[
      The Resurface.io API Usage Logger module provides a way to log HTTP transactions. 
      It can log both detailed requests and responses, in order to submit them to a local 
      instance of Resurface, your very own API system of record.
      
      It features a programming interface to create Logger instances, and to send standard 
      or custom request/response tables to the HTTP endpoint where your own Resurface 
      database is running. Loggers always have an active set of rules that control what 
      data is logged and how sensitive data is masked. Logging rules are easily customized
      to meet the needs of any application. More info: https://resurface.io/rules.html

      Resurface can help with failure triage and root cause, threat and risk identification,
      and simply just knowing how your APIs are being used. It identifies what's important
      in your API data, and can send warnings and alerts in real-time for fast action.
   ]],
   homepage = "https://github.com/resurfaceio/logger-lua",
   license = "Apache-2.0"
}
dependencies = {
   "lua >= 5.3, < 5.4.2",
   "lua-cjson=2.1.0-1",
   "lua-zlib",
   "regex",
   "luasocket"
}
build = {
   type = "builtin",
   modules = {
      ["resurfaceio-logger"] = "resurfaceio-logger.lua",
      ["usagelogger.base_logger"] = "usagelogger/base_logger.lua",
      ["usagelogger.http_logger"] = "usagelogger/http_logger.lua",
      ["usagelogger.http_message"] = "usagelogger/http_message.lua",
      ["usagelogger.http_request_impl"] = "usagelogger/http_request_impl.lua",
      ["usagelogger.http_response_impl"] = "usagelogger/http_response_impl.lua",
      ["usagelogger.http_rule"] = "usagelogger/http_rule.lua",
      ["usagelogger.http_rules"] = "usagelogger/http_rules.lua",
      ["usagelogger.usage_loggers"] = "usagelogger/usage_loggers.lua",
      ["usagelogger.utils.re"] = "usagelogger/utils/re.lua",
      ["usagelogger.utils.str"] = "usagelogger/utils/str.lua",
      ["resurfaceio-test"] = "tests/test.lua",
      ["tests.test_baselogger"] = "tests/test_baselogger.lua",
      ["tests.test_httplogger"] = "tests/test_httplogger.lua",
      ["tests.test_usagelogger"] = "tests/test_usagelogger.lua",
      ["tests.test_helper"] = "tests/test_helper.lua",
   }
}
