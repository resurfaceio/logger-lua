
http = require("socket.http")
ltn12 = require("ltn12")
-- Meta Class
local BaseLogger = {agent="", enabled=true, queue= nil, url=nil, skip_compression=false, skip_submission=nil,version=nil}
local VERSION = "0.1.0"

function BaseLogger:new(o, agent, enabled, queue, url, skip_compression, skip_submission, version)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.agent = agent
  self.enabled = enabled
  self.queue = queue
  self.url = url
  self.skip_compression = skip_compression
  self.skip_submission = skip_submission
  self.version = version
  return o
end

function BaseLogger:submit(msg)
    print("called submit with msg: ", msg)
    local response_body = { }
    local res, code, response_headers, status = http.request
    {
        url = self.url,
        method = "POST",
        headers =
        {
            ["Connection"] =  "keep-alive",
            ["User-Agent"]= "Resurface/ " .. VERSION .. " " .. "(" .. self.agent .. ")",
            ["Content-Type"] = "application/json; charset=UTF-8",
        },
        source = ltn12.source.string(msg),
        sink = ltn12.sink.table(response_body)
    }
    return code, response_body
end


-- 
kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/post"}
b = BaseLogger:new(kwargs)
code, response_body = b:submit("hello")
print("Response from server " .. table.concat(response_body))