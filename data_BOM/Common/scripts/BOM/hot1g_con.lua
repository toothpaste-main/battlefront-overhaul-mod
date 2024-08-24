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
		lights = 96,
		redOmniLights = 128,
		
		-- sounds
		soundStream = 5,
		soundSpace = 11,
		
		-- units
		cloths = MAX_UNITS,
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		flyers = 8,
		turrets = 28,
		onePair = 3,
		twoPair = 2,
		commandWalkers = 2,
		
		-- weapons
		mines = 2 * ASSAULT_MINES * MAX_ASSAULT,
		portableTurrets = 2 * SNIPER_TURRETS * MAX_SNIPER,
		towCables = 4,
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

	ReadDataFile("sound\\hot.lvl;hot1gcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	local ALL_HERO = "all_hero_luke_pilot"
	
	-- empire
	local IMP_HERO = "imp_hero_darthvader"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
    -- rebels
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO,
				 "all_fly_snowspeeder",
				 "all_walk_tauntaun")
				 
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 "imp_walk_atat",
				 "imp_walk_atst")
    
    -- turrets                             
    ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_hoth_dishturret",
				 "tur_bldg_hoth_lasermortar")
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "imp", teamNameDEF = "all",
		teamATTConfigID = "basic_atat_snow", teamDEFConfigID = "basic_snow_pilot",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("HOT\\hot1.lvl", "hoth_conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 150,
		
		-- misc
		groundFlyerMap = true,	
	}
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")

	-- music
    SetAmbientMusic(ALL, 1.0, "all_hot_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_hot_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_hot_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_hot_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_hot_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")


	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS  ------------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("Death")
	AddDeathRegion("fall")
	
	-- remove AI barriers
	DisableBarriers("atat")
	DisableBarriers("bombbar")


	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
    
	-- create and start objective	
	objConquest:initConquest{
		cps = {"CP3", "CP4", "CP5", "CP6", "CP7"}
	}
    
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	-- will not work without this (part C)
    SetObjectTeam("CP3", IMP)
    SetObjectTeam("CP6", IMP)
    KillObject("CP7")

	EnableSPHeroRules()
end
