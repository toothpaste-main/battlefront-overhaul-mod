--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v1.0
--
-- Constants and functions related to the team
-- deathmatch game mode.
--
print("Loading bom_deathmatch.lua...")

-- load dependencies
ScriptCB_DoFile("bom_constants")
ScriptCB_DoFile("bom_gamemode")


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- message text for player (deathmatch)
local TEXT_ATT_DEA = "game.modes.tdm"
local TEXT_DEF_DEA = "game.modes.tdm2"

-- points per kill
local PPK_ATT = 1
local PPK_DEF = 1

local MULTIPLAYER_RULES_DEA = true


---------------------------------------------------------------------------
-- FUNCTION:    createDeathmatchObjective
-- PURPOSE:     Create team deathmatch objective
-- INPUT:		params = {teamATT, teamDEF,
--						  textATT, textDEF,
--						  pointsPerKillATT, pointsPerKillDEF,
--						  multiplayerRules
--						  delayStart}
-- OUTPUT:		ObjectiveTDM
-- NOTES:       To prevent the objective from automatically starting, set 
--				`delayStart` to true.
---------------------------------------------------------------------------
function createDeathmatchObjective(params)
	-- check if objective module is loaded
	assert(ObjectiveTDM, "ObjectiveTDM has not been loaded!")

	-- message text params
	local textATT_ = params.textATT or TEXT_ATT_DEA
	local textDEF_ = params.textDEF or TEXT_DEF_DEA
	
	-- points per kill params
	local ppkATT = params.ppkATT or PPK_ATT
	local ppkDEF = params.ppkDEF or PPK_DEF
	
	-- multiplayer rules params
	local multiplayerRules_ = params.multiplayerRules or MULTIPLAYER_RULES_DEA

	-- team numbers
	setTeamNumbers(params)
	
	-- create objective
	local tdm = ObjectiveTDM:New{teamATT = getTeamNumbers().teamATT, teamDEF = getTeamNumbers().teamDEF,
								 pointsPerKillATT = ppkATT, pointsPerKillDEF = ppkDEF,
								 textATT = textATT_, textDEF = textDEF_,
								 multiplayerRules = multiplayerRules_}
	print("Created: ObjectiveTDM")

	-- set AI goal
	tdm.OnStart = function(self)
    	AddAIGoal(getTeamNumbers().teamATT, "Deathmatch", 1000)
    	AddAIGoal(getTeamNumbers().teamDEF, "Deathmatch", 1000)
    end
	
	-- auto start objective
	startObjective(tdm, params.delayStart, "ObjectiveTDM")
	
	return tdm
end
