--[[
	Battlefront Mission Helper
	Module name: import
	Description: Implentation of `require()` function
	Authord: ToothpasteMain
	Version: v1.0
	Date: 2024-08-03
	Dependencies: logger
	Notes: This module could function for many purposes, but for
		   convention, it should be strictly used to indicate the use of
		   `require`.
--]]
print("[INFO]: Loading import.lua...")

-- load logger
local logger = ""
local function loadLogger()
	ScriptCB_DoFile("logger")
	logger = get_logger()
end
assert(pcall(loadLogger) and logger, "[CRITICAL]: import.lua failed to load logger.lua")
logger:success("import.lua loaded logger.lua")

local versionRegistry = {
	-- utils
	table_utils = 1.0,
	constants = 1.0,
	logger = 1.0,

	-- battlefront mission helper
	memorypool = 1.0,
	mission_properties = 1.0,
	TeamConfig = 1.0,
	
	-- objective
	objective_helper = 1.0,
	objective_ctf_helper = 1.0,
	objective_conquest_helper = 1.0,
	objective_hunt_helper = 1.0,
	objective_tdm_helper = 1.0,
	
	-- battlefront overhaul mod
	bom_common = 1.0,
	all_config = 1.0,
	cis_config = 1.0,
	imp_config = 1.0,
	rep_config = 1.0,
}

local loadedModules = {}
function import(moduleName)
	-- check if name is a string
	assert(type(moduleName) == "string", logger:error("Expected string, got " .. type(moduleName)))

	logger:info("Loading " .. moduleName .. ".lua...")
	
	-- check if module is already loaded
	if loadedModules[moduleName] then
		logger:notice("Already loaded " .. moduleName .. ".lua")
		return loadedModules[moduleName]
	end
	
	-- load module
	ScriptCB_DoFile(moduleName)
	
	-- build getFunction name
	local getFunctionName = "get_" .. moduleName
	
	-- check if function exists
	assert(_G[getFunctionName], logger:error("Get-function " .. getFunctionName .. "() does not exist"))
	
	-- load module instance
	local moduleInstance = _G[getFunctionName]()
	
	-- check if version matches records
	if versionRegistry[moduleName] ~= moduleInstance.version then
		logger:warning(moduleName .. " is out of date or version could not be found in registry")
	end
	
	-- save module istance if imported again
	loadedModules[moduleName] = moduleInstance
	
	-- clean up clobal namespace
	_G[getFunctionName] = nil
	
	logger:success("Loaded " .. moduleName .. ".lua")
	return moduleInstance
end

-- used to load config files
function fetch(moduleName)
	return import(moduleName)
end


logger.info("Loaded import.lua")
