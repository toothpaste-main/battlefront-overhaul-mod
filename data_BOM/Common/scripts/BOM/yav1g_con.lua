--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_g_jungle")

-- these variables do not change
ATT = 1
DEF = 2
-- Empire attacking (attacker is always #1)
ALL = DEF
IMP = ATT


function ScriptPostLoad()

    ------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("death1")
	AddDeathRegion("death2")
	AddDeathRegion("death3")
	AddDeathRegion("death4")
	AddDeathRegion("death5")
	AddDeathRegion("death6")
	AddDeathRegion("death7")
	AddDeathRegion("death8") 
	
	
	------------------------------------------------
	------------   RESET CAMPAIGN RESTRICTIONS  ----
	------------------------------------------------
	
	-- blow out blast door
	KillObject ("TempleBlastDoor")
	
	
	------------------------------------------------
	------------   INITIALIZE COMMAND POSTS   ------
	------------------------------------------------
	
	--This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "Bazaar"}
    cp2 = CommandPost:New{name = "CP1"}
    cp3 = CommandPost:New{name = "LandingZone"}
    cp4 = CommandPost:New{name = "ReflectingPool"}
    cp5 = CommandPost:New{name = "Temple"}
    cp6 = CommandPost:New{name = "Tflank"}
    cp7 = CommandPost:New{name = "ViaDuct"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
                                         
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    
    conquest:Start()
	
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
    ReadDataFile("ingame.lvl")
    
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

    ReadDataFile("sound\\yav.lvl;yav1gcw")
	
	
	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	
	ReadDataFile("dc:sound\\bom.lvl;bomgcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	ALL_HERO				= "all_hero_chewbacca"
	
	-- empire
	IMP_HERO				= "imp_hero_bobafett"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- rebels
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO,
				 "all_hover_combatspeeder")
                
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO,
				 "imp_hover_fightertank",
				 "imp_hover_speederbike")

	-- turrets
	ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser",
    			"tur_bldg_tower")   

	
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------

	-- rebels
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
		-- rebels
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
	
	-- walkers
	ClearWalkers()
	
	
	------------------------------------------------
	------------   LEVEL STATS   -------------------
	------------------------------------------------
  
    -- memory pool
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 975)
	SetMemoryPoolSize("ConnectivityGraphFollower", 47)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntityHover", 8)
	SetMemoryPoolSize("EntityLight", 36)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("MountedTurret", 19)
    SetMemoryPoolSize("Navigator", 47)
    SetMemoryPoolSize("Obstacle", 760)
	SetMemoryPoolSize("PathFollower", 47)
	SetMemoryPoolSize("PathNode", 217)
    SetMemoryPoolSize("SoundSpaceRegion", 30)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 490)
    SetMemoryPoolSize("UnitAgent", 47)
    SetMemoryPoolSize("UnitController", 47)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6)   

	-- load gamemode
	ReadDataFile("YAV\\yav1.lvl","yavin1_Conquest")

	-- world height
	MAX_FLY_HEIGHT = 14
	SetMaxFlyHeight(MAX_FLY_HEIGHT)			-- AI
    SetMaxPlayerFlyHeight(MAX_FLY_HEIGHT)	-- player

    -- birdies
    SetNumBirdTypes(2)
    SetBirdType(0,1.0,"bird")
    SetBirdType(1,1.5,"bird2")

    -- fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")
	
	-- misc
	SetAttackingTeam(ATT)
	
	
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- spawn delay
    SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment("false")


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

	-- winning/losing announcement
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	-- winning/losing announcement
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
    
	-- ambience
	OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

	-- music
    SetAmbientMusic(ALL, 1.0, "all_yav_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_yav_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_yav_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_yav_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_yav_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_yav_amb_end",    2,1)

	-- game over song
    SetVictoryMusic(ALL, "all_yav_amb_victory")
    SetDefeatMusic (ALL, "all_yav_amb_defeat")
    SetVictoryMusic(IMP, "imp_yav_amb_victory")
    SetDefeatMusic (IMP, "imp_yav_amb_defeat")

	-- misc sounds effects
    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    ------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

	AddCameraShot(0.660400, -0.059877, -0.745465, -0.067590, 143.734436, -55.725388, 7.761997)
	AddCameraShot(0.830733, -0.144385, 0.529679, 0.092061, 111.796799, -42.959831, 75.199142)
	AddCameraShot(0.475676, -0.064657, -0.869247, -0.118154, 13.451733, -47.769894, 13.242496)
	AddCameraShot(-0.168833, 0.020623, -0.978158, -0.119483, 58.080200, -50.858742, -62.208008)
	AddCameraShot(0.880961, -0.440820, -0.153824, -0.076971, 101.777763, -46.775646, -29.683767)
	AddCameraShot(0.893823, -0.183838, 0.400618, 0.082398, 130.714828, -60.244068, -27.587791)
	AddCameraShot(0.999534, 0.004060, 0.030244, -0.000123, 222.209137, -61.220325, -18.061192)
	AddCameraShot(0.912637, -0.057866, 0.403844, 0.025606, 236.693344, -49.829277, -116.150986)
	AddCameraShot(0.430732, -0.016398, -0.901678, -0.034328, 180.692062, -54.148796, -159.856644)
	AddCameraShot(0.832119, -0.063785, 0.549306, 0.042107, 160.699402, -54.148796, -130.990692)
	AddCameraShot(0.404200, -0.037992, -0.909871, -0.085520, 68.815331, -54.148796, -160.837585)
	AddCameraShot(-0.438845, 0.053442, -0.890394, -0.108431, 116.562241, -52.504406, -197.686005)
	AddCameraShot(0.389349, -0.113400, -0.877617, -0.255609, 29.177610, -23.974962, -288.061676)
	AddCameraShot(0.499938, -0.081056, -0.851146, -0.137998, 90.326912, -28.060659, -283.329376)
	AddCameraShot(-0.217006, 0.015116, -0.973694, -0.067827, 202.056778, -37.476913, -181.445663)
	AddCameraShot(0.990640, -0.082509, 0.108367, 0.009026, 206.266953, -37.476913, -225.158249)
	AddCameraShot(-0.386589, 0.126400, -0.868314, -0.283907, 224.942032, -17.820135, -269.532227)
	AddCameraShot(0.967493, 0.054298, 0.246611, -0.013840, 155.984451, -30.781782, -324.836975)
	AddCameraShot(-0.453147, 0.140485, -0.840816, -0.260672, 164.648956, -0.002431, -378.487061)
	AddCameraShot(0.592731, -0.182571, -0.749678, -0.230913, 99.326836, -13.029744, -414.846191)
	AddCameraShot(0.865750, -0.184352, 0.455084, 0.096905, 137.221359, -19.694859, -436.057556)
	AddCameraShot(0.026915, -0.002609, -0.994969, -0.096461, 128.397949, -30.249140, -428.447418)

end
