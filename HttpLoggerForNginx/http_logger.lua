local r = require "resurfaceio-logger"
local m = require(r.PluginPath)

r.HttpMessage.send{
    logger=m.logger,
    request=ngx.ctx.req,
    response=ngx.ctx.res,
}