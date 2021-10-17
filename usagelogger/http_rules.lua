-- © 2016-2021 Resurface Labs Inc.

local re = require "regex"

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
   __index = {
      __len = function (t) return t._length end
   }
}

HttpRules.__default_rules = HttpRules.__STRICT_RULES

function HttpRules.default_rules ()
   return HttpRules.__default_rules
end

function HttpRules.set_default_rules (rules)
   -- HttpRules.__default_rules = re.sub([[^\s*include default\s*$]], "", rules, MULTILINE)
end

function HttpRules.debug_rules ()
   return HttpRules.__DEBUG_RULES
end

function HttpRules.standard_rules ()
   return HttpRules.__STANDARD_RULES
end

function HttpRules.strict_rules ()
   return HttpRules.__STRICT_RULES
end

-- Parses rule from single
function HttpRules.parse_rule (rules)
   
end

function HttpRules.parse_regex (rule, regex)
   
end

function HttpRules.parse_regex_find (rule, regex)
   
end

function HttpRules.parse_string (rule, expr)
   
end

-- Constructor
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

   
function HttpRules:allow_http_url ()
   return self._allow_http_url
end
    
function HttpRules:copy_session_field ()
   return self._copy_session_field
end
    
function HttpRules:remove ()
   return self._remove
end
    
function HttpRules:remove_if ()
   return self._remove_if
end
    
function HttpRules:remove_if_found ()
   return self._remove_if_found
end
    
function HttpRules:remove_unless ()
   return self._remove_unless
end
    
function HttpRules:remove_unless_found ()
   return self._remove_unless_found
end
    
function HttpRules:replace ()
   return self._replace
end
    
function HttpRules:sample ()
   return self._sample
end
    
function HttpRules:skip_compression ()
   return self._skip_compression
end
    
function HttpRules:skip_submission ()
   return self._skip_submission
end
    
function HttpRules:stop ()
   return self._stop
end
    
function HttpRules:stop_if ()
   return self._stop_if
end
    
function HttpRules:stop_if_found ()
   return self._stop_if_found
end
    
function HttpRules:stop_unless ()
   return self._stop_unless
end
    
function HttpRules:stop_unless_found ()
   return self._stop_unless_found
end
    
function HttpRules:text ()
   return self._text
end

function HttpRules:apply (data)
   return {{"hello"}, {data}}
end

-- __REGEX_ALLOW_HTTP_URL = re.compile([[^\s*allow_http_url\s*(#.*)?$]])
-- __REGEX_BLANK_OR_COMMENT = re.compile([[^\s*([#].*)*$]])
-- __REGEX_COPY_SESSION_FIELD = re.compile(
--     [[^\s*copy_session_field\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_REMOVE = re.compile([[^\s*([~!%|/].+[~!%|/])\s*remove\s*(#.*)?$]])
-- __REGEX_REMOVE_IF = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*remove_if\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_REMOVE_IF_FOUND = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*" [[remove_if_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_REMOVE_UNLESS = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*" [[remove_unless\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_REMOVE_UNLESS_FOUND = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*"
--     [[remove_unless_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_REPLACE = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*"
--     [[replace[\s]+([~!%|/].+[~!%|/]),[\s]+([~!%|/].*[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_SAMPLE = re.compile([[^\s*sample\s+(\d+)\s*(#.*)?$]])
-- __REGEX_SKIP_COMPRESSION = re.compile([[^\s*skip_compression\s*(#.*)?$]])
-- __REGEX_SKIP_SUBMISSION = re.compile([[^\s*skip_submission\s*(#.*)?$]])
-- __REGEX_STOP = re.compile([[^\s*([~!%|/].+[~!%|/])\s*stop\s*(#.*)?$]])
-- __REGEX_STOP_IF = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*stop_if\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_STOP_IF_FOUND = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*" [[stop_if_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_STOP_UNLESS = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*stop_unless\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )
-- __REGEX_STOP_UNLESS_FOUND = re.compile(
--     [[^\s*([~!%|/].+[~!%|/])\s*" [[stop_unless_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]]
-- )


return HttpRules
