-- © 2016-2021 Resurface Labs Inc.

local function reqmod ()
    local m = require "usagelogger.http_logger_for_nginx_m"
end

local function settime ()
    ngx.ctx.starttime = ngx.now() * 1000
end

local function getdata ()
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

end

local function send ()
    local r = require "resurfaceio-logger"
    local m = require "usagelogger.http_logger_for_nginx_m"
    local now = ngx.now() * 1000

    r.HttpMessage.send{
        logger=m.logger,
        request=ngx.ctx.req,
        response=ngx.ctx.res,
        now=now,
        interval=(ngx.ctx.starttime and (now - ngx.ctx.starttime))
    }
    ngx.ctx.starttime = nil
end

return {init=reqmod, access=settime, bodyfilter=getdata, log=send}

