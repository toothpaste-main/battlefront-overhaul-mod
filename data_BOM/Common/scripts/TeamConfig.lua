--[[
	Battlefront Mission Helper
	Module name: TeamConfig
	Description: Team properties
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies: tableUtils, constants
	Notes:
--]]
local TeamConfig = {
	name = "TeamConfig",
	version = 1.0,
	
	initialized = false,
	
	teamNames = {},
	teamNumbers = {},
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")
local constants = import("constants")


function TeamConfig:isInitialized()
	assert(self.initialized, "ERROR: " .. self.name .. " has not been initialized!")
	return self.initialized
end

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   SET FUNCTIONS   -----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setTeamNames
-- PURPOSE:     Saves team numbers to local memory
-- INPUT:		params = {
--					teamATT = "", 
--					teamDEF = "", 
--				} 
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function TeamConfig:setTeamNames(teamATT, teamDEF)
	local function validateTeamName(teamName)
		assert(type(teamName) == "string", "ERROR: Expected string for teamName, got " .. type(teamName))
		assert(tableUtils.isValueInTable(constants.getTeamNamesShort(), teamName), "ERROR: Invalid teamName " .. teamName)
	end

	validateTeamName(teamATT)
	validateTeamName(teamDEF)
	
	-- check if overriding team name
	if self.teamNameATT then
		print("WARNING: Overriding teamNameATT")
	end
	if self.teamNameDEF then
		print("WARNING: Overriding teamNameDEF")
	end
	
	self.teamNames.teamATT = teamATT
	self.teamNames.teamDEF = teamDEF
end


---------------------------------------------------------------------------
-- FUNCTION:    setTeamNumbers
-- PURPOSE:     Saves team numbers to local memory
-- INPUT:		params = {
--					teamATT, 
--					teamDEF,
--				} 
-- OUTPUT:
-- NOTES:       It is expected two team numbers are provided. If the they
-- 				are not provided or are previously saved, then they will be
--				set to default values.
---------------------------------------------------------------------------
function TeamConfig:setTeamNumbers(teamATT, teamDEF, overrideTeamNumbers)
	if overrideTeamNumbers ~= nil then
		print("WARNING: overrideTeamNumbers is depricated")
	end

	-- check if a team number was provided and a number has not been assigned yet
	local function validateTeamNumber(teamKey, teamNumber, defaultTeamNumber, overrideTeamNumbers)
		-- given a team and the team number has not been set
		if teamNummber and (not self.teamNumbers[teamKey] and not overrideTeamNumbers) then
			-- must be number
			local err = "ERROR: Expected number, got " .. type(teamNumber)
			assert(type(teamNumber) == "number", err)
			
			-- must be within range
			err =  "ERROR: Expected team number between 0 and " .. (constants.getMaxTeams() - 1) .. " inclusive, got " .. teamNumber
			assert(0 <= teamNumber and teamNumber < constants.getMaxTeams(), err)
			
			return teamNumber
		
		-- not given a team and the team number has not been set
		elseif not teamNumber and (not self.teamNumbers[teamKey] or overrideTeamNumbers) then
			print("Defaulting " .. teamKey .. " to team " .. defaultTeamNumber)
			return defaultTeamNumber
		
		-- a team number has already been set
		else
			return self.teamNumbers[teamKey]
		end
	end
	
	-- check for overrides
	local overrideTeamNumbers = overrideTeamNumbers or false
	
	-- set team numbers
	self.teamNumbers.teamATT = validateTeamNumber("teamATT", teamATT, constants.getATT(), overrideTeamNumbers)
	self.teamNumbers.teamDEF = validateTeamNumber("teamDEF", teamDEF, constants.getDEF(), overrideTeamNumbers)
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   GET FUNCTIONS   -----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    getTeamNames
-- PURPOSE:     Retrieve team names from local memory
-- INPUT:		
-- OUTPUT:		teamNumbers = {teamATT, teamDEF}
-- NOTES:       It is expected that setTeamNumbers() has already been
--				called. If not an error is thrown.
---------------------------------------------------------------------------
function TeamConfig:getTeamNames()
	assert(self.teamNames, "ERROR: Attempted to get teamNames when teamNames has not been set")
	return self.teamNames
end


---------------------------------------------------------------------------
-- FUNCTION:    getTeamNumbers
-- PURPOSE:     Retrieve team numbers from local memory
-- INPUT:		
-- OUTPUT:		teamNumbers = {teamATT, teamDEF}
-- NOTES:       It is expected that setTeamNumbers() has already been
--				called. If not an error is thrown.
---------------------------------------------------------------------------
function TeamConfig:getTeamNumbers()
	assert(self.teamNumbers, "ERROR: Attempted to get teamNumbers when teamNumbers has not been set")
	return self.teamNumbers
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   INITIALIZATION   ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    init
-- PURPOSE:     Initialize TeamConfig
-- INPUT:		params = {
--					teamNameATT, teamNameDEF,
--					teamNumberATT, teamNumberDEF,
--				}
-- OUTPUT:
-- NOTES:       
---------------------------------------------------------------------------
function TeamConfig:init(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")
	
	self:setTeamNames(params.teamNameATT, params.teamNameDEF)
	self:setTeamNumbers(params.teamNumberATT, params.teamNumberDEF)
	
	self.initialized = true
end


-- import function
function get_TeamConfig()
	return TeamConfig
end
