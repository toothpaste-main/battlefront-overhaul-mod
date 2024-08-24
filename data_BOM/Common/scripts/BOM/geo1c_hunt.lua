--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")

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
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF

-- ambient teams
local REP_AMBIENT = 6
local REP_AMBIENT_UNITS = 3
local CIS_AMBIENT = 7
local CIS_AMBIENT_UNITS = 6


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
		redOmniLights = 64,
		
		-- sounds
		soundStream = 4,
		music = 34,
		soundSpace = 8,
		
		-- units
		totalUnits = (2 * MAX_UNITS) + REP_AMBIENT_UNITS + CIS_AMBIENT_UNITS,
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		turrets = 6,
		twoPair = 1, -- for acklay
		
		-- weapons
		portableTurrets = SNIPER_TURRETS * MAX_SNIPER,
	}
	
	SetMemoryPoolSize("AcklayData", 1)	
	
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

	ReadDataFile("sound\\geo.lvl;geo1cw")
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_fly_assault_dome",
				 "rep_fly_gunship_dome",
				 "rep_fly_jedifighter_dome")
                             
    -- geonosians
    ReadDataFile("SIDE\\geo.lvl",
                 "gen_inf_geonosian")
	
	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
                 "tur_bldg_geoturret")                             

	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------
	
	-- republic
	ReadDataFile("dc:SIDE\\rep.lvl",
				 "rep_inf_ep2_sniper")


	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
	-- republic
	SetTeamName(REP, "rep")
	SetTeamIcon(REP, "rep_icon")
	SetUnitCount(REP, MAX_UNITS)
	AddUnitClass(REP, "rep_inf_ep2_sniper")
	
	-- geonosians
	SetTeamName(CIS, "geo")
	SetTeamIcon(CIS, "cis_icon")
	SetUnitCount(CIS, MAX_UNITS)
	AddUnitClass(CIS, "geo_inf_geonosian")
	
	TeamConfig:init{
		teamNameATT = "rep", teamNameDEF = "geo",
	}

	-- republic ambient team	
	SetTeamName(REP_AMBIENT, "rep")
    SetUnitCount(REP_AMBIENT, REP_AMBIENT_UNITS)
    AddUnitClass(REP_AMBIENT, "rep_inf_ep2_sniper")
	
	-- cis ambient team
	SetTeamName(CIS_AMBIENT, "geo")
    SetUnitCount(CIS_AMBIENT, CIS_AMBIENT_UNITS)
	AddUnitClass(CIS_AMBIENT, "geo_inf_geonosian")

	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
    ReadDataFile("GEO\\geo1.lvl", "geo1_hunt")
    
    -- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 50,
		mapFloor = -65,
	}

	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\geo.lvl", "geo1cw")
    OpenAudioStream("sound\\geo.lvl", "geo1cw")

	-- music
	SetAmbientMusic(REP, 1.0, "rep_geo_amb_hunt",  0,1)
    SetAmbientMusic(CIS, 1.0, "cis_geo_amb_hunt",  0,1)

	-- game over song
    SetVictoryMusic(REP, "rep_geo_amb_victory")
    SetDefeatMusic (REP, "rep_geo_amb_defeat")
    SetVictoryMusic(CIS, "cis_geo_amb_victory")
    SetDefeatMusic (CIS, "cis_geo_amb_defeat")


    ------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------
	
    -- mountain
    AddCameraShot(0.996091, 0.085528, -0.022005, 0.001889, -6.942698, -59.197201, 26.136919)
    
	-- wrecked Ship
    AddCameraShot(0.906778, 0.081875, -0.411906, 0.037192, 26.373968, -59.937874, 122.553581)
    
	-- war Room  
    AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
	
	
	------------------------------------------------
	------------   AMBIENT TEAMS   -----------------
	------------------------------------------------
	
	-- set AI goal
	AddAIGoal(REP_AMBIENT, "Deathmatch", 100)
	AddAIGoal(CIS_AMBIENT, "Deathmatch", 100)
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create and start objective
	objHunt:initHunt{
		pointsPerKillATT = 1, pointsPerKillDEF = 2,
		textATT = "level.geo1.objectives.hunt_att", textDEF = "level.geo1.objectives.hunt_def",
		multiplayerRules = true
	}	
end
