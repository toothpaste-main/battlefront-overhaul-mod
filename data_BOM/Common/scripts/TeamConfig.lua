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
------------------------   TEAM SET UP   -------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setTeamRelations
-- PURPOSE:     Set team relations acording to BOM rules
-- INPUT:
-- OUTPUT:
-- NOTES:		- Team 0 is default netural team
--				- Team 1 is team ATT
--				- Team 2 is team DEF
--				- Team 3 is reserved
--				- Team 4 is team ATT locals
--				- Team 5 is team DEF locals
--				- Team 6 is team ATT ambient
--				- Team 7 is team DEF ambient
---------------------------------------------------------------------------
function TeamConfig:setTeamRelations()
	-- Team 0 (neutral)

	-- Team 1 (team ATT)
	SetTeamAsEnemy(1, 2)
	SetTeamAsNeutral(1, 3)
	SetTeamAsFriend(1, 4)
	SetTeamAsEnemy(1, 5)
	SetTeamAsNeutral(1, 6)
	SetTeamAsNeutral(1, 7)
	
	-- Team 2 (team DEF)
	SetTeamAsEnemy(2, 1)
	SetTeamAsNeutral(2, 3)
	SetTeamAsEnemy(2, 4)
	SetTeamAsFriend(2, 5)
	SetTeamAsNeutral(2, 6)
	SetTeamAsNeutral(2, 7)
	
	-- Team 3 (reserved)
	SetTeamAsNeutral(3, 1)
	SetTeamAsNeutral(3, 2)
	SetTeamAsNeutral(3, 4)
	SetTeamAsNeutral(3, 5)
	SetTeamAsNeutral(3, 6)
	SetTeamAsNeutral(3, 7)
	
	-- Team 4 (team ATT locals)
	SetTeamAsFriend(4, 1)
	SetTeamAsEnemy(4, 2)
	SetTeamAsNeutral(4, 3)
	SetTeamAsEnemy(4, 5)
	SetTeamAsNeutral(4, 6)
	SetTeamAsNeutral(4, 7)
	
	-- Team 5 (team DEF locals)
	SetTeamAsEnemy(5, 1)
	SetTeamAsFriend(5, 2)
	SetTeamAsNeutral(5, 3)
	SetTeamAsEnemy(5, 4)
	SetTeamAsNeutral(5, 6)
	SetTeamAsNeutral(5, 7)
	
	-- Team 6 (team ATT ambient)
	SetTeamAsNeutral(6, 1)
	SetTeamAsNeutral(6, 2)
	SetTeamAsNeutral(6, 3)
	SetTeamAsNeutral(6, 4)
	SetTeamAsNeutral(6, 5)
	SetTeamAsEnemy(6, 7)
	
	-- Team 7 (team DEF ambient)
	SetTeamAsNeutral(7, 1)
	SetTeamAsNeutral(7, 2)
	SetTeamAsNeutral(7, 3)
	SetTeamAsNeutral(7, 4)
	SetTeamAsNeutral(7, 5)
	SetTeamAsEnemy(7, 6)
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
--					enableTeam3 = boolean,
--				}
-- OUTPUT:
-- NOTES:       
---------------------------------------------------------------------------
function TeamConfig:init(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")
	
	self:setTeamNames(params.teamNameATT, params.teamNameDEF)
	self:setTeamNumbers(params.teamNumberATT, params.teamNumberDEF)
	
	-- Initialize Team 3
	-- The maximum possible unit counts of Teams 4-7 are depend upon the
	-- unit count of Team 3. In the Battlefront Overhaul Mod, Team 3 is a
	-- reserved team. Teams 4 and 5 are used for the local units of Teams
	-- 1 and 2 respectively. And Teams 6 and 7 are used for ambient units
	-- for Teams 1 and 2 respectively. If you must use Team 3, then pass
	-- `enableTeam3 = true` when initializing TeamConfig. 
	-- To utilize this functionality on your map, you must add a CP to your
	-- map with its team set to `3`. For convention, use an invisible CP and
	-- place it underneath your map near the center of all the POIs. Name
	-- this CP `cp_team3`.
	if not params.enableTeam3 then
		SetUnitCount(3, 32)
		self.setTeamRelations()
	end
	
	self.initialized = true
end


-- import function
function get_TeamConfig()
	return TeamConfig
end
