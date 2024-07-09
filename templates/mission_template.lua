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
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
	--SetUberMode(0) -- 0 or 1
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
	local NUM_AIMER = 96		-- it's easier this way
	local NUM_CLOTH = 0	
	local NUM_FLAGS = 0
	local NUM_FLYER = 6
	local NUM_HINTS = 1024
	local NUM_HOVER = 0
	local NUM_JEDI = 2
	local NUM_MINE = 24			-- 4 mines * 8 rocketeers
	local NUM_TENT = 0
	local NUM_TUR = 0
	local NUM_UNITS = 96		-- it's easier this way
	local NUM_WEAPONS = 256		-- more if locals and vehicles!
	local WALKER0 = 0
	local WALKER1 = 0
	local WALKER2 = 0
	local WALKER3 = 0
	
	-- walkers
	ClearWalkers()
	AddWalkerType(0, WALKER0)	-- droidekas (special case: 0 leg pairs)
	AddWalkerType(1, WALKER1)	-- 1x2 (1 pair of legs)
	AddWalkerType(2, WALKER2)	-- 2x2 (2 pairs of legs)
	AddWalkerType(3, WALKER3)	-- 3x2 (3 pairs of legs)
	
	-- memory pool
    SetMemoryPoolSize("Aimer", NUM_AIMER)
    SetMemoryPoolSize("AmmoCounter", NUM_WEAPONS)
	SetMemoryPoolSize("BaseHint", NUM_HINTS)					-- number of hint nodes
	SetMemoryPoolSize("CommandFlyer", 0)						-- number of gunships
	SetMemoryPoolSize("CommandWalker", 0)						-- number of ATTEs or ATATs
    SetMemoryPoolSize("EnergyBar", NUM_WEAPONS)
    SetMemoryPoolSize("EntityCloth", NUM_CLOTH)					-- 1 per clone marine
	SetMemoryPoolSize("EntityFlyer", NUM_FLYER)					-- to account for rocket upgrade (incrase for ATST)
    SetMemoryPoolSize("EntityHover", NUM_HOVER)					-- hover tanks/speeders
    --SetMemoryPoolSize("EntityLight", 128)						-- for dark maps
	SetMemoryPoolSize("EntityMine", NUM_MINE)							
    --SetMemoryPoolSize("EntitySoundStream", 0)
    --SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("FlagItem", NUM_FLAGS)					-- ctf
    SetMemoryPoolSize("MountedTurret", 0)
    --SetMemoryPoolSize("Music", 32)							-- applicable to campaigns
    SetMemoryPoolSize("Navigator", NUM_UNITS)
    SetMemoryPoolSize("Obstacle", 1024)
    SetMemoryPoolSize("PathFollower", NUM_UNITS)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 512)
    --SetMemoryPoolSize("SoundSpaceRegion", 0)					-- for maps using lots of sound spaces
    SetMemoryPoolSize("TentacleSimulator", NUM_TENT)			-- 4 per wookiee
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
	
	-- local
    
	-- turrets
    
    
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------
	
	-- republic/rebels
	
	-- cis/empire
    
    
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	
	-- heroes
	--SetHeroClass(TEAM_NUM, HERO)
    
	-- setup locals
	
	-- establish good relations with the locals
	
    
    ------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 32
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 0		-- -1 dragons, 1 to 2 birds
	local NUM_FISH_TYPES = 0		-- 0-1
	
	
	-- load gamemode
	
	
	-- flight properties
	SetGroundFlyerMap(0)					-- if flyers (i.e. Hoth)
	SetMaxFlyHeight(MAP_CEILING_AI)			-- AI
	SetMaxPlayerFlyHeight(MAP_CEILING)		-- player
	SetMinFlyHeight(MAP_FLOOR_AI)			-- AI
	--SetMinPlayerFlyHeight(MAP_FLOOR)		-- player
	
	-- birdies
	--SetBirdFlockMinHeight(MIN_FLOCK_HEIGHT)
    SetNumBirdTypes(NUM_BIRD_TYPES)
	if NUM_BIRD_TYPES < 0 then SetBirdType(0.0,10.0,"dragon") end
	if NUM_BIRD_TYPES >= 1 then SetBirdType(0,1.0,"bird") end
	if NUM_BIRD_TYPES >= 2 then SetBirdType(1,1.5,"bird2") end
	
    

    -- fishies
    SetNumFishTypes(NUM_FISH_TYPES)
    if NUM_FISH_TYPES >= 1 then SetFishType(0,0.8,"fish") end
	
	-- misc
	--SetMapNorthAngle(0.0)
	--SetWorldExtents(0.0)
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- constants
	local VIEW_MULTIPLIER = -1	-- -1 for default
	local DENSE_ENV = "False"
	local SNIPE_DIST = 196
	local URBAN_ENV = "False"
	
	-- difficulty
	--DisableAIAutoBalance()
	--SetPlayerTeamDifficulty(DIFF_PLAYER)	-- 1 (dumbest) and 20 (smartest)
	--SetEnemyTeamDifficulty(DIFF_ENEMY) 	-- 1 (dumbest) and 20 (smartest)
	
	-- behavior
	--SetTeamAggressiveness(TEAM_NUM, 1.0) -- 0 to 1
	
	-- spawn delay
	SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
	--SetSpawnDelayTeam(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED, TEAM_NUM)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment(DENSE_ENV)
	if VIEW_MULTIPLIER > 0 then SetAIViewMultiplier(VIEW_MULTIPLIER) end
	
	-- sniping distance
	AISnipeSuitabilityDist(SNIPE_DIST)
	--SetAttackerSnipeRange(196)
	--SetDefenderSnipeRange(196)
	
	-- urban environtment
	-- IF TRUE: AI vehicles strafe less
	-- IF FALSE: AI vehicles strafe
	SetUrbanEnvironment(URBAN_ENV)
	
	-- misc
	--SetAllowBlindJetJumps(0) 		-- 0 or 1
	--SetAttackingTeam(ATT)
	--SetStayInTurrets(0) 			-- 0 or 1


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
	
	--AddCameraShot(0, 0, 0, 0, 0, 0, 0,)
end
