--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objCTF  = import("objective_ctf_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomcw_ep2") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF

-- geonosians
local GEO = 5
local GEO_UNITS = 3

-- ambient teams
local REP_AMBIENT = 6
local REP_AMBIENT_UNITS = 0
local CIS_AMBIENT = 7
local CIS_AMBIENT_UNITS = 0


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
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		hovers = 3,
		turrets = 6,
		droidekas = MAX_SPECIAL,
		twoPair = 2,
		
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

    ReadDataFile("sound\\geo.lvl;geo1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------

	-- republic
	local REP_HERO = "rep_hero_macewindu"
	
	-- cis
	local CIS_HERO = "cis_hero_countdooku"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_fly_assault_dome",
				 "rep_fly_gunship_dome",
				 "rep_fly_jedifighter_dome",
				 "rep_hover_fightertank")
	
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO,
				 "cis_fly_droidfighter_dome",
				 "cis_tread_hailfire",
				 "cis_walk_spider")

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
				 REP_SOLDIER_CLASS,
				 REP_ASSAULT_CLASS,
				 REP_SNIPER_CLASS, 
				 REP_ENGINEER_CLASS,
				 REP_OFFICER_CLASS,
				 REP_SPECIAL_CLASS)

    -- cis
	ReadDataFile("dc:SIDE\\cis.lvl",
				 CIS_SOLDIER_CLASS,
				 CIS_ASSAULT_CLASS,
				 CIS_SNIPER_CLASS,
				 CIS_ENGINEER_CLASS,
				 CIS_OFFICER_CLASS,
				 CIS_SPECIAL_CLASS)
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    SetupTeams{
		-- republic
        rep = {
            team = REP,
            units = MAX_UNITS,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier		= {REP_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault		= {REP_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
			sniper		= {REP_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
            engineer	= {REP_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer		= {REP_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special		= {REP_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        },
		-- cis
        cis = {
            team = CIS,
            units = MAX_UNITS,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier		= {CIS_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault		= {CIS_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
			sniper		= {CIS_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
            engineer	= {CIS_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer		= {CIS_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special		= {CIS_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        }
    }
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)
	
	TeamConfig:init{
		teamNameATT = "rep", teamNameDEF = "cis",
	}
	
	-- setup geonosians
	SetTeamName(GEO, "locals")
    SetUnitCount(GEO, GEO_UNITS)
    AddUnitClass(GEO, "geo_inf_geonosian")    
    SetTeamAsFriend(GEO, DEF)
	
	-- republic ambient team	
	SetTeamName(REP_AMBIENT, "rep")
    SetUnitCount(REP_AMBIENT, REP_AMBIENT_UNITS)
    AddUnitClass(REP_AMBIENT, REP_SOLDIER_CLASS)
	AddUnitClass(REP_AMBIENT, REP_OFFICER_CLASS, 0, 1)
	
	-- cis ambient team
	SetTeamName(CIS_AMBIENT, "cis")
    SetUnitCount(CIS_AMBIENT, CIS_AMBIENT_UNITS)
    AddUnitClass(CIS_AMBIENT, CIS_SOLDIER_CLASS)
	AddUnitClass(CIS_AMBIENT, CIS_OFFICER_CLASS, 0 , 1)
	AddUnitClass(CIS_AMBIENT, "geo_inf_geonosian", 0, 1)	

	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
    ReadDataFile("GEO\\geo1.lvl", "geo1_ctf")

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
    SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_GEO_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_GEO_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_GEO_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_GEO_amb_end", 2,1)

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

	-- vehicle properties
	SetProperty("cis_ambient_veh", "MaxHealth", 1e+37)
	SetProperty("cis_ambient_veh", "CurHealth", 1e+37)
	SetProperty("cis_ambient_veh", "Team", CIS_AMBIENT) -- so only CIS use it (in case AI gets out and Clone takes over)
	SetProperty("cis_ambient_veh", "IsVisible", 0)
	
	-- set AI goal
	AddAIGoal(REP_AMBIENT, "Deathmatch", 100)
	AddAIGoal(CIS_AMBIENT, "Deathmatch", 100)
	

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

	-- set AI goal
	AddAIGoal(GEO, "Deathmatch", 100)
	
	
    ------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
    
    EnableSPHeroRules()   
end
