--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objConquest = import("objective_conquest_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")

-- these variables do not change
local ATT = 1
local DEF = 2
-- alliance attacking (attacker is always #1)
local ALL = ATT
local IMP = DEF
 
 
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
		hints = 1280,
		obstacles = 768,
		redOmniLights = 64,
	
		-- sounds
		soundStream = 3,
		soundSpace = 1,
		
		-- units
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		hovers = 4,
		
		-- weapons
		mines = 2 * ASSAULT_MINES * MAX_ASSAULT,
		portableTurrets = 2 * SNIPER_TURRETS * MAX_SNIPER,
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
	ReadDataFile("dc:sound\\bom.lvl;bomgcw")
    
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

	ReadDataFile("sound\\uta.lvl;uta1gcw")
	

	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_hansolo_tat"
	
	-- empire
	local IMP_HERO = "imp_hero_bobafett"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO,
				 "all_hover_combatspeeder")
                
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 "imp_fly_destroyer_dome",
				 "imp_hover_fightertank")
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
		teamATTConfigID = "basic_urban", teamDEFConfigID = "basic",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("uta\\uta1.lvl", "uta1_Conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 30,	
	}
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\uta.lvl", "uta1")
	OpenAudioStream("sound\\uta.lvl", "uta1")

	-- music
	SetAmbientMusic(ALL, 1.0, "all_uta_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.8, "all_uta_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_uta_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_uta_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.8, "imp_uta_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_uta_amb_end", 2,1)

	-- game over song
	SetVictoryMusic(ALL, "all_uta_amb_victory")
	SetDefeatMusic (ALL, "all_uta_amb_defeat")
	SetVictoryMusic(IMP, "imp_uta_amb_victory")
	SetDefeatMusic (IMP, "imp_uta_amb_defeat")


	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

	AddCameraShot(-0.428091, 0.045649, -0.897494, -0.095703, 162.714951, 45.857063, 40.647118)
	AddCameraShot(-0.194861, -0.001600, -0.980796, 0.008055, -126.179787, 16.113789, 70.012894)
	AddCameraShot(-0.462548, -0.020922, -0.885442, 0.040050, -16.947638, 4.561796, 156.926956)
	AddCameraShot(0.995310, 0.024582, -0.093535, 0.002310, 38.288612, 4.561796, 243.298508)
	AddCameraShot(0.827070, 0.017093, 0.561719, -0.011609, -24.457638, 8.834146, 296.544586)
	AddCameraShot(0.998875, 0.004912, -0.047174, 0.000232, -45.868237, 2.978215, 216.217880)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

    ------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------

	-- death regions
	AddDeathRegion("deathregion")

	-- remove AI barriers	
	DisableBarriers("Barrier445")
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	-- create and start objective	
	objConquest:initConquest{
		cps = {"CON_CP1", "con_CP1a", "CON_CP2", "CON_CP5", "CON_CP6", "CON_CP7"}
	}
    
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
end
