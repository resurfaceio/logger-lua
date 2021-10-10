

UsageLoggers = {
    __BRICKED = os.getenv("USAGE_LOGGERS_DISABLE") == 'true', 
    __disabled = os.getenv("USAGE_LOGGERS_DISABLE") == 'true', 
    disable = function(self) self.__disabled = true end,
    enable = function(self) self.__disabled = false end,
    is_enabled =  not self.__disabled,
    url_by_default = os.getenv("USAGE_LOGGERS_URL"),
}


return UsageLoggers