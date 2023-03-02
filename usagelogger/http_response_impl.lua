-- © 2016-2023 Resurface Labs Inc.

local HttpResponseImpl = {status=200}

function HttpResponseImpl:new(o, status, headers, body)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.status = status or o.status
    o.headers = headers or o.headers
    o.body = body or o.body
    return o
end

return HttpResponseImpl
