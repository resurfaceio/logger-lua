-- © 2016-2022 Resurface Labs Inc.
local luaunit = require('luaunit')

ngx = pcall(require, "ngx") and require "ngx" or require("tests.test_helper").ngx

require 'tests.test_usagelogger'
require 'tests.test_baselogger'
require 'tests.test_httplogger'
require 'tests.test_resurfaceio'


luaunit.run()