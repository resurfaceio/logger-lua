-- © 2016-2021 Resurface Labs Inc.

local HttpRequestImpl = {method="GET", url=nil, headers=nil, params=nil, body=nil}

function HttpRequestImpl:new(o, method, url, headers, params, body)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.method = method or nil
    self.url = url or nil
    self.headers = headers or nil
    self.params = params or nil
    self.body = body or nil
    return o
end

return HttpRequestImpl
