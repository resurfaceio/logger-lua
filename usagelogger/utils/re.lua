-- © 2016-2021 Resurface Labs Inc.

local regex = require "regex"

regex.sub = function (pattern, repl, str, flags)
    local rgx = regex.new(pattern, flags)
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


return regex