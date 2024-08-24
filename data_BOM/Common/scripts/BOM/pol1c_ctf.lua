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
		asteroids = 100,
		redOmniLights = 32,
		
		-- sounds
		soundStream = 25,
		soundSpace = 33,
		
		-- units
		cloths = MAX_UNITS,
		
		-- vehicles
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
    
    ReadDataFile("sound\\pol.lvl;pol1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------

	-- republic
	local REP_HERO = "rep_hero_yoda"
	
	-- cis
	local CIS_HERO = "cis_hero_darthmaul"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
	
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO)      
 
 
    ------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "rep",
		teamATTConfigID = "basic", teamDEFConfigID = "marine_pilot",
	}
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("pol\\pol1.lvl","pol1_ctf")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 55,
		
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}

	-- asteroids
	SetParticleLODBias(3000)
	SetMaxCollisionDistance(1500)


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- ambience
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\pol.lvl", "pol1")
    OpenAudioStream("sound\\pol.lvl", "pol1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_pol_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_pol_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_pol_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_pol_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_pol_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_pol_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_pol_amb_victory")
    SetDefeatMusic (REP, "rep_pol_amb_defeat")
    SetVictoryMusic(CIS, "cis_pol_amb_victory")
    SetDefeatMusic (CIS, "cis_pol_amb_defeat")


    ------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------
    
    AddCameraShot(0.461189, -0.077838, -0.871555, -0.147098, 85.974007, 30.694353, -66.900795)
    AddCameraShot(0.994946, -0.100380, -0.002298, -0.000232, 109.076401, 27.636383, -10.235785)
    AddCameraShot(0.760383, 0.046402, 0.646612, -0.039459, 111.261696, 27.636383, 46.468048)
    AddCameraShot(-0.254949, 0.066384, -0.933546, -0.243078, 73.647552, 32.764030, 50.283028)
    AddCameraShot(-0.331901, 0.016248, -0.942046, -0.046116, 111.003563, 28.975283, 7.051458)
    AddCameraShot(0.295452, -0.038140, -0.946740, -0.122217, 19.856682, 36.399086, -9.890361)
    AddCameraShot(0.958050, -0.115837, -0.260254, -0.031467, -35.103737, 37.551651, 109.466576)
    AddCameraShot(-0.372488, 0.036892, -0.922789, -0.091394, -77.487892, 37.551651, 40.861832)
    AddCameraShot(0.717144, -0.084845, -0.686950, -0.081273, -106.047691, 36.238495, 60.770439)
    AddCameraShot(0.452958, -0.104748, -0.862592, -0.199478, -110.553474, 40.972584, 37.320778)
    AddCameraShot(-0.009244, 0.001619, -0.984956, -0.172550, -57.010258, 30.395561, 5.638251)
    AddCameraShot(0.426958, -0.040550, -0.899315, -0.085412, -87.005966, 30.395561, 19.625088)
    AddCameraShot(0.153632, -0.041448, -0.953179, -0.257156, -111.955055, 36.058708, -23.915501)
    AddCameraShot(0.272751, -0.002055, -0.962055, -0.007247, -117.452736, 17.298250, -58.572723)
    AddCameraShot(0.537097, -0.057966, -0.836668, -0.090297, -126.746666, 30.472836, -148.353333)
    AddCameraShot(-0.442188, 0.081142, -0.878575, -0.161220, -85.660973, 29.013374, -144.102219)
    AddCameraShot(-0.065409, 0.011040, -0.983883, -0.166056, -84.789032, 29.013374, -139.568787)
    AddCameraShot(0.430906, -0.034723, -0.898815, -0.072428, -98.038002, 47.662624, -128.643265)
    AddCameraShot(-0.401462, 0.047050, -0.908449, -0.106466, 77.586563, 47.662624, -147.517365)
    AddCameraShot(-0.269503, 0.031284, -0.956071, -0.110983, 111.260330, 16.927542, -114.045715)
    AddCameraShot(-0.338119, 0.041636, -0.933134, -0.114906, 134.970169, 26.441256, -82.282082)
end


 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion1")
	
	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------
  
	OnObjectRespawnName(PlayAnimLock01Open, "LockCon01")
    OnObjectKillName(PlayAnimLock01Close, "LockCon01")
	
	-- remove tanks (not currently working)
	SetProperty("com_item_vehicle_spawn", "SpawnCount", 0)
	SetProperty("com_item_vehicle_spawn1", "SpawnCount", 0)
	SetProperty("com_item_vehicle_spawn2", "SpawnCount", 0)


	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	-- create and start objective	
	objCTF:initCTF{
		teamNameATT = "cis", teamNameDEF = "rep",
		flagNameATT = "flag1", flagNameDEF = "flag2",
		homeRegionATT = "Team1FlagCapture", homeRegionDEF = "Team2FlagCapture",
		captureRegionATT = "Team2FlagCapture", captureRegionDEF = "Team1FlagCapture",
	}

	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()    
end
