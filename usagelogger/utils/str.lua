-- © 2016-2022 Resurface Labs Inc.

local str = require "string"

function str.split (s, sep)
    local t = {}
    for m in string.gmatch(s, sep) do
        table.insert(t, m)
    end
    if #t == 0 then
        table.insert(t, s)
    end
    return t
end

function str.join (t, sep)
    if #t < 2 then return t[1] end
    local s = ""
    for _, i in pairs(t) do
        s = s .. sep .. i
    end
    return s
end

function str.strip (s)
    local res, _ = string.gsub(s, '^%s*(.-)%s*$', '%1')
    return res
end

function str.starts (s, head)
    return string.len(s) >= string.len(head) and string.sub(s, 1, string.len(head)) == head
end

function str.ends (s, tail)
    return string.len(s) >= string.len(tail) and string.sub(s, -string.len(tail), -1) == tail
end

return str