--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
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
		hints = 1280,
		obstacles = 1024,
		redOmniLights = 32,
		
		-- sounds
		soundStatic = 37, 
		soundStream = 1,
		soundSpace = 13,
		
		-- units
		cloths = MAX_UNITS,
		
		-- vehicles
		hovers = 4,
		turrets = 9,
		droidekas = MAX_SPECIAL,
		
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

	ReadDataFile("sound\\myg.lvl;myg1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_kiyadimundi"
	
	-- cis
	local CIS_HERO = "cis_hero_grievous"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- republic
	ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_fly_gunship_dome",
				 "rep_hover_fightertank")
	
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO,
				 "cis_hover_aat",
				 "cis_fly_gunship_dome")
    
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_recoilless_lg")

 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	TeamConfig:init{
		teamNameATT = "rep", teamNameDEF = "cis",
		teamATTConfigID = "marine", teamDEFConfigID = "basic",
	}
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("myg\\myg1.lvl", "myg1_ctf")
	
	-- set mission properties
	missionProperties:init{
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\myg.lvl", "myg1")
    OpenAudioStream("sound\\myg.lvl", "myg1")
	
	-- music
    SetAmbientMusic(REP, 1.0, "rep_myg_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_myg_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_myg_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_myg_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_myg_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")


	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090)
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359)
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212)
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887)
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128)
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712)
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
 
	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
 
	-- remove AI barriers
	DisableBarriers("coresh1")
	DisableBarriers("corebar1")
	DisableBarriers("corebar2")
	DisableBarriers("corebar3")
	DisableBarriers("corebar4")
	DisableBarriers("coresh1")
	DisableBarriers("dropship")
	DisableBarriers("shield_01")
	DisableBarriers("shield_02")
	DisableBarriers("shield_03")
	

    ------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	-- create and start objective	
	objCTF:initCTF{
		teamNameATT = "rep", teamNameDEF = "cis",
		flagNameATT = "flag1", flagNameDEF = "flag2",
		homeRegionATT = "flag1_home", homeRegionDEF = "flag2_home",
		captureRegionATT = "flag2_home", captureRegionDEF = "flag1_home",
	}
    
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
    EnableSPHeroRules()
end
