--[[
	Battlefront Mission Helper
	Module name: objective_tdm_helper
	Description: Helper module for team deathmatch set up
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies: constants, objective_helper
	Notes: All parameters are assumed to be strings unless stated 
		   otherwise.
--]]
local objective_tdm_helper = {
	name = "objective_tdm_helper",
	version = 1.0,
	
	initialized = false,
}

-- load dependencies
ScriptCB_DoFile("import")
local constants = import("constants")
local objectiveHelper = import("objective_helper")
local TeamConfig = import("TeamConfig")


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- points per kill
local PPK_ATT = 1
local PPK_DEF = 1

-- goal weight
local GOAL_WEIGHT_ATT = 1000
local GOAL_WEIGHT_DEF = 1000

local MULTIPLAYER_RULES = true


---------------------------------------------------------------------------
-- FUNCTION:    initTDM
-- PURPOSE:     Create team deathmatch objective
-- INPUT:		params = {
--					teamATT, teamDEF,
--					textATT, textDEF,
--					pointsPerKillATT, pointsPerKillDEF,
--					goalWeightATT, goalWeightDEF,
--					multiplayerRules = boolean,
--					delayStart = boolean
--				}
-- OUTPUT:		ObjectiveTDM
-- NOTES:       To prevent the objective from automatically starting, set 
--				`delayStart` to true.
---------------------------------------------------------------------------
function objective_tdm_helper:initTDM(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")

	-- check if objective module is loaded
	assert(ObjectiveTDM, "ObjectiveTDM has not been loaded!")

	-- objective text params
	local textATT_ = params.textATT or constants.getTextATT("tdm")
	local textDEF_ = params.textDEF or constants.getTextDEF("tdm")
	
	-- points per kill params
	local ppkATT = params.ppkATT or PPK_ATT
	local ppkDEF = params.ppkDEF or PPK_DEF
	
	-- goal weight
	local goalWeightATT = params.goalWeightATT or GOAL_WEIGHT_ATT
	local goalWeightDEF = params.goalWeightDEF or GOAL_WEIGHT_DEF
	
	-- multiplayer rules params
	local multiplayerRules_ = params.multiplayerRules or MULTIPLAYER_RULES
	assert(type(multiplayerRules_) == "boolean", "ERROR: Expected boolean got, " .. type(multiplayerRules_))
	
	-- create objective
	self.objective= ObjectiveTDM:New{
		teamATT = TeamConfig:getTeamNumbers().teamATT, teamDEF = TeamConfig:getTeamNumbers().teamDEF,
		pointsPerKillATT = ppkATT, pointsPerKillDEF = ppkDEF,
		textATT = textATT_, textDEF = textDEF_,
		multiplayerRules = multiplayerRules_
	}
	print("Created: ObjectiveTDM")

	-- set AI goal
	self.objective.OnStart = function(self)
    	AddAIGoal(TeamConfig:getTeamNumbers().teamATT, "Deathmatch", goalWeightATT)
    	AddAIGoal(TeamConfig:getTeamNumbers().teamDEF, "Deathmatch", goalWeightDEF)
    end
	
	-- auto start objective
	objectiveHelper.startObjective(self.objective, params.delayStart)
	
	self.initialized = true
	return self.objective
end


-- import function
function get_objective_tdm_helper()
	return objective_tdm_helper
end
