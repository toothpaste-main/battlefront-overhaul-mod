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
-- cis attacking (attacker is always #1)
local REP = DEF
local CIS = ATT

-- jawas
local JAW = 3
local JAW_UNITS = 6


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
	-- Digners, these two lines *MUST* be first.--
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
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		turrets = 18,
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
	

    ReadDataFile("sound\\tat.lvl;tat2cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	local REP_HERO = "rep_hero_obiwan"
	
	-- empire
	local CIS_HERO = "cis_hero_darthmaul"
	
    
	-----------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
	ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
	
	-- cis
	ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO)
	
	-- jawas
    ReadDataFile("SIDE\\des.lvl",
                 "tat_inf_jawa")

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_tat_barge",	
				 "tur_bldg_laser")	
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "rep",
		teamATTConfigID = "basic", teamDEFConfigID = "basic",
	}
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)

	-- setup jawas
	SetTeamName(JAW, "Jawas")
	SetUnitCount(JAW, JAW_UNITS)
	AddUnitClass(JAW, "tat_inf_jawa", JAW_UNITS)
	
	-- jawa revenge!
	AddAIGoal(JAW, "deathmatch", 1000)
	SetTeamAsEnemy(JAW, ATT)
	SetTeamAsEnemy(JAW, DEF) 
	SetTeamAsEnemy(ATT, JAW)
	SetTeamAsEnemy(DEF, JAW)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("TAT\\tat2.lvl", "tat2_ctf")
	
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
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\tat.lvl", "tat2")
    OpenAudioStream("sound\\tat.lvl", "tat2")

    -- music
    SetAmbientMusic(REP, 1.0, "rep_tat_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_tat_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_tat_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tat_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_tat_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_tat_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_tat_amb_victory")
    SetDefeatMusic (REP, "rep_tat_amb_defeat")
    SetVictoryMusic(CIS, "cis_tat_amb_victory")
    SetDefeatMusic (CIS, "cis_tat_amb_defeat")


    ------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------
	
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681)
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561)
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613)
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477)
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234)
end


--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------
	
	-- hide CPs
	KillObject("CP1")
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	KillObject("CP7")
	KillObject("CP8")
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	-- create and start objective	
	objCTF:initCTF{
		teamNameATT = "cis", teamNameDEF = "rep",
		flagNameATT = "ctf_flag1", flagNameDEF = "ctf_flag2",
		homeRegionATT = "flag1_home", homeRegionDEF = "flag2_home",
		captureRegionATT = "flag2_home", captureRegionDEF = "flag1_home",
	}
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
end
