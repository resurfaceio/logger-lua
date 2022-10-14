-- © 2016-2022 Resurface Labs Inc.

local isffizlib, err1 = pcall(require, "ffi-zlib")
local isluazlib, err2 = pcall(require, "zlib")
local zlib = isffizlib and require("ffi-zlib") or isluazlib and require("zlib") or error(
    "no zlib module found. Either install 'lua-ffi-zlib' or 'lua-zlib'" ..
    "\n" .. err1 ..
    "\n" .. err2 ..
    "\n"
)

if zlib then
    if isluazlib then
        local deflate = zlib.deflate
        zlib.deflate = function (message)
            local ERROR_MESSAGE = "there was an issue with message compression using 'lua-zlib'"
            local stream = deflate()
            if stream == nil then
                error(ERROR_MESSAGE)
            end
            local deflated = stream(message, "finish")
            if deflated == nil then
                error(ERROR_MESSAGE)
            end

            return deflated
        end
    else
        zlib.deflate = function (message)
            local ERROR_MESSAGE = "there was an issue with message compression using 'lua-ffi-zlib': "
            local receiver
            local _, err = zlib.deflateGzip(
                function (chunksize)
                    return string.sub(message, 1, 1 + chunksize)
                end,
                function (data)
                    receiver = data
                end
            )
            if err then
                error(ERROR_MESSAGE .. err)
            end

            return receiver
        end
    end
end


return zlib
