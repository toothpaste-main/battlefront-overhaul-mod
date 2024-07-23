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
local objConquest  = import("objective_conquest_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomgcw_all_jungle")
ScriptCB_DoFile("bomgcw_imp") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- alliance Attacking (attacker is always #1)
local ALL = ATT
local IMP = DEF

-- wookiees
local WOK = 3
local WOK_UNITS = 5


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
		redOmniLights = 32,
		
		-- sounds
		soundStatic = 80, 
		soundStream = 3,
		soundSpace = 4,
		
		-- units
		wookiees = MAX_SPECIAL + WOK_UNITS,
		
		-- vehicles
		hovers = 11,
		turrets = 13,
		
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
	
    ReadDataFile("sound\\kas.lvl;kas2gcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_chewbacca"
	
	-- empire
	local IMP_HERO = "imp_hero_bobafett"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
    -- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO,
				 "all_hover_combatspeeder")
				 
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 "imp_hover_fightertank",
				 "imp_hover_speederbike")
	
	-- wookies
    ReadDataFile("SIDE\\wok.lvl",
				 "wok_inf_basic")	

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_beam",
				 "tur_bldg_recoilless_kas")

    
    ------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------

	-- alliance
	ReadDataFile("dc:SIDE\\all.lvl",
				 ALL_SOLDIER_CLASS,
				 ALL_ASSAULT_CLASS,
				 ALL_SNIPER_CLASS,
				 ALL_ENGINEER_CLASS,
				 ALL_OFFICER_CLASS,
				 ALL_SPECIAL_CLASS)
				 
	-- empire
	ReadDataFile("dc:SIDE\\imp.lvl",
				 IMP_SOLDIER_CLASS,
				 IMP_SNIPER_CLASS,
				 IMP_ASSAULT_CLASS,
				 IMP_ENGINEER_CLASS,
				 IMP_OFFICER_CLASS,
				 IMP_SPECIAL_CLASS)
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    SetupTeams{
		-- alliance
		all = {
            team = ALL,
            units = MAX_UNITS,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier		= {ALL_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault		= {ALL_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
            sniper		= {ALL_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
			engineer	= {ALL_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer		= {ALL_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special		= {ALL_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        },
		-- empire
        imp = {
            team = IMP,
            units = MAX_UNITS,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier  	= {IMP_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault  	= {IMP_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
            sniper   	= {IMP_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
			engineer 	= {IMP_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer 	= {IMP_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special 	= {IMP_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        }
    }
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
	}
	
	-- setup wookies
	SetTeamName(WOK, "locals")
	SetUnitCount(WOK, WOK_UNITS)
    AddUnitClass(WOK, "wok_inf_warrior",2)
    AddUnitClass(WOK, "wok_inf_rocketeer",2)
    AddUnitClass(WOK, "wok_inf_mechanic",1)
	
	-- establish good relations with the wookies
	SetTeamAsFriend(ATT,WOK)
    SetTeamAsFriend(WOK,ATT)
    SetTeamAsEnemy(DEF,WOK)
    SetTeamAsEnemy(WOK,DEF)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("KAS\\kas2.lvl", "kas2_con")
    
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 70,
		
		-- birdies and fishies
		numBirdTypes = 1,
		numFishTypes = 1,
	}

	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\kas.lvl", "kas")
    OpenAudioStream("sound\\kas.lvl", "kas")

    -- music
    SetAmbientMusic(ALL, 1.0, "all_kas_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_kas_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2,"all_kas_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_kas_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_kas_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2,"imp_kas_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(ALL, "all_kas_amb_victory")
    SetDefeatMusic (ALL, "all_kas_amb_defeat")
    SetVictoryMusic(IMP, "imp_kas_amb_victory")
    SetDefeatMusic (IMP, "imp_kas_amb_defeat")


	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

	AddCameraShot(0.977642, -0.052163, -0.203414, -0.010853, 66.539520, 21.864969, 168.598495)
	AddCameraShot(0.969455, -0.011915, 0.244960, 0.003011, 219.552948, 21.864969, 177.675674)
	AddCameraShot(0.995040, -0.013447, 0.098558, 0.001332, 133.571289, 16.216759, 121.571236)
	AddCameraShot(0.350433, -0.049725, -0.925991, -0.131394, 30.085188, 32.105236, -105.325264)
    AddCameraShot(0.163369, -0.029669, -0.970249, -0.176203, 85.474831, 47.313362, -156.345627)
	AddCameraShot(0.091112, -0.011521, -0.987907, -0.124920, 97.554062, 53.690968, -179.347076)
	AddCameraShot(0.964953, -0.059962, 0.254988, 0.015845, 246.471008, 20.362143, 153.701050)
end

-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
	
	-- remove AI barriers	
	DisableBarriers("disableme")
	
	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
    
    -- gate
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    
    -- set wall max health
    SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("gatepanel", "MaxHealth", 1000)
    
	-- set wall health
	SetProperty("woodl", "CurHealth", 15000)
	SetProperty("woodr", "CurHealth", 15000)
	SetProperty("woodc", "CurHealth", 15000)
	SetProperty("gatepanel", "CurHealth", 1000)
    
	-- events for wall destruction and repair
	OnObjectKillName(PlayAnimDown, "gatepanel")
	OnObjectRespawnName(PlayAnimUp, "gatepanel")
	OnObjectKillName(woodl, "woodl")
	OnObjectKillName(woodc, "woodc")
	OnObjectKillName(woodr, "woodr")
	OnObjectRespawnName(woodlr, "woodl")
	OnObjectRespawnName(woodcr, "woodc")
	OnObjectRespawnName(woodrr, "woodr")
 

    ------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
    
	-- create and start objective	
	objConquest:initConquest{
		cps = {"CP1CON", "CP3CON", "CP4CON", "CP5CON"}
	}
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
end
 
function PlayAnimDown()
    PauseAnimation("thegateup");
    RewindAnimation("thegatedown");
    PlayAnimation("thegatedown");
    ShowMessageText("level.kas2.objectives.gateopen",1)
    ScriptCB_SndPlaySound("KAS_obj_13")
    SetProperty("gatepanel", "MaxHealth", 2200)      
    
    -- Allowing AI to run under gate   
    UnblockPlanningGraphArcs("seawall1");
    DisableBarriers("seawalldoor1");
    DisableBarriers("vehicleblocker");
      
end

function PlayAnimUp()
    PauseAnimation("thegatedown");
    RewindAnimation("thegateup");
    PlayAnimation("thegateup");
            
    -- Disallow AI to run under gate   
    BlockPlanningGraphArcs("seawall1");
    EnableBarriers("seawalldoor1");
    EnableBarriers("vehicleblocker");
    SetProperty("gatepanel", "MaxHealth", 1000)
    SetProperty("gatepanel", "CurHealth", 1000)
      
end

function woodl()
    UnblockPlanningGraphArcs("woodl");
    DisableBarriers("woodl");
    SetProperty("woodl", "MaxHealth", 1800)
--    SetProperty("woodl", "CurHealth", 15)
end
    
function woodc()
    UnblockPlanningGraphArcs("woodc");
    DisableBarriers("woodc");
    SetProperty("woodc", "MaxHealth", 1800)
--    SetProperty("woodc", "CurHealth", 15)
end
    
function woodr()
    UnblockPlanningGraphArcs("woodr");
    DisableBarriers("woodr");
    SetProperty("woodr", "MaxHealth", 1800)
--    SetProperty("woodr", "CurHealth", 15)
end

function woodlr()
	BlockPlanningGraphArcs("woodl")
	EnableBarriers("woodl")
	SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodl", "CurHealth", 15000)
end
	
function woodcr()
	BlockPlanningGraphArcs("woodc")
	EnableBarriers("woodc")
	SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("woodc", "CurHealth", 15000)
end

function woodrr()
	BlockPlanningGraphArcs("woodr")
	EnableBarriers("woodr")
	SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodr", "CurHealth", 15000)
end
