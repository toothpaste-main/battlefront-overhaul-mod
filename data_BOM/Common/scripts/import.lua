--[[
	Battlefront Mission Helper
	Module name: import
	Description: Implentation of `require()` function
	Authord: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies: 
	Notes: This module could function for many purposes, but for
		   convention, it should be strictly used to indicate the use of
		   `require`.
--]]
print("Loading import.lua...")

local versionRegistry = {
	-- utils
	table_utils = 1.0,
	constants = 1.0,

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
}

local loadedModules = {}
function import(moduleName)
	-- check if name is a string
	assert(type(moduleName) == "string", "ERROR: Expected string, got " .. type(moduleName))

	print("Loading " .. moduleName .. ".lua...")
	
	-- check if module is already loaded
	if loadedModules[moduleName] then
		print("Already loaded " .. moduleName .. ".lua.")
		return loadedModules[moduleName]
	end
	
	-- load module
	ScriptCB_DoFile(moduleName)
	
	-- build getFunction name
	local getFunctionName = "get_" .. moduleName
	
	-- check if function exists
	assert(_G[getFunctionName], "ERROR: Get-function " .. getFunctionName .. "() does not exist!")
	
	-- load module instance
	local moduleInstance = _G[getFunctionName]()
	
	-- check if version matches records
	if versionRegistry[moduleName] ~= moduleInstance.version then
		print("WARNING: " .. moduleName .. " is out of date or version could not be found in registry.")
	end
	
	-- save module istance if imported again
	loadedModules[moduleName] = moduleInstance
	
	-- clean up clobal namespace
	_G[getFunctionName] = nil
	
	print("Loaded " .. moduleName .. ".lua.")
	return moduleInstance
end

print("Loaded import.lua.")
