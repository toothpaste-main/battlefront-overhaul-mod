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
-- alliance attacking (attacker is always #1)
local ALL = ATT
local IMP = DEF


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
		redOmniLights = 64,
		
		-- sounds
		soundStatic = 116, 
		soundStream = 2,
		soundSpace = 13,
		
		-- units
		wookiees = MAX_SPECIAL,
		
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
    
	ReadDataFile("sound\\mus.lvl;mus1gcw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	local ALL_HERO = "rep_hero_obiwan"
	
	-- empire
	local IMP_HERO = "rep_hero_anakin"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_hero_obiwan",
				 "rep_hero_anakin")
				 
	
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
		teamATTConfigID = "basic_urban", teamDEFConfigID = "basic",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("mus\\mus1.lvl", "mus1_conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 90,
		
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}
	

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\mus.lvl", "mus1")
	OpenAudioStream("sound\\mus.lvl", "mus1")

	-- music
	SetAmbientMusic(ALL, 1.0, "all_mus_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.8, "all_mus_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_mus_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_mus_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.8, "imp_mus_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_mus_amb_end", 2,1)

	-- game over song
	SetVictoryMusic(ALL, "all_mus_amb_victory")
	SetDefeatMusic (ALL, "all_mus_amb_defeat")
	SetVictoryMusic(IMP, "imp_mus_amb_victory")
	SetDefeatMusic (IMP, "imp_mus_amb_defeat")

	
	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

	AddCameraShot(0.446393, -0.064402, -0.883371, -0.127445, -93.406929, 72.953865, -35.479401)
	AddCameraShot(-0.297655, 0.057972, -0.935337, -0.182169, -2.384067, 71.165306, 18.453350)
	AddCameraShot(0.972488, -0.098362, 0.210097, 0.021250, -42.577881, 69.453072, 4.454691)
	AddCameraShot(0.951592, -0.190766, -0.236300, -0.047371, -44.607018, 77.906273, 113.228661)
	AddCameraShot(0.841151, -0.105984, 0.526154, 0.066295, 109.567764, 77.906273, 7.873035)
	AddCameraShot(0.818472, -0.025863, 0.573678, 0.018127, 125.781593, 61.423031, 9.809184)
	AddCameraShot(-0.104764, 0.000163, -0.994496, -0.001550, -13.319855, 70.673264, 63.436607)
	AddCameraShot(0.971739, 0.102058, 0.211692, -0.022233, -5.680069, 68.543945, 57.904160)
	AddCameraShot(0.178437, 0.004624, -0.983610, 0.025488, -66.947433, 68.543945, 6.745875)
    AddCameraShot(-0.400665, 0.076364, -0896894, -0.170941, 96.201210, 79.913033, -58.604382)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- remove AI barriers	
	DisableBarriers("1")
	DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------
	
	UnblockPlanningGraphArcs("Connection74")	-- idk what this does
	
	-- raise bridges
    PlayAnimRise()

	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
	
	-- bridge work
	OnObjectRespawnName(PlayAnimRise, "DingDong")
    OnObjectKillName(PlayAnimDrop, "DingDong")
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
    
	-- create and start objective	
	objConquest:initConquest{
		cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}
	}
 
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
 
	EnableSPHeroRules()
end
 --START BRIDGEWORK!

-- OPEN
function PlayAnimDrop()
	PauseAnimation("lava_bridge_raise");    
	RewindAnimation("lava_bridge_drop");
	PlayAnimation("lava_bridge_drop");
        
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection82");
    BlockPlanningGraphArcs("Connection83");
    EnableBarriers("Bridge");
    
end
-- CLOSE
function PlayAnimRise()
	PauseAnimation("lava_bridge_drop");
	RewindAnimation("lava_bridge_raise");
	PlayAnimation("lava_bridge_raise");     

	-- allow the AI to run across it
	UnblockPlanningGraphArcs("Connection82");
	UnblockPlanningGraphArcs("Connection83");
	DisableBarriers("Bridge");

end
