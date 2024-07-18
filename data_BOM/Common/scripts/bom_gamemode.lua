--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v1.0
--
-- Functions related to 
--
print("Loading bom_gamemode.lua...")

-- load dependencies
ScriptCB_DoFile("bom_constants")


------------------------------------------------
------------   CLASS VARIABLES   ---------------
------------------------------------------------

-- formatted as {teamATT, teamDEF}
local teamNumbers = {}


------------------------------------------------
------------   SET FUNCTIONS   -----------------
------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setTeamNumbers
-- PURPOSE:     Saves team numbers to local memory
-- INPUT:		params = {teamATT = "", teamDEF = "", 
--						  overrideTeamNumbers = boolean} 
-- OUTPUT:
-- NOTES:       It is expected two team numbers are provided. If the they
-- 				are not provided or are previously saved, then they will be
--				set to default values. If team numbers have previously
--				been set, they can be overriden if passed
--				`overrideTeamNumbers = true`
---------------------------------------------------------------------------
local teamNumbers = {}
function setTeamNumbers(params)
	-- check if a team number was provided and a number has not been assigned yet
	local function validateTeamNumber(teamKey, teamNumber, defaultTeamNumber, overrideTeamNumbers)
		-- given a team and the team number has not been set
		if teamNummber and (not teamNumbers[teamKey] and not overrideTeamNumbers) then 
			assert(type(teamNumber) == "number", "Expected number, got " .. type(teamNumber))
			return teamNumber
		
		-- not given a team and the team number has not been set
		elseif not teamNumber and (not teamNumbers[teamKey] or overrideTeamNumbers) then
			print("Defaulting " .. teamKey .. " to team " .. defaultTeamNumber)
			return defaultTeamNumber
		
		-- a team number has already been set
		else
			return teamNumbers[teamKey]
		end
		
	end
	
	-- check for overrides
	local overrideTeamNumbers = params.overrideTeamNumbers or false
	
	-- set team numbers
	teamNumbers.teamATT = validateTeamNumber("teamATT", params.teamATT, getATT(), overrideTeamNumbers)
	teamNumbers.teamDEF = validateTeamNumber("teamDEF", params.teamDEF, getDEF(), overrideTeamNumbers)
end


------------------------------------------------
------------   GET FUNCTIONS   -----------------
------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    getTeamNumbers
-- PURPOSE:     Retrieve team numbers from local memory
-- INPUT:		
-- OUTPUT:		teamNumbers = {teamATT, teamDEF}
-- NOTES:       It is expected that setTeamNumbers() has already been
--				called. If not an error is thrown.
---------------------------------------------------------------------------
function getTeamNumbers()
	assert(teamNumbers, "Unexpected call: team numbers have not been set")
	return teamNumbers
end


------------------------------------------------
------------   GENERAL FUNCTIONS   -------------
------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    startObjective
-- PURPOSE:     Starts an objective or postpone to another time
-- INPUT:		objective, delayStart, objectiveName
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function startObjective(objective, delayStart, objectiveName)
	-- must be given an objective
	assert(objective, "Expected objective, got nil")
	
	-- objective type (for debugging)
	local objectiveName = objectiveName or ""

	-- auto start objective
	delayStart = delayStart or false
	if not delayStart then
		print("Starting " .. objectiveName .. " objective...")
		objective:Start()
	else
		print("Postponing " .. objectiveName .. " objective...")
	end
end