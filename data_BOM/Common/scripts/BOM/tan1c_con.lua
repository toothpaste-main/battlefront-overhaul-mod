--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bomcw_ep3_marine_pilot") 
	
--  These variables do not change
ATT = 1
DEF = 2
--  REP Attacking (attacker is always #1)
REP = ATT
CIS = DEF

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
    
    ReadDataFile("sound\\tan.lvl;tan1cw")

    
	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------

	ReadDataFile("dc:sound\\bom.lvl;bomcw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	REP_HERO				= "rep_hero_yoda"
	
	-- cis
	CIS_HERO				= "cis_hero_grievous"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
		
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
            reinforcements = DEFAULT_REINFORCEMENTS,
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
            reinforcements = DEFAULT_REINFORCEMENTS,
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
    
	-- walkers
    ClearWalkers()
    AddWalkerType(0, MAX_SPECIAL)	-- droidekas


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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   

	-- winning/losing announcement
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
	-- low reinforcement warning
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "Repleaving")
    SetOutOfBoundsVoiceOver(CIS, "Cisleaving")

	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\tan.lvl",  "tan1")
    OpenAudioStream("sound\\tan.lvl",  "tan1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_tan_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_tan_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_tan_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tan_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_tan_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_tan_amb_end",    2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_tan_amb_victory")
    SetDefeatMusic (REP, "rep_tan_amb_defeat")
    SetVictoryMusic(CIS, "cis_tan_amb_victory")
    SetDefeatMusic (CIS, "cis_tan_amb_defeat")

    -- misc sounds effects
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")


	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176)
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752)
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381)

end
