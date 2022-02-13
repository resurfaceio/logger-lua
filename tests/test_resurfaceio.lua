-- © 2016-2021 Resurface Labs Inc.

local lu = require "luaunit"
local http = require "socket.http"

local r = require "resurfaceio-logger"

local BASE_URL = "http://localhost:4001"

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

TestResurfaceio = {}

function TestResurfaceio:setUp()
    local _, ok = http.request(BASE_URL)
    lu.skipIf(ok ~= 200, string.format("\tCouldn't connect to %s (Is your Resurface instance running?)", BASE_URL))
    self.logger = r.HttpLogger:new{url=BASE_URL .. "/message", rules="include debug"}
end

function TestResurfaceio:testSubmitMockAPICall()
    r.HttpMessage.send{logger=self.logger, request=req, response=res, request_body=reqBody, response_body=resBody, interval=interval}
    lu.assertEquals(self.logger.submit_successes, 1)
    lu.assertEquals(self.logger.submit_failures, 0)
end

function TestResurfaceio:testSubmitMockAPICallSkipCompression()
    r.HttpMessage.send{logger=self.logger, request=req, response=res, request_body=reqBody, response_body=resBody, interval=interval}
    lu.assertEquals(self.logger.submit_successes, 1)
    lu.assertEquals(self.logger.submit_failures, 0)
end



