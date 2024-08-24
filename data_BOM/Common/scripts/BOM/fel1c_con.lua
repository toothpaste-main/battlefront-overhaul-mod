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
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF
    

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
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		hovers = 2,
		droidekas = MAX_SPECIAL,
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
	ReadDataFile("dc:sound\\bom.lvl;bomcw")
    
  
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------
	
    ReadDataFile("sound\\fel.lvl;fel1cw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_aalya"
	
	-- cis
	local CIS_HERO = "cis_hero_jangofett"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_walk_oneman_atst")
		
	-- cis
    ReadDataFile("SIDE\\cis.lvl",                          
				 CIS_HERO,
				 "cis_tread_snailtank")
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	TeamConfig:init{
		teamNameATT = "rep", teamNameDEF = "cis",
		teamATTConfigID = "basic_jungle", teamDEFConfigID = "basic",
	}
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)


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
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\fel.lvl", "fel1")
    OpenAudioStream("sound\\fel.lvl", "fel1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_fel_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_fel_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_fel_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_fel_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_fel_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_fel_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_fel_amb_victory")
    SetDefeatMusic (REP, "rep_fel_amb_defeat")
    SetVictoryMusic(CIS, "cis_fel_amb_victory")
    SetDefeatMusic (CIS, "cis_fel_amb_defeat")


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
