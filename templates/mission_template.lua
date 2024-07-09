--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- This is the Campaign Script for JEDI TEMPLE: KNIGHTFALL, map name COR1C_C (Designer: P. Baker)

-- load the gametype script
ScriptCB_DoFile("")  

-- load BOM constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("") 
 
-- these variables do not change
ATT = 1
DEF = 2
-- REP attacking (attacker is always #1)
REP = ATT
CIS = DEF


function ScriptPostLoad ()
	
	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	
	-- remove AI barriers
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	
	------------------------------------------------
	------------   MOVIES  -------------------------
	------------------------------------------------
	
	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- define CPs / define flag geometry
	
	-- create objective
	
	-- add CPs/flags objectives
	
	-- start objective
	
	EnableSPHeroRules()
end


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
	
	-- constants
	local NUM_JEDI = 2
	local NUM_UNITS = 64
	local NUM_WEAPONS = 4*NUM_UNITS
	
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", NUM_WEAPONS)
	SetMemoryPoolSize("BaseHint", 1024)							-- number of hint nodes
    SetMemoryPoolSize("EnergyBar", NUM_WEAPONS)
    SetMemoryPoolSize("EntityCloth", 0)							-- 1 per clone marine
	SetMemoryPoolSize("EntityFlyer", 6) 						-- to account for rocket upgrade (incrase for ATST)
    SetMemoryPoolSize("EntityHover", 0)							-- hover tanks/speeders
    --SetMemoryPoolSize("EntityLight", 128)						-- for dark maps
	SetMemoryPoolSize("EntityMine", 24)							-- 4 mines * 8 rocketeers
    SetMemoryPoolSize("EntitySoundStream", 2)
    SetMemoryPoolSize("EntitySoundStatic", 1)
    SetMemoryPoolSize("FlagItem", 0)
    SetMemoryPoolSize("MountedTurret", 0)
    --SetMemoryPoolSize("Music", 32)							-- applicable to campaigns
    SetMemoryPoolSize("Navigator", NUM_UNITS)
    SetMemoryPoolSize("Obstacle", 1024)
    SetMemoryPoolSize("PathFollower", NUM_UNITS)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 512)
    --SetMemoryPoolSize("SoundSpaceRegion", 0)					-- for maps using lots of sound spaces
    SetMemoryPoolSize("TentacleSimulator", 0)					-- 4 per wookiee
    SetMemoryPoolSize("TreeGridStack", 256)
	SetMemoryPoolSize("UnitAgent", NUM_UNITS)
	SetMemoryPoolSize("UnitController", NUM_UNITS)
    SetMemoryPoolSize("Weapon", NUM_WEAPONS)
	
	
	-- jedi
	SetMemoryPoolSize("Combo", 2*NUM_JEDI)						-- should be ~ 2x number of jedi classes
    SetMemoryPoolSize("Combo::State", 12*2*NUM_JEDI)			-- should be ~12x #Combo
    SetMemoryPoolSize("Combo::Transition", 12*2*NUM_JEDI)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Condition", 12*2*NUM_JEDI)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Attack", 12*12*2*NUM_JEDI)		-- should be ~8-12x #Combo
    SetMemoryPoolSize("Combo::DamageSample", 12*12*2*NUM_JEDI)	-- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize("Combo::Deflect", 2*NUM_JEDI) 			-- should be ~1x #combo
	
	
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
	ReadDataFile("dc:sound\\bom.lvl;bomERA") ------- need to define era! ----------------------------------------------
    
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------
	

	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = ""
	
	-- cis
	local CIS_HERO = ""
		
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
	
	-- cis
	
	-- wookies
    
	-- turrets
    
    
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------
	
	-- republic
	
	-- cis
    
    
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	
	-- heroes
	--SetHeroClass(TEAM, HERO)
    
	-- setup wookies
	
	-- establish good relations with the wookies
	
	-- walkers
	Clear Walkers()
	AddWalkerType(0, 0)				-- droidekas (special case: 0 leg pairs)
	AddWalkerType(1, 0)				-- 1x2 (1 pair of legs)
	AddWalkerType(2, 0)				-- 2x2 (2 pairs of legs)
	AddWalkerType(3, 0)				-- 3x2 (3 pairs of legs)
    
    ------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAX_FLY_HEIGHT = 20
	local MIN_FLY_HEIGHT = 0
	local NUM_BIRD_TYPES = 0		-- 0-2
	local NUM_FISH_TYPES = 0		-- 0-1
	
	
	-- load gamemode
	ReadDataFile("cor\\cor1.lvl","cor1_campaign")
	
	-- flight properties
	SetGroundFlyerMap(0)					-- if flyers (i.e. Hoth)
	SetMaxFlyHeight(MAX_FLY_HEIGHT)			-- AI
	SetMaxPlayerFlyHeight(MAX_FLY_HEIGHT)	-- player
	SetMinFlyHeight(MIN_FLY_HEIGHT)			-- AI
	
	-- birdies
    SetNumBirdTypes(NUM_BIRD_TYPES)
	if NUM_BIRD_TYPES >= 1 then SetBirdType(0,1.0,"bird") end
	if NUM_BIRD_TYPES >= 2 then SetBirdType(1,1.5,"bird2") end

    -- fishies
    SetNumFishTypes(NUM_FISH_TYPES)
    if NUM_FISH_TYPES >= 1 then SetFishType(0,0.8,"fish") end
	
	-- misc
	--SetMapNorthAngle(0)
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- constants
	local AI_VIEW_MULT = -1			-- -1 for default
	local DENSE_ENV = "False"
	local SNIPE_DIST = 196
	local URBAN_ENV = "False"
	
	-- spawn delay
	SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
	--SetSpawnDelayTeam(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED, TEAM_NUMBER)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment(DENSE_ENV)
	if AI_VIEW_MULT > 0 then SetAIViewMultiplier(AI_VIEW_MULT) end
	
	-- sniping distance
	AISnipeSuitabilityDist(SNIPE_DIST)
	--SetDefenderSnipeRange(196)
	
	-- urban environtment
	-- IF TRUE: AI vehicles strafe less
	-- IF FALSE: AI vehicles strafe
	SetUrbanEnvironment(URBAN_ENV)
	
	-- misc
	--SetAllowBlindJetJumps(0)


	------------------------------------------------
	------------   LEVEL ANNOUNCER   ---------------
	------------------------------------------------

	-- announcer slow
    
	-- announcer quick
    
	-- winning/losing announcement
	
	-- low reinforcement warning

   	-- out of bounds warnin


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams

	-- music

	-- game over song

	-- misc sounds effects
	if NUM_BIRD_TYPE >= 1 then SetSoundEffect("BirdScatter", "birdsFlySeq1") end
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
	SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    ------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------
	
	-- AddCameraShot(0, 0, 0, 0, 0, 0, 0,)
end
