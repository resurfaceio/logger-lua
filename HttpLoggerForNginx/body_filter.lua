local r = require "resurfaceio-logger"

local req = r.HttpRequestImpl:new{}
local res = r.HttpResponseImpl:new{}

req.method = ngx.req.get_method()
req.url = ngx.var.scheme .. "://" .. ngx.var.http_host .. ngx.var.request_uri
local qs = ngx.var.query_string
if qs ~= nil then
  req.url = req.url .. "?" .. qs
end
req.headers = ngx.req.get_headers()
req.body = ngx.req.get_body_data() or ""

res.status = ngx.status
res.headers = ngx.resp.get_headers()
res.body = ngx.arg[1] or ""

ngx.ctx.req = req
ngx.ctx.res = res