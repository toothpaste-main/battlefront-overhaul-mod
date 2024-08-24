--[[
	Battlefront Mission Helper
	Module name: objective_helper
	Description: 
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-20
	Dependencies:
	Notes:
--]]
local objective_helper = {
	name = "objective_helper",
	version = 1.0,
}


---------------------------------------------------------------------------
-- FUNCTION:    startObjective
-- PURPOSE:     Starts an objective or postpone to another time
-- INPUT:		objective, delayStart, objectiveName
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function objective_helper.startObjective(objective, delayStart)
	-- must be given an objective
	assert(objective, "ERROR: Expected objective, got nil")

	-- auto start objective
	delayStart = delayStart or false
	assert(type(delayStart) == "boolean", "ERROR: Expected boolean got, " .. type(delayStart))
	if not delayStart then
		print("Starting objective...")
		objective:Start()
	else
		print("Postponing objective...")
	end
end


-- import function
function get_objective_helper()
	return objective_helper
end
