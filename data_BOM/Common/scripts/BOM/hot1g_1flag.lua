--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objCTF = import("objective_ctf_helper")

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
		lights = 256,
		redOmniLights = 256,
		
		-- sounds
		soundStream = 5,
		soundSpace = 11,
		
		-- units
		totalAIVehicles = 10,
		cloths = MAX_UNITS,
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 44,		
		
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

    ReadDataFile("sound\\hot.lvl;hot1gcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_luke_pilot"
	
	-- empire
	local IMP_HERO = "imp_hero_darthvader"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO)
				
	-- empire
    ReadDataFile("SIDE\\imp.lvl",
                 IMP_HERO)
	
	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_hoth_dishturret",
				 "tur_bldg_hoth_lasermortar",
				 "tur_bldg_chaingun_tripod",
				 "tur_bldg_chaingun_roof")

	
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
	ReadDataFile("HOT\\hot1.lvl", "hoth_ctf")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 150,
	}
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")

	-- music
    SetAmbientMusic(ALL, 1.0, "all_hot_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.5, "all_hot_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.25, "all_hot_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.5, "imp_hot_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.25, "imp_hot_amb_end", 2,1)

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
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("Death")
	AddDeathRegion("fall")
	
	-- remove AI barriers
	DisableBarriers("conquestbar")
	DisableBarriers("bombbar")

	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------

	-- set transport health
	SetProperty("ship", "MaxHealth", 1e+37)
	SetProperty("ship", "CurHealth", 1e+37)
	SetProperty("ship2", "MaxHealth", 1e+37)
	SetProperty("ship2", "CurHealth", 1e+37)
	SetProperty("ship3", "MaxHealth", 1e+37)
	SetProperty("ship3", "CurHealth", 1e+37)
	
	-- remove unused CPs
	KillObject("CP7OBJ")
	KillObject("shieldgen")
	KillObject("CP7OBJ")
	KillObject("hangarcp")
	KillObject("enemyspawn")
	KillObject("enemyspawn2")
	KillObject("echoback2")
	KillObject("echoback1")
	KillObject("shield")	


	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------       
	
	-- create objective		   
	objCTF:initOneFlag{
		teamNameATT = "imp", teamNameDEF = "all",
		flagName = "flag", homeRegion = "HomeRegion",
		captureRegionATT = "Team2Capture", captureRegionDEF = "Team1Capture"
	}
    
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
end
