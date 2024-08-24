--[[
	Battlefront Mission Helper
	Module name: objective_conquest_helper
	Description: Helper module for conquest set up
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-21
	Dependencies: constants, objective_helper
	Notes: All parameters are assumed to be strings unless stated 
		   otherwise.
--]]
local objective_conquest_helper = {
	name = "objective_conquest_helper",
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

local MULTIPLAYER_RULES = true


---------------------------------------------------------------------------
-- FUNCTION:    addCPs
-- PURPOSE:     Add CPs to conquest objective
-- INPUT:		conquestt, cps = {"cp1", "cp2", ...}
-- OUTPUT:
-- NOTES:		The value of `cps` are command post names.
---------------------------------------------------------------------------
function objective_conquest_helper:addCPs(cps)
	-- check if cps is a table
	assert(type(cps) == "table", "Expected table, got " .. type(cps))

	-- error message if there are too many cps
	local err = "Too many command posts! Expected " .. constants.getMaxCommandPosts()
	err = err .. ", got... I only count until there is too many"
	
	local maxCPs = 0
	for numCPs, cp in cps do	
		-- create command post and add to the objective
		self.objective:AddCommandPost(CommandPost:New{name = cp})
				
		-- check if too many command posts
		assert(numCPs <= constants.getMaxCommandPosts(), err)
		maxCPs = numCPs
	end
	print(maxCPs .. " command posts added to the objective")
end


---------------------------------------------------------------------------
-- FUNCTION:    init
-- PURPOSE:     Create conquest objective with given command posts
-- INPUT:		params = {
--					teamATT, teamDEF,
--					textATT, textDEF,
--					cps = {"cp1", "cp2", ...},
--					multiplayerRules = boolean,
--					delayStart = boolean,
--				}
-- OUTPUT:		ObjectiveConquest
-- NOTES:       To prevent the objective from automatically starting, set 
--				`delayStart` to true.
---------------------------------------------------------------------------
function objective_conquest_helper:initConquest(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " already initialized!")

	-- check if objective module is loaded
	assert(ObjectiveConquest, "ObjectiveConquest has not been loaded!")

	-- objective text params
	textATT_ = params.textATT or constants.getTextATT("conquest")
	textDEF_ = params.textDEF or constants.getTextDEF("conquest")

	-- multiplayer rules params
	local multiplayerRules_ = params.multiplayerRules or MULTIPLAYER_RULES
	assert(type(multiplayerRules_) == "boolean", "ERROR: Expected boolean got, " .. type(multiplayerRules_))
	
	if not params.text then
		-- create objective
		self.objective = ObjectiveConquest:New{
			teamATT = TeamConfig:getTeamNumbers().teamATT, teamDEF = TeamConfig:getTeamNumbers().teamDEF,
			textATT = textATT_, textDEF = textDEF_,
			multiplayerRules = multiplayerRules_
		}
	else
		self.objective = ObjectiveConquest:New{
			teamATT = TeamConfig:getTeamNumbers().teamATT, teamDEF = TeamConfig:getTeamNumbers().teamDEF,
			text = params.text,
			multiplayerRules = multiplayerRules_
		}
	end
	print("Created: ObjectiveConquest")

	-- add CPs to the objective
	self:addCPs(params.cps)
	
	-- auto start objective
	objectiveHelper.startObjective(self.objective, params.delayStart)
	
	self.initialized = true
	return self.objective
end


-- import function
function get_objective_conquest_helper()
	return objective_conquest_helper
end
