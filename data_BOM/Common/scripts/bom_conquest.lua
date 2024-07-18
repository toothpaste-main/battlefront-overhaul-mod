--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v1.0
--
-- Constants and functions related to the 
-- conquest game mode. All parameters are 
-- assumed to be strings unless stated 
-- otherwise.
--
print("Loading bom_conquest.lua...")

-- load dependencies
ScriptCB_DoFile("bom_constants")
ScriptCB_DoFile("bom_gamemode")


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- message text for player
local TEXT_ATT_CON = "game.modes.con"
local TEXT_DEF_CON = "game.modes.con2"

local MULTIPLAYER_RULES_CON = true


---------------------------------------------------------------------------
-- FUNCTION:    addCPs
-- PURPOSE:     Add CPs to conquest objective
-- INPUT:		conquestt, cps = {"cp1", "cp2", ...}
-- OUTPUT:
-- NOTES:		The value of `cps` are command post names.
---------------------------------------------------------------------------
local function addCPs(conquest, cps)
	-- check if cps is a table
	assert(type(cps) == "table", "Expected table, got " .. type(cps))

	-- error message if there are too many cps
	local err = "Too many command posts! Expected " .. getMaxCommandPosts()
	err = err .. ", got... I only count until there is too many"
	
	local maxCPs = 0
	for numCPs, cp in cps do	
		-- create command post and add to the objective
		conquest:AddCommandPost(CommandPost:New{name = cp})
				
		-- check if too many command posts
		assert(numCPs <= getMaxCommandPosts(), err)
		maxCPs = numCPs
	end
	print(maxCPs .. " command posts added to the objective")
end


---------------------------------------------------------------------------
-- FUNCTION:    createConquestObjective
-- PURPOSE:     Create conquest objective with given command posts
-- INPUT:		params = {teamATT, teamDEF,
--						  cps = {"cp1", "cp2", ...},
--						  delayStart}
-- OUTPUT:		ObjectiveConquest
-- NOTES:       To prevent the objective from automatically starting, set 
--				`delayStart` to true.
---------------------------------------------------------------------------
function createConquestObjective(params)
	-- check if objective module is loaded
	assert(ObjectiveConquest, "ObjectiveConquest has not been loaded!")

	-- team numbers
	setTeamNumbers(params)
	
	-- create objective
	local conquest = ObjectiveConquest:New{teamATT = getTeamNumbers().teamATT, teamDEF = getTeamNumbers().teamDEF,
										   textATT = TEXT_ATT_CON, textDEF = TEXT_DEF_CON,
										   multiplayerRules = MULTIPLAYER_RULES_CON}
	print("Created: ObjectiveConquest")

	-- add CPs to the objective
	addCPs(conquest, params.cps)
	
	-- auto start objective
	startObjective(conquest, params.delayStart, "conquest")
	
	return conquest
end
