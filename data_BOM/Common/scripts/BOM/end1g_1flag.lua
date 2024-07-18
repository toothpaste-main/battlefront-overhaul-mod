--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

-- load BOM assets
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bom_ctf")
ScriptCB_DoFile("bom_memorypool")
ScriptCB_DoFile("bomgcw_all_jungle")
ScriptCB_DoFile("bomgcw_imp")

-- these variables do not change
local ATT = 1
local DEF = 2
-- alliance attacking (attacker is always #1)
local ALL = ATT
local IMP = DEF

-- ewoks
local EWK = 3
local EWK_UNITS = 6


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
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 3,
		
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
	
	ReadDataFile("sound\\end.lvl;end1gcw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_hansolo_tat"
	
	-- empire
	local IMP_HERO = "imp_hero_darthvader"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
    -- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO)
				 
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 "imp_hover_speederbike",
				 "imp_walk_atst_jungle")

	-- ewoks
	ReadDataFile("SIDE\\ewk.lvl",
				 "ewk_inf_basic")

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
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


	-- setup ewoks
	SetTeamName(EWK, "locals")
	AddUnitClass(EWK, "ewk_inf_trooper", 3)
	AddUnitClass(EWK, "ewk_inf_repair", 3)
	SetUnitCount(EWK, EWK_UNITS)	
	
	-- establish good relations with the locals
	SetTeamAsFriend(EWK, ATT)
	SetTeamAsEnemy(EWK, DEF)
	SetTeamAsFriend(ATT, EWK)
	SetTeamAsEnemy(DEF, EWK)
	
	
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
	
	-- load gamemode map layer
	ReadDataFile("end\\end1.lvl", "end1_1flag")
	
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

	-- winning/losing announcement
	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

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
	SetAmbientMusic(ALL, 1.0, "all_end_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.8, "all_end_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_end_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.8, "imp_end_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_end_amb_end", 2,1)
	
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

function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS  ------------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
		
	-- create objective		   
	ctf = createOneFlagObjective{teamATTName = "all", teamDEFName = "imp",
								 flagName = "flag", homeRegion = "team1_capture",
							     attCaptureRegion = "team1_capture", defCaptureRegion = "team2_capture"}
	
	-- set AI goals
	AddAIGoal(EWK, "deathmatch", 100)
	
	-- start objective
	ctf:Start()
	
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	EnableSPHeroRules()
end
