local luaunit = require('luaunit')

local BaseLogger = require('usagelogger.base_logger')

helpers = require('tests.test_helper')




TestBaseLogger = {}

function TestBaseLogger:testCreatesInstance()
    local logger = BaseLogger:new{agent=helpers.MOCK_AGENT}
    assert (logger ~= nil)
    assert (logger.agent == helpers.MOCK_AGENT)
    assert (logger.enableable == false)
    assert (logger.enabled == false)
    assert (logger.queue == nil)
    assert (logger.url == nil)
end

function TestBaseLogger:testCreatesMultipleInstances()
    agent1 = "agent1"
    agent2 = "AGENT2"
    agent3 = "aGeNt3"
    url1 = "http://resurface.io"
    url2 = "http://whatever.com"
    logger1 = BaseLogger:new{agent=agent1, url=url1}
    logger2 = BaseLogger:new{agent=agent2, url=url2}
    logger3 = BaseLogger:new{agent=agent3, url=helpers.DEMO_URL}

    assert (logger1.agent == agent1)
    assert (logger1.enableable == true)
    assert (logger1.enabled == true)
    assert (logger1.url == url1)
    assert (logger2.agent == agent2)
    assert (logger2.enableable == true)
    assert (logger2.enabled == true)
    assert (logger2.url == url2)
    assert (logger3.agent == agent3)
    assert (logger3.enableable == true)
    assert (logger3.enabled == true)
    assert (logger3.url == helpers.DEMO_URL)

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

function TestBaseLogger:testHasValidHost()
    host = BaseLogger.host_lookup()
    assert (host ~= nil)
    assert (string.len(host) > 0)
    assert (host ~= "unknown")
    -- tmp = BaseLogger:new()
    -- assert (host == tmp.host )
end