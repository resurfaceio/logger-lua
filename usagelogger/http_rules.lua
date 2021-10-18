-- © 2016-2021 Resurface Labs Inc.

local HttpRule = require "usagelogger.http_rule"
local re = require "usagelogger.utils.re"
local string = require "usagelogger.utils.str"

local __REGEX_ALLOW_HTTP_URL = re.new([[^\s*allow_http_url\s*(#.*)?$]])
local __REGEX_BLANK_OR_COMMENT = re.new([[^\s*([#].*)*$]])
local __REGEX_COPY_SESSION_FIELD = re.new([[^\s*copy_session_field\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_REMOVE = re.new([[^\s*([~!%|/].+[~!%|/])\s*remove\s*(#.*)?$]])
local __REGEX_REMOVE_IF = re.new([[^\s*([~!%|/].+[~!%|/])\s*remove_if\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_REMOVE_IF_FOUND = re.new([[^\s*([~!%|/].+[~!%|/])\s*remove_if_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_REMOVE_UNLESS = re.new([[^\s*([~!%|/].+[~!%|/])\s*remove_unless\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_REMOVE_UNLESS_FOUND = re.new([[^\s*([~!%|/].+[~!%|/])\s*remove_unless_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_REPLACE = re.new([[^\s*([~!%|/].+[~!%|/])\s*replace[\s]+([~!%|/].+[~!%|/]),[\s]+([~!%|/].*[~!%|/])\s*(#.*)?$]])
local __REGEX_SAMPLE = re.new([[^\s*sample\s+(\d+)\s*(#.*)?$]])
local __REGEX_SKIP_COMPRESSION = re.new([[^\s*skip_compression\s*(#.*)?$]])
local __REGEX_SKIP_SUBMISSION = re.new([[^\s*skip_submission\s*(#.*)?$]])
local __REGEX_STOP = re.new([[^\s*([~!%|/].+[~!%|/])\s*stop\s*(#.*)?$]])
local __REGEX_STOP_IF = re.new([[^\s*([~!%|/].+[~!%|/])\s*stop_if\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_STOP_IF_FOUND = re.new([[^\s*([~!%|/].+[~!%|/])\s*stop_if_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_STOP_UNLESS = re.new([[^\s*([~!%|/].+[~!%|/])\s*stop_unless\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])
local __REGEX_STOP_UNLESS_FOUND = re.new([[^\s*([~!%|/].+[~!%|/])\s*stop_unless_found\s+([~!%|/].+[~!%|/])\s*(#.*)?$]])

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
   __len = function (t) return t._length end
}

HttpRules.__default_rules = HttpRules.__STRICT_RULES

function HttpRules.default_rules ()
   return HttpRules.__default_rules
end

function HttpRules.set_default_rules (rules)
   HttpRules.__default_rules = re.sub([[^\s*include default\s*$]], "", rules, "gm")
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

-- Parses rule from single line
function HttpRules.parse_rule (rule)
   if rule == nil or __REGEX_BLANK_OR_COMMENT:match(rule) then
      return nil
   end

   local m = __REGEX_ALLOW_HTTP_URL:match(rule)
   if m then
      return HttpRule:new(nil, "allow_http_url")
   end

   m = __REGEX_COPY_SESSION_FIELD:match(rule)
   if m then
      return HttpRule:new(
         nil, "copy_session_field", nil, HttpRules.parse_regex(rule, m[2])
      )
   end

   m = __REGEX_REMOVE:match(rule)
   if m then
      return HttpRule:new(nil, "remove", HttpRules.parse_regex(rule, m[2]))
   end

   m = __REGEX_REMOVE_IF:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "remove_if",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex(rule, m[3])
      )
   end

   m = __REGEX_REMOVE_IF_FOUND:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "remove_if_found",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex_find(rule, m[3])
      )
   end

   m = __REGEX_REMOVE_UNLESS:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "remove_unless",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex(rule, m[3])
      )
   end

   m = __REGEX_REMOVE_UNLESS_FOUND:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "remove_unless_found",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex_find(rule, m[3])
      )
   end

   m = __REGEX_REPLACE:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "replace",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex_find(rule, m[3]),
         HttpRules.parse_string(rule, m[4])
      )
   end

   m = __REGEX_SAMPLE:match(rule)
   if m then
      local msg = "Invalid sample percent: " .. m[2]
      local m1 = assert(m[2] + 0, msg)
      assert(m1 >= 1 and m1 <= 99, msg)
      return HttpRule:new(nil, "sample", nil, m1)
   end

   m = __REGEX_SKIP_COMPRESSION:match(rule)
   if m then
      return HttpRule:new(nil, "skip_compression")
   end

   m = __REGEX_SKIP_SUBMISSION:match(rule)
   if m then
      return HttpRule:new(nil, "skip_submission")
   end

   m = __REGEX_STOP:match(rule)
   if m then
      return HttpRule:new(nil, "stop", HttpRules.parse_regex(rule, m[2]))
   end

   m = __REGEX_STOP_IF:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "stop_if",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex(rule, m[3])
      )
   end

   m = __REGEX_STOP_IF_FOUND:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "stop_if_found",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex_find(rule, m[3])
      )
   end

   m = __REGEX_STOP_UNLESS:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "stop_unless",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex(rule, m[3])
      )
   end

   m = __REGEX_STOP_UNLESS_FOUND:match(rule)
   if m then
      return HttpRule:new(
         nil,
         "stop_unless_found",
         HttpRules.parse_regex(rule, m[2]),
         HttpRules.parse_regex_find(rule, m[3])
      )
   end

   error("Invalid rule: " .. rule)
end

-- Parses regex for matching.
function HttpRules.parse_regex (rule, regex)
   local s = HttpRules.parse_string(rule, regex)
   if string.sub(s, 1, 1) ~= "^" then
      s = "^" .. s
   end
   if string.sub(s,-1,-1) ~= "$" then
      s = s .. "$"
   end
   local r = re.new(s)
   assert(r and r.p, string.format("Invalid regex (%s) in rule: %s", regex, rule))
   return r
end

-- Parses regex for finding.
function HttpRules.parse_regex_find (rule, regex)
   local r = re.new(HttpRules.parse_string(rule, regex))
   assert(r and r.p, string.format("Invalid regex (%s) in rule: %s", regex, rule))
   return r
end

-- Parses delimited string expression.
function HttpRules.parse_string (rule, expr)
   for _, sep in pairs({"~", "!", "%", "|", "/"}) do
      local p = re.new(string.format([[^[%s](.*)[%s]$]], sep, sep))
      local m = p:match(expr)
      if m then
         local m1 = m[2]
         local m1p = re.new(string.format([[^[%s].*|.*[^\\\\][%s].*]], sep, sep))
         if m1p:match(m1) then
            error(string.format("Unescaped separator (%s) in rule: %s", sep, rule))
         end
         return string.join(string.split(m1, "([^" .. "\\" .. sep .. "]+)"), sep)
      end
   end
   error(string.format("Invalid expression (%s) in rule: %s", expr, rule))
end

-- Constructor
function HttpRules:new (o, rules)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   rules = rules or o.rules
   if rules == nil then
      rules = self.__default_rules
   end

   -- load rules from external files
   if string.sub(rules, 1, 7) == "file://" then
      local rfile = string.sub(rules, 7, -1)
      local file = assert(io.open(rfile, "r"), string.format("Failed to load rules: %s", rfile))
      rules = file:read()
      file:close()
   end

   -- force default rules if necessary
   rules = re.sub(
      [[^\s*include default\s*$]],
      HttpRules.default_rules(),
      rules,
      "gm"
   )
   if #string.gsub(rules, "%s", "") == 0 then
      rules = HttpRules.default_rules()
   end

   -- expand rule includes
   rules = re.sub([[^\s*include debug\s*$]], HttpRules.debug_rules(), rules, "m")
   rules = re.sub([[^\s*include standard\s*$]], HttpRules.standard_rules(), rules, "m")
   rules = re.sub([[^\s*include strict\s*$]], HttpRules.strict_rules(), rules, "m")
   o._text = rules

   -- parse all rules
   local prs = {}
   local split = string.split(rules, "([^\n]+)")
   for _, rule in pairs(split) do
      local parsed = HttpRules.parse_rule(rule)
      if parsed ~= nil then
         table.insert(prs, parsed)
      end
   end
   o._length = #prs

   -- break out rules by verb
   local function list (verb)
      local t = {}
      for _, r in pairs(prs) do
         if verb == r:verb() then
            table.insert(t, r)
         end
      end
      return t
   end

   o._allow_http_url = #list("allow_http_url") > 0

   o._copy_session_field = list("copy_session_field")

   o._remove = list("remove")

   o._remove_if = list("remove_if")

   o._remove_if_found = list("remove_if_found")

   o._remove_unless = list("remove_unless")

   o._remove_unless_found = list("remove_unless_found")

   o._replace = list("replace")

   o._sample = list("sample")

   o._skip_compression = #list("skip_compression") > 0

   o._skip_submission = #list("skip_submission") > 0

   o._stop = list("stop")

   o._stop_if = list("stop_if")

   o._stop_if_found = list("stop_if_found")

   o._stop_unless = list("stop_unless")

   o._stop_unless_found = list("stop_unless_found")

   -- validate rules
   assert(#o._sample < 2, "Multiple sample rules")

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

function HttpRules:apply (details)
   -- stop rules come first
   for _, r in pairs(self._stop) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) then
              return nil
          end
      end
   end

   for _, r in pairs(self._stop_if_found) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.search(d[2]) then
              return nil
          end
      end
   end

   for _, r in pairs(self._stop_if) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.match(d[2]) then
              return nil
          end
      end
   end

   local passed = 0
   for _, r in pairs(self._stop_unless_found) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.search(d[2]) then
              passed = passed + 1
          end
      end
   end

   if passed ~= #self._stop_unless_found then
      return nil
   end

   passed = 0
   for _, r in pairs(self._stop_unless) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.match(d[2]) then
              passed = passed + 1
          end
      end
   end

   if passed ~= #self._stop_unless then
      return nil
   end

   -- do sampling if configured
   if #self._sample == 1 and math.random(100) >= self._sample[1]:param1() then
      return nil
   end

   -- winnow sensitive details based on remove rules if configured
   for _, r in pairs(self._remove) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) then
              d[2] = ""
          end
      end
   end

   for _, r in pairs(self._remove_unless_found) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and not r.param1.search(d[2]) then
              d[2] = ""
          end
      end
   end

   for _, r in pairs(self._remove_if_found) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.search(d[2]) then
              d[2] = ""
          end
      end
   end

   for _, r in pairs(self._remove_unless) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and not r.param1.match(d[2]) then
              d[2] = ""
          end
      end
   end

   for _, r in pairs(self._remove_if) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) and r.param1.match(d[2]) then
              d[2] = ""
          end
      end
   end

   -- remove any details with empty values
   local function rmempty ()
      local newdetails = {}
      for _, x in pairs(details) do
          if x[1] ~= "" then
              table.insert(newdetails, x)
          end
      end
      return details
   end

   details = rmempty()
   if #details == 0 then
      return nil
   end

   -- mask sensitive details based on replace rules if configured
   for _, r in pairs(self._replace) do
      for _, d in pairs(details) do
          local scope = r.scope()
          if scope.match(d[1]) then
              d[2] = re.sub(r.param1, r.param2, d[2])
          end
      end
   end

   -- remove any details with empty values
   details = rmempty()
   return #details ~= 0 and details or nil
end


return HttpRules
