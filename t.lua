local r = require "resurfaceio-logger"

-- local logger = r.HttpLogger:new{url="http://localhost:4001/message", rules="include debug", skip_compression=true}
local logger = r.HttpLogger:new{url="http://localhost:4001/message", rules="include debug"}
-- local req = r.HttpRequestImpl:new{method="GET", url="TEST", headers={foo="bar"}}
local req = r.HttpRequestImpl:new{method="GET", url="TEST"}
-- local res = r.HttpResponseImpl:new{status=200, headers={hello="world"}}
local res = r.HttpResponseImpl:new{status=200}

r.HttpMessage.send{logger=logger, request=req, response=res}
print(string.format("Successes: %d, Failures: %d", logger.submit_successes, logger.submit_failures))