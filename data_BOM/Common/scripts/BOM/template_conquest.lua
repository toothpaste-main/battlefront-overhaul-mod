--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain
-- Version: v1.0
--
-- This is an example template for the conquest game mode using the 
-- bom_conquest.lau script
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")

-- load BOM assets
ScriptCB_DoFile("bom_conquest")


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
 
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create and start objective	
	createConquestObjective{cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}}
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   DELAYED START   -----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
 
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create objective	
	conquest = createConquestObjective{cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}, 
									   delayedStart = true}
	
	-- start objective
	conquest:Start()
end
