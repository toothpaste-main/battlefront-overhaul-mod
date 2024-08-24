--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objHunt = import("objective_hunt_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")

-- these variables do not change
local ATT = 1
local DEF = 2
-- empire attacking (attacker is always #1)
local ALL = DEF
local IMP = ATT


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

    ------------------------------------------------
	-- Designers, these two lines *MUST* be first.--
	------------------------------------------------

	-- allocate PS2 memory
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
	SetPS2ModelMemory(PS2_MEMORY)

    ReadDataFile("ingame.lvl")
	
	
	------------------------------------------------
	------------   MEMORY POOL   -------------------
	------------------------------------------------
	--
	-- This happens first and foremost to avoid
	-- crashes when loading.
	--
	
	memorypool:init{
		-- map
		hints = 512,
		obstacles = 768,
		redOmniLights = 32,
		
		-- sounds 
		soundStream = 2,
		soundSpace = 1,
		
		-- units
		totalUnits = TAT2_MAX_JAW_UNITS + TAT2_MAX_TUS_UNITS,
		
		-- weapons
		mines = 0,
		portableTurrets = 0,
	}

	
	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	--
	-- This happens first to avoid conflicts with 
	-- vanilla sounds.
	--
	
	-- global
	ReadDataFile("dc:sound\\bom.lvl;bom_cmn")

	-- era
	ReadDataFile("dc:sound\\bom.lvl;bom_hunt")
	

	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

	ReadDataFile("sound\\tat.lvl;tat2gcw")
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- jawas
    ReadDataFile("SIDE\\des.lvl",
                 JAW_SOLDIER_CLASS)
	
	-- tuskens
	ReadDataFile("SIDE\\des.lvl",						 
				 TUS_SOLDIER_CLASS,
                 TUS_SNIPER_CLASS)

    
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
	-- setup jawas
	SetTeamName (ALL, "Jawas")
	SetUnitCount (ALL, TAT2_MAX_JAW_UNITS)
	SetReinforcementCount(ALL, -1)
    AddUnitClass (ALL, JAW_SOLDIER_CLASS)

	-- setup tuskens
	SetTeamName (IMP, "Tuskens")
	SetUnitCount (IMP, TAT2_MAX_TUS_UNITS)
	SetReinforcementCount(IMP, -1)
    AddUnitClass (IMP, TUS_SOLDIER_CLASS)
    AddUnitClass (IMP, TUS_SNIPER_CLASS)
	
	-- establish turf war
	SetTeamAsEnemy(ALL, IMP)
	SetTeamAsEnemy(IMP, ALL) 
	
	TeamConfig:init{
		teamNameATT = "imp", teamNameDEF = "all",
	}
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("TAT\\tat2.lvl", "tat2_hunt")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 40,	
	}


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\tat.lvl", "tat2")
    OpenAudioStream("sound\\tat.lvl", "tat2")

	-- music
    SetAmbientMusic(ALL, 1.0, "all_tat_amb_hunt", 0,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_hunt", 0,1)

	-- game over song
    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")


	------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------

	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681)
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561)
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613)
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477)
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234)
end

function ScriptPostLoad()

	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create and start objective
	objHunt:initHunt{
		pointsPerKillATT = objHunt.TAT2_PPK_ATT, pointsPerKillDEF = objHunt.TAT2_PPK_DEF
	}
end
