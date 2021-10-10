
local HttpResponseImpl = {status=nil, headers=nil, body=nil}

    function HttpResponseImpl:new(o, status, headers, body)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        self.status = status or nil
        self.headers = headers or {}
        self.body = body or nil
        return o
    end

return HttpResponseImpl
