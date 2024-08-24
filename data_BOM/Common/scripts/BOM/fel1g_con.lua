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
		redOmniLights = 48,
		
		-- sounds 
		soundStream = 1,
		music = 39,
		
		-- units
		wookiees = MAX_SPECIAL + 4,
		
		-- vehicles
		hovers = 2,
		onePair = 2,
		
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
	
    ReadDataFile("sound\\fel.lvl;fel1gcw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_chewbacca"
	
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
				 "imp_walk_atst")
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "imp", teamNameDEF = "all",
		teamATTConfigID = "basic_atst", teamDEFConfigID = "basic_jungle",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("fel\\fel1.lvl", "fel1_conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 55,
		
		-- birdies and fishies
		minFlockHeight = 50,
		numBirdTypes = 1,
		numFishTypes = 1,
		
	-- ai properties
		-- view distance
		viewMultiplier = 0.65	
	}

    
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\fel.lvl", "fel1")
    OpenAudioStream("sound\\fel.lvl", "fel1")

    -- music
    SetAmbientMusic(ALL, 1.0, "all_fel_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_fel_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_fel_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_fel_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_fel_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_fel_amb_end", 2,1)
	
	-- game over song
    SetVictoryMusic(ALL, "all_fel_amb_victory")
    SetDefeatMusic (ALL, "all_fel_amb_defeat")
    SetVictoryMusic(IMP, "imp_fel_amb_victory")
    SetDefeatMusic (IMP, "imp_fel_amb_defeat")


    ------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

    -- create and start objective	
	objConquest:initConquest{
		cps = {"cp1-1", "cp2-1", "cp3-1", "cp4-1", "cp5-1", "cp6-1"}
	}
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
    EnableSPHeroRules()
end
