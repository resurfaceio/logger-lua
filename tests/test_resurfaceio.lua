-- © 2016-2021 Resurface Labs Inc.

local lu = require "luaunit"
local http = require "resty.http"

local r = require "resurfaceio-logger"

local BASE_URL = "http://" .. os.getenv("TEST_RESURFACE_HOST") or "localhost" .. ":7701"
local PARSED_BASE_URL = http:parse_uri(BASE_URL)

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
    lu.skipIf(
        not pcall(http.new),
        "\tCouldn't create a new http client. Are you running this test in an env with access to the NGINX Lua API (e.g. OpenResty)?"
    )
    local httpc = http.new()
    local ok = httpc:connect({scheme=PARSED_BASE_URL[1], host=PARSED_BASE_URL[2], port=PARSED_BASE_URL[3]})
    httpc:close()
    lu.skipIf(not ok, string.format("\tCouldn't connect to %s (Is your Resurface instance running?)", BASE_URL))
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



