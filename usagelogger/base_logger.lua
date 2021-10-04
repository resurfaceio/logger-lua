
http = require("socket.http")
ltn12 = require("ltn12")
-- Meta Class
local BaseLogger = {agent, enabled, queue, url, skip_compression, skip_submission,version}
local VERSION = "0.1.0"

function BaseLogger:new(o, agent, enabled, queue, url, skip_compression, skip_submission, version)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.agent = agent
  self.enabled = enabled or os.getenv("USAGE_LOGGERS_DISABLE") ~= true
  self.queue = queue
  self.url = url or os.getenv("USAGELOGGER_URL")
  self.skip_compression = skip_compression or false
  self.skip_submission = skip_submission or false
  self.version = version or os.getenv("VERSION") or VERSION
  return o
end

function BaseLogger:submit(msg)
    if msg == nil or self.skip_submission == true or self.enabled == false then
        
    elseif self.queue ~= nil then
        self.queue:push(msg)
    else
        local response_body = { }
        local res, code, response_headers, status = http.request
            {
                url = self.url,
                method = "POST",
                headers =
                {
                    ["Connection"] =  "keep-alive",
                    ["User-Agent"]= "Resurface/ " .. self.version .. " " .. "(" .. self.agent .. ")",
                    ["Content-Type"] = "application/json; charset=UTF-8",
                },
                source = ltn12.source.string(msg),
                sink = ltn12.sink.table(response_body)
            }
        if code == 204 then
            return true
        else
            return false
        end

    end
end


-- 
kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/204"}
b = BaseLogger:new(kwargs)
status = b:submit("hello")
print(status)
-- print("Response from server " .. table.concat(response_body))