--
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bbp_cmn")
ScriptCB_DoFile("bbp_g_fleet")

--  These variables do not change
ATT = 1
DEF = 2
--  ALL Attacking (attacker is always #1)
ALL = ATT
IMP = DEF


function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
    AddDeathRegion("turbinedeath")
    
    
	-- remove AI barriers	
    DisableBarriers("barracks")
    DisableBarriers("liea")
    
	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
	
	-- Turbine Stuff -- 
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine, "turbineconsole")
    OnObjectRespawnName(returbine, "turbineconsole")    
	healturbine()
	
	
	------------------------------------------------
	------------   RESET CAMPAIGN RESTRICTIONS  ----
	------------------------------------------------
	
	-- blow out blast door
    KillObject("blastdoor")
	
	
	------------------------------------------------
	------------   INITIALIZE COMMAND POSTS   ------
	------------------------------------------------
	
	--This defines the CPs.  These need to happen first
    cp4 = CommandPost:New{name = "CP4CON"}
    cp5 = CommandPost:New{name = "CP5CON"}
    cp6 = CommandPost:New{name = "CP6CON"}
    cp7 = CommandPost:New{name = "CP7CON"}
    
	--This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
									 textATT = "game.modes.con", 
									 textDEF = "game.modes.con2", 
									 multiplayerRules = true}
    
	--This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    
    conquest:Start()
    
    EnableSPHeroRules()
    
end

function healturbine()
	--Setup Timer-- 
	timeConsole = CreateTimer("timeConsole")
	SetTimerValue(timeConsole, 0.3)
	StartTimer(timeConsole)
	OnTimerElapse(
		function(timer)
			-- I think this replenishes the health over time
			SetProperty("turbineconsole", "CurHealth", GetObjectHealth("turbineconsole") + 1)
			DestroyTimer(timer)
		end,
	timeConsole
	)
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
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
	
	ReadDataFile("sound\\tan.lvl;tan1gcw")


	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	
	
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	ALL_HERO				= "all_hero_leia"
	
	-- empire
	IMP_HERO				= "imp_hero_darthvader"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- rebels
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO)
                
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO)
                    
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
	local weaponCnt = 177
	SetMemoryPoolSize ("Aimer", 17)
	SetMemoryPoolSize ("AmmoCounter", weaponCnt)
	SetMemoryPoolSize ("BaseHint", 250)
	SetMemoryPoolSize ("EnergyBar", weaponCnt)
	SetMemoryPoolSize ("EntityCloth", 18)
	SetMemoryPoolSize ("EntitySoundStream", 14)
	SetMemoryPoolSize ("EntitySoundStatic", 29)
	SetMemoryPoolSize ("EntityFlyer", 6)
	SetMemoryPoolSize ("MountedTurret", 2)
	SetMemoryPoolSize ("Navigator", MAX_UNITS)
	SetMemoryPoolSize ("Obstacle", 250)
	SetMemoryPoolSize ("PathFollower", MAX_UNITS)
	SetMemoryPoolSize ("PathNode", 384)
	SetMemoryPoolSize ("SoundspaceRegion", 15)
	SetMemoryPoolSize ("TentacleSimulator", 0)
	SetMemoryPoolSize ("TreeGridStack", 150)
	SetMemoryPoolSize ("UnitAgent", MAX_UNITS)
	SetMemoryPoolSize ("UnitController", MAX_UNITS)
	SetMemoryPoolSize ("Weapon", weaponCnt)

	-- load gamemode
    ReadDataFile("tan\\tan1.lvl", "tan1_conquest")
    
	-- misc
	SetMapNorthAngle(180)
	SetWorldExtents(1064.5)
	
	
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
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
	OpenAudioStream("sound\\global.lvl",  "gcw_music")
	OpenAudioStream("sound\\tan.lvl",  "tan1")
	OpenAudioStream("sound\\tan.lvl",  "tan1")
	
	-- music
	SetAmbientMusic(ALL, 1.0, "all_tan_amb_start",  0,1)
	SetAmbientMusic(ALL, 0.8, "all_tan_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2,"all_tan_amb_end",    2,1)
	SetAmbientMusic(IMP, 1.0, "imp_tan_amb_start",  0,1)
	SetAmbientMusic(IMP, 0.8, "imp_tan_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2,"imp_tan_amb_end",    2,1)

	-- game over song
	SetVictoryMusic(ALL, "all_tan_amb_victory")
	SetDefeatMusic (ALL, "all_tan_amb_defeat")
	SetVictoryMusic(IMP, "imp_tan_amb_victory")
	SetDefeatMusic (IMP, "imp_tan_amb_defeat")

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

    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176)
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752)
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381)
	
 end
