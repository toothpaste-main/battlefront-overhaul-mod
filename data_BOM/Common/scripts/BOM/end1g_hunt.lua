--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_hunt")
ScriptCB_DoFile("bom_memorypool")

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
	
	setMemoryPoolSize{	
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
	
	
	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 45
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 1		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("end\\end1.lvl", "end1_hunt")
	
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
	SetWorldExtents(1277.3)
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- constants
	local AUTO_BLNC = false		-- redistributes more AI onto losing team
	local BLND_JET = 1			-- allow AI to jet jump outside of hints
	local DENSE_ENV = "true"
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
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
	voiceQuick = OpenAudioStream("sound\\global.lvl",	"all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl",	"imp_unit_vo_quick", voiceQuick)

   	-- out of bounds warning
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")
	

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

	-- create objective
	createHuntObjective{pointsPerKillATT = END1_PPK_ATT, pointsPerKillDEF = END1_PPK_DEF,
						textATT = TEXT_ATT_END1}
end
