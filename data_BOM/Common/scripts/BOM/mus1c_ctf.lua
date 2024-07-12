--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

-- load BBP constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bomcw_ep3") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF
 

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
	local NUM_ANIM = 512
	local NUM_CLOTH = 32		-- it's easier this way
	local NUM_CMD_FLY = 0
	local NUM_CMD_WLK = 0
	local NUM_FLAGS = 2
	local NUM_FLYER = 6			-- to account for rocket upgrade
	local NUM_HINTS = 1024
	local NUM_HOVER = 0
	local NUM_JEDI = 2
	local NUM_LGHT = 0
	local NUM_MINE = 2 * ASSAULT_MINES * MAX_ASSAULT
	local NUM_MUSC = 0
	local NUM_OBST = 1024
	local NUM_SND_SPA = 13
	local NUM_SND_STC = 133
	local NUM_SND_STM = 2
	local NUM_TENT = 0
	local NUM_TREE = 256
	local NUM_TUR = 0
	local NUM_TUR_PORT = 2 * SNIPER_TURRETS * MAX_SNIPER
	local NUM_UNITS = 96		-- it's easier this way
	local NUM_WEAP = 256		-- more if locals and vehicles!
	local WALKER0 = MAX_SPECIAL
	local WALKER1 = 0
	local WALKER2 = 0
	local WALKER3 = 0
	
	-- walkers
	ClearWalkers()
	SetMemoryPoolSize("EntityWalker", -NUM_CMD_WLK)
	AddWalkerType(0, WALKER0)	-- droidekas (special case: 0 leg pairs)
	AddWalkerType(1, WALKER1)	-- 1x2 (1 pair of legs)
	AddWalkerType(2, WALKER2)	-- 2x2 (2 pairs of legs)
	AddWalkerType(3, WALKER3)	-- 3x2 (3 pairs of legs)
	
	-- memory pool
    SetMemoryPoolSize("Aimer", NUM_AIMER)
    SetMemoryPoolSize("AmmoCounter", NUM_WEAP)
	SetMemoryPoolSize("BaseHint", NUM_HINTS)					-- number of hint nodes
	SetMemoryPoolSize("CommandFlyer", NUM_CMD_FLY)				-- number of gunships
	SetMemoryPoolSize("CommandWalker", NUM_CMD_WLK)				-- number of ATTEs or ATATs
    SetMemoryPoolSize("EnergyBar", NUM_WEAP)
    SetMemoryPoolSize("EntityCloth", NUM_CLOTH)					-- 1 per clone marine
	SetMemoryPoolSize("EntityDroideka", WALKER0)
	SetMemoryPoolSize("EntityFlyer", NUM_FLYER)					-- to account for rocket upgrade (incrase for ATST)
    SetMemoryPoolSize("EntityHover", NUM_HOVER)					-- hover tanks/speeders
    SetMemoryPoolSize("EntityLight", NUM_LGHT)
	SetMemoryPoolSize("EntityMine", NUM_MINE)
	SetMemoryPoolSize("EntityPortableTurret", NUM_TUR_PORT)
	SetMemoryPoolSize("EntitySoundStatic", NUM_SND_STC)	
    SetMemoryPoolSize("EntitySoundStream", NUM_SND_STM)
    SetMemoryPoolSize("FlagItem", NUM_FLAGS)					-- ctf
    SetMemoryPoolSize("MountedTurret", NUM_TUR)
    SetMemoryPoolSize("Music", NUM_MUSC)						-- applicable to campaigns
    SetMemoryPoolSize("Navigator", NUM_UNITS)
    SetMemoryPoolSize("Obstacle", NUM_OBST)						-- number of AI barriers
    SetMemoryPoolSize("PathFollower", NUM_UNITS)
    SetMemoryPoolSize("PathNode", 256)							-- supposedly hard coded
	SetMemoryPoolSize("SoldierAnimation", NUM_ANIM)
    SetMemoryPoolSize("SoundSpaceRegion", NUM_SND_SPA)
    SetMemoryPoolSize("TentacleSimulator", NUM_TENT)			-- 4 per wookiee
    SetMemoryPoolSize("TreeGridStack", NUM_TREE)				-- related to collisions
	SetMemoryPoolSize("UnitAgent", NUM_UNITS)
	SetMemoryPoolSize("UnitController", NUM_UNITS)
    SetMemoryPoolSize("Weapon", NUM_WEAP)						-- total weapon (units, vehicles, etc.)
	
	-- jedi
	SetMemoryPoolSize("Combo", NUM_JEDI*4)						-- should be ~ 2x number of jedi classes
    SetMemoryPoolSize("Combo::State", NUM_JEDI*4*12)			-- should be ~12x #Combo
    SetMemoryPoolSize("Combo::Transition", NUM_JEDI*4*12*2)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Condition", NUM_JEDI*4*12*2)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Attack", NUM_JEDI*4*12)			-- should be ~8-12x #Combo
    SetMemoryPoolSize("Combo::DamageSample", NUM_JEDI*4*12*12)	-- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize("Combo::Deflect", NUM_JEDI*4) 			-- should be ~1x #comb
	
	
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

    ReadDataFile("sound\\mus.lvl;mus1cw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_obiwan"
	
	-- cis
	local CIS_HERO = "cis_hero_darthmaul"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
	
	-- cis
    ReadDataFile("SIDE\\cis.lvl",     
				 CIS_HERO)

    
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
            reinforcements = -1,
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
            reinforcements = -1,
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


	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 90
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = -1
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("mus\\mus1.lvl", "MUS1_CTF")
	
	-- ceiling and floor limit
	SetMaxFlyHeight(MAP_CEILING_AI)			-- AI
	SetMaxPlayerFlyHeight(MAP_CEILING)		-- player
	SetMinFlyHeight(MAP_FLOOR_AI)			-- AI
	SetMinPlayerFlyHeight(MAP_FLOOR)		-- player
	
	-- birdies
	if MIN_FLOCK_HEIGHT > 0 then SetBirdFlockMinHeight(MIN_FLOCK_HEIGHT) end
    SetNumBirdTypes(NUM_BIRD_TYPES)
	if NUM_BIRD_TYPES < 0 then SetBirdType(0.0, 10.0, "dragon") end
	if NUM_BIRD_TYPES >= 1 then SetBirdType(0, 1.0, "bird") end
	if NUM_BIRD_TYPES >= 2 then SetBirdType(0, 1.5, "bird2") end

    -- fishies
    SetNumFishTypes(NUM_FISH_TYPES)
    if NUM_FISH_TYPES >= 1 then SetFishType(0, 0.8, "fish") end
	
	-- misc
	--SetMapNorthAngle(0)
	--SetWorldExtents(0.0)
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- constants
	local AUTO_BLNC = false		-- redistributes more AI onto losing team
	local BLND_JET = 1			-- allow AI to jet jump outside of hints
	local DENSE_ENV = "false"
	local DIFF_PLAYER = 0		-- default = 0, +/- to change skill of player's team
	local DIFF_ENEMY = 0		-- default = 0, +/- to change skill of enemy's team
	local GRND_FLYER = 0		-- make AI flyers aware of the ground
	local SNIPE_ATT = 196		-- snipe distance from "attack" hints
	local SNIPE_DEF = 196		-- snipe distance from "defend" hints
	local SNIPE_DIST = 128		-- snipe distance when on foot
	local STAY_TUR = 0			-- force AI to stay in turrets
	local URBAN_ENV = "false"
	local VIEW_MULTIPLIER = -1	-- -1 for default
	
	-- difficulty
	if AUTO_BLNC then EnableAIAutoBalance() end 
	SetAIDifficulty(DIFF_PLAYER, DIFF_ENEMY)
	
	-- behavior
	--SetTeamAggressiveness(TEAM_NUM, 1.0)
	
	-- spawn delay
	SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment(DENSE_ENV)
	if VIEW_MULTIPLIER > 0 then SetAIViewMultiplier(VIEW_MULTIPLIER) end
	
	-- urban environtment
	-- IF TRUE: AI vehicles strafe less
	-- IF FALSE: AI vehicles strafe
	SetUrbanEnvironment(URBAN_ENV)
	
	-- sniping distance
	AISnipeSuitabilityDist(SNIPE_DIST)
	SetAttackerSnipeRange(SNIPE_ATT)
	SetDefenderSnipeRange(SNIPE_DEF)
	
	-- misc
	SetAllowBlindJetJumps(BLND_JET)
	SetGroundFlyerMap(GRND_FLYER)
	SetStayInTurrets(STAY_TUR)


	------------------------------------------------
	------------   LEVEL ANNOUNCER   ---------------
	------------------------------------------------

	-- announcer slow
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")
	

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
	
	-- music
    SetAmbientMusic(REP, 1.0, "rep_mus_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_mus_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_mus_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_mus_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_mus_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_mus_amb_end",    2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_mus_amb_victory")
    SetDefeatMusic (REP, "rep_mus_amb_defeat")
    SetVictoryMusic(CIS, "cis_mus_amb_victory")
    SetDefeatMusic (CIS, "cis_mus_amb_defeat")

    -- misc sound effects
	if NUM_BIRD_TYPES >= 1 then SetSoundEffect("BirdScatter", "birdsFlySeq1") end
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
	SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

	
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

--PostLoad, this is all done after all loading, etc.
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
   
	SoundEvent_SetupTeams(REP, 'rep', CIS, 'cis')
	
	-- define flag geometry
	SetProperty("FLAG1", "GeometryName", "com_icon_republic_flag")
	SetProperty("FLAG1", "CarriedGeometryName", "com_icon_republic_flag_carried")
	SetProperty("FLAG2", "GeometryName", "com_icon_cis_flag")
	SetProperty("FLAG2", "CarriedGeometryName", "com_icon_cis_flag_carried")
	SetClassProperty("com_item_flag", "DroppedColorize", 1)
	
	-- create objective
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, 
						   textATT = "game.modes.ctf", 
						   textDEF = "game.modes.ctf2",  
						   captureLimit = 5,
						   hideCPs = true,
						   multiplayerRules = true}
	
	-- add flags to the objective
	ctf:AddFlag{name = "FLAG1", homeRegion = "FLAG1_HOME", captureRegion = "FLAG2_HOME",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "FLAG2", homeRegion = "FLAG2_HOME", captureRegion = "FLAG1_HOME",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	
	-- start objective
	ctf:Start()
	
	
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
