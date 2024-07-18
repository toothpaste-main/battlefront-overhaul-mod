--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")

-- load BBP constants
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_conquest")
ScriptCB_DoFile("bom_memorypool")
ScriptCB_DoFile("bomgcw_all_jungle")
ScriptCB_DoFile("bomgcw_imp_atst")

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
		redOmniLights = 48,
		
		-- sounds 
		soundStream = 1,
		music = 39,
		
		-- units
		wookiees = MAX_SPECIAL + 4,
		
		-- vehicles
		hovers = 2,
		onePair = 2,
		
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
	
    ReadDataFile("sound\\fel.lvl;fel1gcw")

	
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
				 "imp_walk_atst")
 
 
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
	
	
	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 55
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 1		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 1		-- 1 fish
	
	-- load gamemode
	ReadDataFile("fel\\fel1.lvl", "fel1_conquest")
	
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
	local VIEW_MULTIPLIER = 0.65-- -1 for default
	
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
	voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)
	
	-- winning/losing announcement
	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
    
	-- low reinforcement warning
	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)
	
	-- out of bounds warning
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")

    
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\fel.lvl", "fel1")
    OpenAudioStream("sound\\fel.lvl", "fel1")

    -- music
    SetAmbientMusic(ALL, 1.0, "all_fel_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_fel_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2,"all_fel_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_fel_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_fel_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2,"imp_fel_amb_end", 2,1)
	
	-- game over song
    SetVictoryMusic(ALL, "all_fel_amb_victory")
    SetDefeatMusic (ALL, "all_fel_amb_defeat")
    SetVictoryMusic(IMP, "imp_fel_amb_victory")
    SetDefeatMusic (IMP, "imp_fel_amb_defeat")

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

    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

    -- create and start objective	
	createConquestObjective{cps = {"cp1-1", "cp2-1", "cp3-1", "cp4-1", "cp5-1", "cp6-1"}}
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
    EnableSPHeroRules()
end
