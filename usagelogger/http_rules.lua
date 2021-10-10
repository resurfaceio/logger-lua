
local HttpRules = {}

 function HttpRules:new(o, rules)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.rules = rules
   
    return o
    
 end

 function HttpRules:apply(data)
 end

return HttpRules