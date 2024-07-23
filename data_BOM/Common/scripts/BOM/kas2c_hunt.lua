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
local objHunt  = import("objective_hunt_helper")

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
		redOmniLights = 32,
		
		-- sounds
		soundStatic = 80, 
		soundStream = 3,
		soundSpace = 4,
		
		-- units
		totalUnits = KAS2_MAX_WOK_UNITS + KAS2_MAX_CIS_UNITS,
		wookiees = KAS2_MAX_WOK_UNITS,
		
		-- vehicles
		turrets = 13,
		
		-- weapons
		mines = 0,
		portableTurrets = 0,
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

    ReadDataFile("sound\\kas.lvl;kas2cw")
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_fly_cat_dome")
		
	-- cis
	ReadDataFile("SIDE\\cis.lvl",
				 "cis_fly_gunship_dome")
    
	-- wookiees
	ReadDataFile("SIDE\\wok.lvl",
				 "wok_inf_basic")
		
	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_beam",
				 "tur_bldg_recoilless_kas")
	
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------    

	-- cis
	ReadDataFile("dc:SIDE\\cis.lvl",
				 CIS_OFFICER_CLASS)
    
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- wookiees
	SetTeamName(REP, "Wookiees")
	--SetTeamIcon(REP, "rep_icon")
	SetUnitCount(REP, KAS2_MAX_WOK_UNITS)
	SetReinforcementCount(REP, -1)
	AddUnitClass(REP, WOK_SOLDIER_CLASS)

	-- cis
	SetTeamName(CIS, "CIS")
	--SetTeamIcon(CIS, "cis_icon")
	SetUnitCount(CIS, KAS2_MAX_WOK_UNITS)
	SetReinforcementCount(CIS, -1)
	AddUnitClass(CIS, CIS_OFFICER_CLASS)
	
	-- relations broke down with the locals
	SetTeamAsEnemy(REP, CIS)
	SetTeamAsEnemy(CIS, REP)
    
	TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "rep",
	}
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("KAS\\kas2.lvl", "kas2_hunt")
    
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

	-- game over song
    SetVictoryMusic(REP, "rep_kas_amb_victory")
    SetDefeatMusic (REP, "rep_kas_amb_defeat")
    SetVictoryMusic(CIS, "cis_kas_amb_victory")
    SetDefeatMusic (CIS, "cis_kas_amb_defeat")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_kas_amb_hunt", 0,1)
    SetAmbientMusic(CIS, 1.0, "cis_kas_amb_hunt", 0,1)
	
	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\kas.lvl", "kas")
    OpenAudioStream("sound\\kas.lvl", "kas")


	------------------------------------------------
	------------   CAMERA SHOTS   ------------------
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
	objHunt:initHunt{
		pointsPerKillATT = objHunt.END1_PPK_ATT, pointsPerKillDEF = objHunt.END1_PPK_DEF,
		textATT = objHunt.TEXT_ATT_KAS2, textDEF = objHunt.TEXT_DEF_KAS2
	}
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
