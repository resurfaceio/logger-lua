local r = require "resurfaceio-logger"

local logger = r.HttpLogger:new{url="http://localhost:4001/message", rules="include debug"}
local logger2 = r.HttpLogger:new{url="http://localhost:4001/message", rules="include debug", skip_compression=true}

local req = r.HttpRequestImpl:new{method="GET", url="http://www.example.com/", headers={foo="bar",ok=false,n=25}}
local res = r.HttpResponseImpl:new{status=200, headers={hello="world"}}
local reqBody = "This is the request body"
local resBody = [[{
    "movie": {
        "name": "2001: A Space Odyssey",
        "director": "Stanley Kubrick",
        "year": 1968
    },
    "car": {
        "brand": "Porsche",
        "model": "911 Carrera",
        "year": 1973
    },
    "ok": true,
    "n": 87
}]]

local interval = 5342

r.HttpMessage.send{logger=logger, request=req, response=res, request_body=reqBody, response_body=resBody, interval=interval}
r.HttpMessage.send{logger=logger2, request=req, response=res, request_body=reqBody, response_body=resBody, interval=interval}
print(string.format("Logger:\nSuccesses: %d, Failures: %d\n", logger.submit_successes, logger.submit_failures))
print(string.format("Logger with compression:\nSuccesses: %d, Failures: %d", logger2.submit_successes, logger2.submit_failures))