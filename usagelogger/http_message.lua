-- © 2016-2021 Resurface Labs Inc.

HttpRequestImpl = require('usagelogger.http_request_impl')
HttpRespomseImpl = require('usagelogger.http_response_impl')

--[[
    kwargs = {method="POST"}
    a = HttpRequestImpl:new(kwargs)
    print(a.method)
    print(a.url)
--]]
