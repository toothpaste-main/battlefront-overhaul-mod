--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objHunt = import("objective_hunt_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomgcw_all_snow_pilot") 

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
		-- jedi
		jedi = HOT_MAX_WAM_UNITS,
	
		-- map
		lights = 256,
		redOmniLights = 256,
		
		-- sounds
		soundStream = 5,
		soundSpace = 11,
		
		-- units
		totalUnits = HOT_MAX_ALL_UNITS + HOT_MAX_WAM_UNITS,
		totalAIVehicles = 10,
		cloths = HOT_MAX_ALL_UNITS,
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 44,		
		
		-- weapons
		mines = ASSAULT_MINES * MAX_ASSAULT,
		portableTurrets = SNIPER_TURRETS * MAX_SNIPER,
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
	
    -- wampas
    ReadDataFile("SIDE\\snw.lvl",
                 WAM_SOLDIER_CLASS)
    
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_hoth_dishturret",
				 "tur_bldg_hoth_lasermortar",
				 "tur_bldg_chaingun_tripod",
				 "tur_bldg_chaingun_roof")


	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------

	ReadDataFile("dc:SIDE\\all.lvl",
				 ALL_SOLDIER_CLASS,
				 ALL_ASSAULT_CLASS,
				 ALL_SNIPER_CLASS,
				 ALL_ENGINEER_CLASS,
				 ALL_OFFICER_CLASS,
				 ALL_SPECIAL_CLASS)
				 

	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    SetupTeams{
		-- alliance
        all = {
            team = ALL,
            units = HOT_MAX_ALL_UNITS,
            reinforcements = -1,
            soldier		= {ALL_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault		= {ALL_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
            sniper		= {ALL_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
			engineer	= {ALL_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer		= {ALL_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special		= {ALL_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        },
        -- wampas
        wampa={
            team = IMP,
            units = HOT_MAX_WAM_UNITS,
            reinforcements = -1,
            soldier 	= {WAM_SOLDIER_CLASS, HOT_MAX_WAM_UNITS},
        }
    }
	
	-- localize wampas
	SetTeamName(IMP, "Wampas")
	
	-- WAMPA SMASH
	SetTeamAsEnemy(ALL, IMP)
	SetTeamAsEnemy(IMP, ALL) 

	TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "all",
	}
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("HOT\\hot1.lvl", "hoth_hunt")
	
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
	SetAmbientMusic(ALL, 1.0, "all_hot_amb_hunt", 0, 1)
	SetAmbientMusic(IMP, 1.0, "imp_hot_amb_hunt", 0, 1)

	-- game over song
	SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")
	

    ------------------------------------------------
	------------   CAMERA SHOTS   ------------------
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
	
	-- create and start objective
	objHunt:initHunt{
		pointsPerKillATT = HOT1_PPK_ATT, pointsPerKillDEF = HOT1_PPK_DEF
	}
end
 