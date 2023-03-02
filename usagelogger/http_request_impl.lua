-- © 2016-2023 Resurface Labs Inc.

local HttpRequestImpl = {method="GET"}

function HttpRequestImpl:new(o, method, url, headers, params, body)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.method = method or o.method
    o.url = url or o.url
    o.headers = headers or o.headers
    o.params = params or o.params
    o.body = body or o.body
    return o
end

return HttpRequestImpl
