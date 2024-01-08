-- © 2016-2024 Graylog, Inc.

local lu = require('luaunit')

local BaseLogger = require('usagelogger.base_logger')
local helpers = require('tests.test_helper')


TestBaseLogger = {}

function TestBaseLogger:testCreatesInstance()
    local logger = BaseLogger:new{agent=helpers.MOCK_AGENT}
    lu.assertNotNil(logger)
    lu.assertEquals(logger.agent, helpers.MOCK_AGENT)
    lu.assertIsFalse(logger.enableable)
    lu.assertIsFalse(logger.enabled)
    lu.assertIsNil(logger.queue)
    lu.assertIsNil(logger.url)
end

function TestBaseLogger:testCreatesMultipleInstances()
    local agent1 = "agent1"
    local agent2 = "AGENT2"
    local agent3 = "aGeNt3"
    local url1 = "http://resurface.io"
    local url2 = "http://whatever.com"
    local logger1 = BaseLogger:new{agent=agent1, url=url1}
    local logger2 = BaseLogger:new{agent=agent2, url=url2}
    local logger3 = BaseLogger:new{agent=agent3, url=helpers.DEMO_URL}

    lu.assertEquals(logger1.agent, agent1)
    lu.assertIsTrue(logger1.enableable)
    lu.assertIsTrue(logger1.enabled)
    lu.assertEquals(logger1.url, url1)
    lu.assertEquals(logger2.agent, agent2)
    lu.assertIsTrue(logger2.enableable)
    lu.assertIsTrue(logger2.enabled)
    lu.assertEquals(logger2.url, url2)
    lu.assertEquals(logger3.agent, agent3)
    lu.assertIsTrue(logger3.enableable)
    lu.assertIsTrue(logger3.enabled)
    lu.assertEquals(logger3.url, helpers.DEMO_URL)

    -- UsageLoggers:disable()
    -- assert (UsageLoggers:is_enabled() == false)
    -- assert (logger1.enabled == false)
    -- assert (logger2.enabled == false)
    -- assert (logger3.enabled == false)
    -- UsageLoggers:enable()
    -- assert (UsageLoggers:is_enabled() == true)
    -- assert (logger1.enabled == true)
    -- assert (logger2.enabled == true)
    -- assert (logger3.enabled == true)


end

function TestBaseLogger:test_has_valid_host()
    local host = BaseLogger.host_lookup()
    lu.assertNotNil (host)
    lu.assertIsTrue(string.len(host) > 0)
    lu.assertNotEquals (host, "unknown")
    -- tmp = BaseLogger:new()
    -- assert (host == tmp.host )
end