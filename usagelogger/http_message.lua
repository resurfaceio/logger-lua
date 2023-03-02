-- © 2016-2023 Resurface Labs Inc.

local HttpRequestImpl = require('usagelogger.http_request_impl')
local HttpResponseImpl = require('usagelogger.http_response_impl')

local HttpMessage = {}

function HttpMessage.send (o, logger, request, response, response_body, request_body, now, interval, custom_fields)
    o = o or {}
    logger = assert(logger or o.logger, "logger required")
    request = assert(request or o.request, "request required")
    response = assert(response or o.response, "response required")
    response_body = response_body or o.response_body
    request_body = request_body or o.request_body
    now = now or o.now
    interval = interval or o.interval
    custom_fields = custom_fields or o.custom_fields

    if not logger.enabled then
        return
    end

    local message = HttpMessage.build(nil, request, response, response_body, request_body)

    -- copy details from session

    --add timing details
    table.insert(message, {"now", (now or os.time() * 1000) .. "" })

    if interval ~= nil then
        table.insert(message, {"interval", interval})
    end

    logger:submitIfPassing(message, custom_fields)

end

function HttpMessage.build (o, request, response, response_body, request_body)
    o = o or {}
    request = assert(request or o.request, "request_required")
    response = assert(response or o.response, "response_required")
    response_body = response_body or o.response_body
    request_body = request_body or o.request_body

    local message = {}

    if request.method then
        table.insert(message, {"request_method", request.method})
    end

    if request.url then
        table.insert(message, {"request_url", request.url})
    end

    if response.status then
        table.insert(message, {"response_code", response.status .. ""})
    end

    if request.headers then
        for k, v in pairs(request.headers) do
            table.insert(message, {string.lower("request_header:" .. k), v})
        end
    end

    if request.params then
        for k, v in pairs(request.params) do
            table.insert(message, {string.lower("request_param:" .. k), v})
        end
    end

    if response.headers then
        for k, v in pairs(response.headers) do
            table.insert(message, {string.lower("response_header:" .. k), v})
        end
    end

    request_body = request_body or request.body
    if request_body and request_body ~= "" then
        table.insert(message, {"request_body", request_body})
    end

    response_body = response_body or response.body
    if response_body and response_body ~= "" then
        table.insert(message, {"response_body", response_body})
    end

    return message
end

return HttpMessage
