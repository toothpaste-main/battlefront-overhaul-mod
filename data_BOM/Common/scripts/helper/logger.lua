--[[
	Battlefront Mission Helper
	Module name: logger
	Description: Logging functions
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-07
	Dependencies:
	Notes:
--]]
local logger = {
	name = "logger",
	version = 1.0,
}


---------------------------------------------------------------------------
-- FUNCTION:    logger
-- PURPOSE:     Generate and print log message
-- INPUT:		level, message, returnString = boolean 
-- OUTPUT:		nil or string
-- NOTES:
---------------------------------------------------------------------------
function logger.logger(level, message, returnString)
	local levels = {
		DEBUG = true, -- detailed debug information
		DEPRECATED = true, -- indicates an operation is deprecated
		INFO = true, -- indicate program progress
		NOTICE = true, -- indicate noteworthy events not resulting in problems
		WARNING = true, -- indicate problem not resulting in failure
		ERROR = true, -- indicate failed operation
		SUCCESS = true, -- indicate successful operation
	}

	if not levels[level] then
        level = "UNKNOWN"
    end
	
	local logMessage = string.format("[%s] %s", level, message)
	
	if not returnString then
		print(logMessage)
	else
		return logMessage
	end
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   SIMPLIFIED FUNCTIONS   ----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    dubug
-- PURPOSE:     Print log message with debug severity
-- INPUT:		message
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function logger:debug(message)
	self.logger("DEBUG", message .. ".")
end


---------------------------------------------------------------------------
-- FUNCTION:    deprecated
-- PURPOSE:     Print log message with deprecated severity
-- INPUT:		message
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function logger:deprecated(messsage)
	self.logger("DEPRECATED", message .. ".")
end


---------------------------------------------------------------------------
-- FUNCTION:    info
-- PURPOSE:     Print log message with info severity
-- INPUT:		message
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function logger:info(message)
	self.logger("INFO", message .. ".")
end


---------------------------------------------------------------------------
-- FUNCTION:    notice
-- PURPOSE:     Print log message with notice severity
-- INPUT:		message
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function logger:notice(message)
	self.logger("NOTICE", message .. ".")
end


---------------------------------------------------------------------------
-- FUNCTION:    warning
-- PURPOSE:     Print log message with warning severity
-- INPUT:		message
-- OUTPUT
-- NOTES:
---------------------------------------------------------------------------
function logger:warning(message)
	self.logger("WARNING", message .. ".")
end


---------------------------------------------------------------------------
-- FUNCTION:    error
-- PURPOSE:     Generate or print log message with error severity
-- INPUT:		message, throw = boolean 
-- OUTPUT:		nil or string
-- NOTES:		Throwing an error is deprecated and should be avoided for
--				clarity. The funcitonaltiy is merely included to show that 
--				the process is possible.
---------------------------------------------------------------------------
function logger:error(message, throw)
	logMessage = self.logger("ERROR", message .. "!", true)

	if throw then
		self.deprecated("Throwing an error with logger.error() is for proof of concept. It is recommend you use error(logger:error(message)) for clarity")
		error(logMessage)
	else 
		return logMessage
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    success
-- PURPOSE:     Generate and print log message with success severity
-- INPUT:		message
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function logger:success(message)
	self.logger("SUCCESS", message .. ".")
end


-- import function
function get_logger()
	return logger
end
