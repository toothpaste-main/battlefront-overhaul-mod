--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain
-- Version: v1.0
--
-- This is an example template for the 2-flag CTF game mode using the 
-- bom_ctf.lau script
--


-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")

-- load BOM assets
ScriptCB_DoFile("bom_ctf")


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
	-- set memory pool
	local NUM_FLAGS = 2
    SetMemoryPoolSize("FlagItem", NUM_FLAGS)

	-- load gamemode map layer
	ReadDataFile("ABC\\ABC.lvl", "ABC_ctf")
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
 
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- define flag geometry
	setFlagGeometry{repFlagName = "flag1", cisFlagName = "flag2"}

	-- create objective
	ctf = createCTFObjective{repHomeRegion = "flag1Home", repCaptureRegion = "flag2Home",
							 cisHomeRegion = "flag2Home", cisCaptureRegion = "flag1Home"}
				
	-- start objective
    ctf:Start()
end