--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain
-- Version: v1.0
--
-- This is an example template for the conquest game mode using the 
-- objective_conquest_helper.lau script
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")

-- mission helper
ScriptCB_DoFile("objective_conquest_helper")


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
	-- load gamemode map layer
	ReadDataFile("ABC\\ABC.lvl", "ABC_conquest")
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	-- create and start objective	
	createConquestObjective{cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}}
end
