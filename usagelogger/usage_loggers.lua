

UsageLoggers = {
    __BRICKED = os.getenv("USAGE_LOGGERS_DISABLE") == 'true', 
    __disabled = os.getenv("USAGE_LOGGERS_DISABLE") == 'true', 
    disable = function(self) self.__disabled = true end,
    enable = function(self) self.__disabled = false end,
    is_enabled = function(self) return not self.__disabled end,
    url_by_default = function() return os.getenv("USAGE_LOGGERS_URL") end,
}


return UsageLoggers