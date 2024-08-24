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

-- locals
local EWK = 3
local EWK_UNITS = 6


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
		obstacles = 768,
		redOmniLights = 32,
		treeGridStack = 768,
	
		-- sounds
		soundStream = 4,
		soundSpace = 2,
		
		-- units
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		hovers = 9,
		turrets = 3,
		onePair = 3,
		
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
	
	ReadDataFile("sound\\end.lvl;end1gcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_hansolo_tat"
	
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
				 IMP_HERO,
				 "imp_hover_speederbike",
				 "imp_walk_atst_jungle")

	-- ewoks
	ReadDataFile("SIDE\\ewk.lvl",
				 "ewk_inf_basic")

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_laser")	
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
		teamATTConfigID = "basic_jungle", teamDEFConfigID = "basic_atst",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	-- setup ewoks
	SetTeamName(EWK, "locals")
	AddUnitClass(EWK, "ewk_inf_trooper", 3)
	AddUnitClass(EWK, "ewk_inf_repair", 3)
	SetUnitCount(EWK, EWK_UNITS)	
	
	-- establish good relations with the locals
	SetTeamAsFriend(EWK, ATT)
	SetTeamAsEnemy(EWK, DEF)
	SetTeamAsFriend(ATT, EWK)
	SetTeamAsEnemy(DEF, EWK)

	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("end\\end1.lvl", "end1_conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 45,
		
		-- birdies and fishies
		minFlockHeight = -1,
		numBirdTypes = 1,
		
		-- misc
		worldExtents = 1277.3,
		
	-- ai properties
		-- view distance
		denseEnvironment = true,	
	}
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\end.lvl", "end1gcw")
	OpenAudioStream("sound\\end.lvl", "end1gcw")
	OpenAudioStream("sound\\end.lvl", "end1gcw_emt")
	
	-- music
	SetAmbientMusic(ALL, 1.0, "all_end_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.8, "all_end_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_end_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.8, "imp_end_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_end_amb_end", 2,1)
	
	-- game over song
	SetVictoryMusic(ALL, "all_end_amb_victory")
	SetDefeatMusic(ALL, "all_end_amb_defeat")
	SetVictoryMusic(IMP, "imp_end_amb_victory")
	SetDefeatMusic(IMP, "imp_end_amb_defeat")

	
	------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------
	
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)	
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS  ------------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
	

	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create and start objective	
	objConquest:initConquest{
		cps = {"CP1", "CP2", "CP4", "CP5", "CP6", "CP10"}
	}
	
	-- set AI goals
	AddAIGoal(EWK, "deathmatch", 100)


	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------

	EnableSPHeroRules()
end
