--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bbp_cmn")
ScriptCB_DoFile("bbp_g_urban")

--  These variables do not change
ATT = 1
DEF = 2
--  ALL Attacking (attacker is always #1)
ALL = ATT
IMP = DEF

function ScriptPostLoad()

	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
	
	UnblockPlanningGraphArcs("Connection74")	-- idk what this does
	
	-- bridge animation
    PlayAnimRise()
    OnObjectRespawnName(PlayAnimRise, "DingDong");
    OnObjectKillName(PlayAnimDrop, "DingDong");
	
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
	------------   INITIALIZE COMMAND POSTS   ------
	------------------------------------------------
    
	--This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
	
    conquest:Start()
 
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
    
	ReadDataFile("sound\\mus.lvl;mus1gcw")


	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	
	
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	ALL_HERO				= "rep_hero_obiwan"
	
	-- empire
	IMP_HERO				= "rep_hero_anakin"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_hero_obiwan",
				 "rep_hero_anakin")


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
    SetMemoryPoolSize("Aimer", 15)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 20)
    SetMemoryPoolSize("EntitySoundStream", 2)
    SetMemoryPoolSize("EntitySoundStatic", 133)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("EntityFlyer", 4)
    SetMemoryPoolSize("MountedTurret", 3)
    SetMemoryPoolSize("Obstacle", 309)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("Weapon", weaponCnt)

    -- load gamemode
    ReadDataFile("mus\\mus1.lvl", "MUS1_CONQUEST")

	-- world height
	MAX_FLY_HEIGHT = 90
	SetMaxFlyHeight(MAX_FLY_HEIGHT)			-- AI
    SetMaxPlayerFlyHeight(MAX_FLY_HEIGHT)	-- player

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
	AISnipeSuitabilityDist(30)
	
	
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

	-- low reinforcement warning
	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)
	
	-- out of bounds warning
	SetOutOfBoundsVoiceOver(all, "allleaving")
	SetOutOfBoundsVoiceOver(imp, "impleaving")

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- ambience
	OpenAudioStream("sound\\global.lvl",  "gcw_music")
	OpenAudioStream("sound\\mus.lvl",  "mus1")
	OpenAudioStream("sound\\mus.lvl",  "mus1")


	-- music
	SetAmbientMusic(ALL, 1.0, "all_mus_amb_start",  0,1)
	SetAmbientMusic(ALL, 0.8, "all_mus_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2,"all_mus_amb_end",    2,1)
	SetAmbientMusic(IMP, 1.0, "imp_mus_amb_start",  0,1)
	SetAmbientMusic(IMP, 0.8, "imp_mus_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2,"imp_mus_amb_end",    2,1)

	-- game over song
	SetVictoryMusic(ALL, "all_mus_amb_victory")
	SetDefeatMusic (ALL, "all_mus_amb_defeat")
	SetVictoryMusic(IMP, "imp_mus_amb_victory")
	SetDefeatMusic (IMP, "imp_mus_amb_defeat")

	-- misc sounds effects
	SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


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


