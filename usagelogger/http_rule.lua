-- © 2016-2022 Resurface Labs Inc.

local HttpRule = {}


function HttpRule:new (o, verb, scope, param1, param2)
    o = o or {}
    local instance = {
        _verb = assert(verb or o.verb, "verb is required"),
        _scope = scope or o.scope,
        _param1 = param1 or o.param1,
        _param2 = param2 or o.param2
    }

    setmetatable(instance, self)
    self.__index = self

    return instance
end

function HttpRule:verb ()
    return self._verb
end

function HttpRule:scope ()
    return self._scope
end

function HttpRule:param1 ()
    return self._param1
end

function HttpRule:param2 ()
    return self._param2
end

return HttpRule
