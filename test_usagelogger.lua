local luaunit = require('luaunit')
local zlib = require('zlib')


BaseLogger = require('usagelogger.base_logger')
UsageLoggers = require('usagelogger.usage_loggers')


TestBaseLogger = {}

    function TestBaseLogger:testHttpFalseStatus()
        local kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/500"}

        local b = BaseLogger:new(kwargs)
        local status = b:submit("hello")
        luaunit.assertEquals(status, false)
    end
-- print("Response from server " .. table.concat(response_body))

    function TestBaseLogger:testHttpTrueStatus()
        local kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/status/204"}

        local b = BaseLogger:new(kwargs)
        local status = b:submit("hello")
        luaunit.assertEquals(status, true)
    end

    --[[
    function TestBaseLogger:testCompression()
        local queue = {}
        local kwargs = {agent="usagelogger 0.1", url="https://httpbin.org/anything", skip_compression=true}
        
        local b = BaseLogger:new(kwargs)
        local lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed quam leo. Nullam placerat vitae nunc non pellentesque. Vestibulum quis accumsan nulla, eu interdum libero. Nullam porttitor semper pellentesque. Vivamus sed congue lorem. Praesent ac nulla semper, placerat nulla sagittis, rutrum justo. Nullam imperdiet, nulla eget pellentesque posuere, dolor lectus pulvinar lectus, eu maximus sem dui sit amet est. Aliquam ornare dui neque, quis laoreet velit facilisis vitae. Vestibulum molestie laoreet enim lacinia feugiat. Nulla facilisi. Fusce semper elit elit, in fermentum nibh vestibulum vitae. Proin mollis dictum lacinia."
        local status, res = b:submit(lorem)
        print(res[1])
        luaunit.assertEquals(lorem, lorem)
        
    end
    --]]

    TestUsageLogger = {}
        function TestUsageLogger:testEnableDisable()
            UsageLoggers:disable()
            luaunit.assertEquals(UsageLoggers.__disabled, true)
            UsageLoggers:enable()
            luaunit.assertEquals(UsageLoggers.__disabled, false)
        end



    luaunit.run()