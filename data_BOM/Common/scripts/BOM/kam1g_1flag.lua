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
ScriptCB_DoFile("bomgcw_all_fleeturban")
ScriptCB_DoFile("bomgcw_imp_pilot")

-- these variables do not change
local ATT = 1
local DEF = 2
-- alliance attacking (attacker is always #1)
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
		obstacles = 1024,
		lights = 96,
		redOmniLights = 96,
		
		-- sounds
		soundStatic = 80, 
		soundStream = 3,
		soundSpace = 36,
		
		-- units
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 21,
		
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
	
	ReadDataFile("sound\\kam.lvl;kam1gcw")


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
				 
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO)

	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
				 "tur_weap_built_gunturret")	


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


	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 100
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 60
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = -1
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode map layer
	ReadDataFile("KAM\\kam1.lvl", "KAMINO1_1ctf")
	
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
	local BLND_JET = 0			-- allow AI to jet jump outside of hints
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
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)   
    
    

     -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	-- out of bounds warning
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")

	OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")

	SetAmbientMusic(ALL, 1.0, "all_kam_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.9, "all_kam_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.1, "all_kam_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_kam_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.9, "imp_kam_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.1, "imp_kam_amb_end", 2,1)

	SetVictoryMusic(ALL, "all_kam_amb_victory")
	SetDefeatMusic (ALL, "all_kam_amb_defeat")
	SetVictoryMusic(IMP, "imp_kam_amb_victory")
	SetDefeatMusic (IMP, "imp_kam_amb_defeat")

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

	AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922)
	AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774)
	AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919)
	AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421)
	AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089)
	AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552)
end


-- PostLoad, this is all done after all loading, etc.
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
	------------   MAP INTERACTION   ---------------
	------------------------------------------------

	-- kill uncessary CPs
	KillObject("cp1")
	KillObject("cp2")
	KillObject("cp3")
	KillObject("cp4")
	KillObject("cp5")
	
	-- assign cp team numbers
	SetProperty("cp6", "Team", "2")
    SetProperty("cp7", "Team", "1")
	SetProperty("cp11", "Team", "2")
	SetProperty("cp22", "Team", "1")
	
	-- hide cp numbers on map
	SetProperty("cp6", "HUDIndexDisplay", 0)
	SetProperty("cp7", "HUDIndexDisplay", 0)
	SetProperty("cp11", "HUDIndexDisplay", 0)
	SetProperty("cp22", "HUDIndexDisplay", 0)

	-- setup new cps
	SetProperty("cp11", "IsVisible", "1")
	SetProperty("cp22", "SpawnPath", "NEW")
	SetProperty("cp11", "captureregion", "death")
	SetProperty("cp22", "captureregion", "death")

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
    
	-- create objective		   
	ctf = createOneFlagObjective{teamATTName = "all", teamDEFName = "imp",
								 flagName = "flag", homeRegion = "flag_home",
							     attCaptureRegion = "lag_capture2", defCaptureRegion = "lag_capture1"}
	
	-- start objective
    ctf:Start()

	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------

    EnableSPHeroRules()
end
