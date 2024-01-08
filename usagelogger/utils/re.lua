-- © 2016-2024 Graylog, Inc.

local isngx, err1 = pcall(require, "ngx")
local isregex, err2 = pcall(require, "regex")
local re = isngx and require("ngx").re or isregex and require("regex") or error(
    "no regular expression module found. Either install 'lua-regex' or " ..
    "use this package in an environment with access to the NGINX Lua API (e.g. OpenResty)" ..
    "\n" .. err1 ..
    "\n" .. err2 ..
    "\n"
)

if isregex and re then
    re.sub = function (str, pattern, replacement, flags)
        local repl = pcall(replacement) and replacement() or replacement
        local rgx = re.new(pattern, flags)
        local h, t = rgx:indexesof(str)
        if h == nil then return str end
        assert(#h == #t)
        local s = ""
        for i in pairs(h) do
            local start = i == 1 and 1 or t[i - 1] + 1
            s = s .. string.sub(str, start, h[i] - 1) .. repl
        end
        return s
    end

    local match = re.match
    re.match = function (sbj, pattern, offset)
        local m, err = match(sbj, pattern, offset)
        if m == nil or err then
            return m, err
        end
        local x = {}
        for i,v in ipairs(m) do
            x[i-1] = v
        end
        return x
    end

    re.find = re.indexof
end

return re
