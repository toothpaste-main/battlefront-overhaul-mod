--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

-- load BBP constants
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomgcw_all_desert")
ScriptCB_DoFile("bomgcw_imp")

-- these variables do not change
local ATT = 1
local DEF = 2
-- empire attacking (attacker is always #1)
local ALL = DEF
local IMP = ATT

-- jawas
local JAW = 3
local JAW_UNITS = 6

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
	-- Digners, these two lines *MUST* be first.--
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
	local NUM_SND_SPA = 1
	local NUM_SND_STC = 43
	local NUM_SND_STM = 2
	local NUM_TENT = 4*MAX_SPECIAL
	local NUM_TREE = 512
	local NUM_TUR = 19
	local NUM_TUR_PORT = 2 * SNIPER_TURRETS * MAX_SNIPER
	local NUM_UNITS = 96		-- it's easier this way
	local NUM_WEAP = 256		-- more if locals and vehicles!
	local WALKER0 = 0
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
    SetMemoryPoolSize("Combo::Deflect", NUM_JEDI*4) 			-- should be ~1x #combo
	
	
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
	
    ReadDataFile("sound\\tat.lvl;tat2gcw")
	

	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_hansolo_tat"
	
	-- empire
	local IMP_HERO = "imp_hero_bobafett"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO)
                
	-- alliance
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 imp_fly_destroyer_dome)
	
	-- jawas
    ReadDataFile("SIDE\\des.lvl",
                 "tat_inf_jawa")

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_tat_barge",	
				 "tur_bldg_laser")	


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
            reinforcements = -1,
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
            reinforcements = -1,
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

	-- setup jawas
	SetTeamName(JAW, "Jawas")
	SetUnitCount(JAW, JAW_UNITS)
	AddUnitClass(JAW, "tat_inf_jawa", JAW_UNITS)
	
	-- jawa revenge!
	AddAIGoal(JAW, "deathmatch", 100)
	SetTeamAsEnemy(JAW, ATT)
	SetTeamAsEnemy(JAW, DEF) 
	SetTeamAsEnemy(ATT, JAW)
	SetTeamAsEnemy(DEF, JAW)


    ------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 40
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = -1
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("TAT\\tat2.lvl", "tat2_ctf")
	
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)    
	
	-- out of bounds warning
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\tat.lvl", "tat2")
    OpenAudioStream("sound\\tat.lvl", "tat2")

	-- music
    SetAmbientMusic(ALL, 1.0, "all_tat_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_tat_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end", 2,1)

	-- game over song
    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")

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
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------
	
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681)
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561)
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613)
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477)
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------
	
	-- hide CPs
	KillObject("CP1")
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	KillObject("CP7")
	KillObject("CP8")
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	SoundEvent_SetupTeams(ALL, 'all', IMP, 'imp')
	
	-- define flag geometry
    SetProperty("ctf_flag1", "GeometryName", "com_icon_empire_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_empire_flag_carried")
    SetProperty("ctf_flag2", "GeometryName", "com_icon_alliance_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_alliance_flag_carried")
	
	-- create objective
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, 
						   textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", 
						   captureLimit = 5,
						   hideCPs = true,
						   multiplayerRules = true}
						   
	-- add flags to the objective
	ctf:AddFlag{name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

	-- start objective
	ctf:Start()
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
end