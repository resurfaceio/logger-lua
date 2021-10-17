-- © 2016-2021 Resurface Labs Inc.

local HttpRules = {
   __DEBUG_RULES = [[
      allow_http_url
      copy_session_field /.*/
   ]],
   __STANDARD_RULES = [[
      /request_header:cookie|response_header:set-cookie/ remove
      /(request|response)_body|request_param/ replace /[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)/, /x@y.com/
      /request_body|request_param|response_body/ replace /[0-9\.\-\/]{9,}/, /xyxy/
   ]],
   __STRICT_RULES = [[
      /request_url/ replace /([^\?;]+).*/, !\\1!
      /request_body|response_body|request_param:.*|request_header:(?!user-agent).*|response_header:(?!(content-length)|(content-type)).*/ remove
   ]],
}

HttpRules.__default_rules = HttpRules.__STRICT_RULES


function HttpRules:new (o, rules)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   o.rules = rules or o.rules
   if o.rules == nil then
      o.rules = self.__default_rules
   end

   if string.sub(o.rules, 1, 7) == "file://" then
      local rfile = string.sub(o.rules, 7, -1)
      local file = assert(io.open(rfile, "r"), string.format("Failed to load rules: %s", rfile))
      o.rules = file.read()
      file.close()
   end


   return o
end

function HttpRules:apply (data)
   return {{"hello"}, {data}}
end

return HttpRules