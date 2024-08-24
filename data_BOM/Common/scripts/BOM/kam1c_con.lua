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
		obstacles = 1024,
		lights = 96,
		redOmniLights = 96,
		
		-- sounds
		soundStatic = 80, 
		soundStream = 3,
		soundSpace = 36,
		
		-- units
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		turrets = 21,
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

    ReadDataFile("sound\\kam.lvl;kam1cw")
	

	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_obiwan"
	
	-- cis
	local CIS_HERO = "cis_hero_jangofett"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",                            
				 REP_HERO)
				 
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO)
		
	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_weap_built_gunturret")
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "rep",
		teamATTConfigID = "basic", teamDEFConfigID = "basic_shiny",
	}
    
	-- heroes
    SetHeroClass(REP, REP_HERO)
	SetHeroClass(CIS, CIS_HERO)


	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("KAM\\kam1.lvl", "kamino1_conquest")

	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 100,
		mapFloor = 60,	
	}


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\kam.lvl", "kam1")
    OpenAudioStream("sound\\kam.lvl", "kam1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_kam_amb_start", 0,1)
    SetAmbientMusic(REP, 0.8, "rep_kam_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_kam_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kam_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.8, "cis_kam_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_kam_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_kam_amb_victory")
    SetDefeatMusic (REP, "rep_kam_amb_defeat")
    SetVictoryMusic(CIS, "cis_kam_amb_victory")
    SetDefeatMusic (CIS, "cis_kam_amb_defeat")

    
	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

	AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922)
	AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774)
	AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919)
	AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421)
	AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089)
	AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552)

end


function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
	
	-- remove AI barriers	
	DisableBarriers("frog")
	DisableBarriers("close")
	DisableBarriers("camp")
    DisableBarriers("open")
	DisableBarriers("FRONTDOOR2-3")
    DisableBarriers("FRONTDOOR2-1")  
    DisableBarriers("FRONTDOOR2-2")
	DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")  
    DisableBarriers("FRONTDOOR1-2")	
	
	
	------------------------------------------------
	------------   RESET CAMPAIGN RESTRICTIONS   ---
	------------------------------------------------

	SetAIDamageThreshold("Comp1", 0 )
    SetAIDamageThreshold("Comp2", 0 )
    SetAIDamageThreshold("Comp3", 0 )
    SetAIDamageThreshold("Comp4", 0 )
    SetAIDamageThreshold("Comp5", 0 )
  	SetAIDamageThreshold("Comp6", 0 )
    SetAIDamageThreshold("Comp7", 0 )
    SetAIDamageThreshold("Comp8", 0 )
    SetAIDamageThreshold("Comp9", 0 )
    SetAIDamageThreshold("Comp10", 0 )

    UnblockPlanningGraphArcs("connection71")

	SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door33", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door34", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door35", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door27", "Islocked", 0)       
    SetProperty("Kam_Bldg_Podroom_Door28", "Islocked", 1)       
    SetProperty("Kam_Bldg_Podroom_Door36", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door20", "Islocked", 0)
    
	UnblockPlanningGraphArcs("connection71")
        
   --Objective1
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
        
    --blocking Locked Doors
    UnblockPlanningGraphArcs("connection194")
    UnblockPlanningGraphArcs("connection200")
    UnblockPlanningGraphArcs("connection118")
   
    --Lower cloning facility
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
	
	BlockPlanningGraphArcs("group1");
	BlockPlanningGraphArcs("connection165")
    BlockPlanningGraphArcs("connection162")
    BlockPlanningGraphArcs("connection160")
    BlockPlanningGraphArcs("connection225")
    
    
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- reassign command posts to teams
	SetProperty("cp1", "Team", "1")
    SetProperty("cp2", "Team", "2")
    SetProperty("cp3", "Team", "2")
    SetProperty("cp4", "Team", "2")
    SetProperty("cp5", "Team", "1")
    SetProperty("cp6", "Team", "1")
	
	-- assign CP spawnpaths
	SetProperty("cp2", "spawnpath", "cp2_spawn")
    SetProperty("cp2", "captureregion", "cp2_capture")
	   
    -- create and start objective	
	objConquest:initConquest{
		cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}
	}
 
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
    EnableSPHeroRules()
end
