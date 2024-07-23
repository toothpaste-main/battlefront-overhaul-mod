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
local objHunt  = import("objective_hunt_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")

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
		-- map
		obstacles = 768,
		redOmniLights = 32,
		treeGridStack = 768,
	
		-- sounds
		soundStream = 4,
		soundSpace = 2,
		
		-- units
		totalUnits = END1_MAX_EWK_UNITS + END1_MAX_IMP_UNITS,
		
		-- vehicles
		turrets = 3,
		
		-- weapons
		mines = 0,
		portableTurrets = SNIPER_TURRETS * END1_MAX_IMP_UNITS,
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
	
	ReadDataFile("sound\\end.lvl;end1gcw")


	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- ewoks
	ReadDataFile("SIDE\\ewk.lvl",
				 "ewk_inf_basic")
	
	
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------
	
	-- empire
	ReadDataFile("dc:SIDE\\imp.lvl",
				 IMP_SNIPER_CLASS)


	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- empire
	SetTeamName(IMP, "Empire")
	SetTeamIcon(IMP, "imp_icon")
	SetUnitCount(IMP, END1_MAX_IMP_UNITS)
	SetReinforcementCount(IMP, -1)
	AddUnitClass(IMP, IMP_SNIPER_CLASS)
	
	-- ewoks
	SetTeamName(ALL, "Ewoks")
	SetTeamIcon(ALL, "all_icon")
	SetUnitCount(ALL, END1_MAX_EWK_UNITS)
	SetReinforcementCount(ALL, -1)
	AddUnitClass(ALL, EWK_SOLDIER_CLASS)
	
	-- relations broke down with the locals
	SetTeamAsEnemy(ALL, IMP)
	SetTeamAsEnemy(IMP, ALL)
	
	TeamConfig:init{
		teamNameATT = "imp", teamNameDEF = "all",
	}
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("end\\end1.lvl", "end1_hunt")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 45,
		
		-- birdies and fishies
		minFlockHeight = -1,
		numBirdTypes = 1,
		
		-- misc
		worldExtents = 1277.3,
		
	-- ai properties
		-- view distance
		denseEnvironment = true,	
	}
	

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\end.lvl", "end1gcw")
	OpenAudioStream("sound\\end.lvl", "end1gcw")
	OpenAudioStream("sound\\end.lvl", "end1gcw_emt")

	-- music
	SetAmbientMusic(ALL, 1.0, "all_end_amb_hunt", 0, 1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_hunt", 0, 1)

	-- game over song
	SetVictoryMusic(ALL, "all_end_amb_victory")
	SetDefeatMusic(ALL, "all_end_amb_defeat")
	SetVictoryMusic(IMP, "imp_end_amb_victory")
	SetDefeatMusic(IMP, "imp_end_amb_defeat")

	
	------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------
	
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()	

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
	
	
	------------------------------------------------
	------------   UNIT PROPERTIES  ----------------
	------------------------------------------------
	
	-- make ewoks one-shot to pistols
	SetClassProperty(EWK_SOLDIER_CLASS, "MaxHealth", EWK_HEALTH)
	
	-- This is code for cycling rifleman models
	-- Author: KinetosImpetus
	-- Edited: ToothpasteMain

	-- constants
	local INTERVAL = 3--AI_WAVE_SPAWN_DELAY
	local MAX_SKIN = 2
	
	-- create timer
	skintimer = CreateTimer("timeout")
	SetTimerValue(skintimer , INTERVAL)
	
	-- cycler
	local skin = 0
	OnTimerElapse(
		function(timer)
			-- asign skin
			if skin == 0 then
				SetClassProperty(EWK_SOLDIER_CLASS, "GeometryName", "ewk_inf")
				SetClassProperty(EWK_SOLDIER_CLASS, "SkeletonName", "ewok")
			elseif skin == 1 then
				SetClassProperty(EWK_SOLDIER_CLASS, "GeometryName", "ewk_inf2")
				SetClassProperty(EWK_SOLDIER_CLASS, "SkeletonName", "ewok")
			end
			
			-- cycle skin
			skin = skin + 1
			if skin >= MAX_SKIN then
				skin = 0
			end
			
			-- reset timer
			SetTimerValue(skintimer , INTERVAL)
			StartTimer(skintimer)
		end,
		skintimer
	)

	-- start timer for first time
	StartTimer(skintimer)


	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	-- create and start objective
	objHunt:initHunt{
		pointsPerKillATT = END1_PPK_ATT, pointsPerKillDEF = END1_PPK_DEF,
		textATT = TEXT_ATT_END1
	}
end
