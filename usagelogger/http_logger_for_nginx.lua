-- © 2016-2023 Resurface Labs Inc.

local str = require "usagelogger.utils.str"

local function reqmod (config)
    local r = require "resurfaceio-logger"
    r.config = config
    local m = require "usagelogger.http_logger_for_nginx_m"
end

-- unescape function from Programming in Lua: https://www.lua.org/pil/20.3.html
function unescape (s)
  s = str.gsub(s, "+", " ")
  s = str.gsub(s, "%%(%x%x)", function (h)
        return str.char(tonumber(h, 16))
      end)
  return s
end

local function get_params (querystr)
    local params = {}
    for key, val in str.gmatch(querystr, "([^&=]+)=([^&=]+)") do
      key = unescape(key)
      val = unescape(val)
      if params[key] then
        params[key] = params[key] .. "," .. val
      end
      params[key] = val
    end
    return params
end

local function settime ()
    ngx.ctx.starttime = ngx.now() * 1000
end

local function getdata ()
    local r = require "resurfaceio-logger"
    local req = r.HttpRequestImpl:new{}
    local res = r.HttpResponseImpl:new{}

    req.method = ngx.req.get_method()
    local path, qs = unpack(str.split(ngx.var.request_uri, "([^?]+)"))
    req.url = ngx.var.scheme .. "://" .. ngx.var.http_host .. path
    qs = ngx.var.query_string or qs
    if qs ~= nil then
      req.params = {}
      for param, value in pairs(get_params(qs)) do
        req.params[param] = value
      end
    end
    req.headers = ngx.req.get_headers()
    req.body = ngx.req.get_body_data() or ""

    res.status = ngx.status
    res.headers = ngx.resp.get_headers()
    res.body = ngx.arg[1] or ""

    ngx.ctx.req = req
    ngx.ctx.res = res

end

local function sendfromtimer (_, req, res, starttime, endtime)
    local r = require "resurfaceio-logger"
    local m = require "usagelogger.http_logger_for_nginx_m"
    local now = endtime * 1000

    r.HttpMessage.send{
        logger=m.logger,
        request=req,
        response=res,
        now=now,
        interval=(starttime and (now - starttime))
    }
end

local function send ()
  ngx.timer.at(0, sendfromtimer, ngx.ctx.req, ngx.ctx.res, ngx.ctx.starttime, ngx.now())
  ngx.ctx.starttime = nil
end


return {init=reqmod, access=settime, bodyfilter=getdata, log=send}
