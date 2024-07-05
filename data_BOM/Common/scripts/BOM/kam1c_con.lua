 --
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bbp_cmn") 
ScriptCB_DoFile("bbp_cw_ep3_shiny") 

--  These variables do not change
ATT = 1
DEF = 2
--  CIS Attacking (attacker is always #1)
REP = DEF
CIS = ATT


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
	------------   RESET CAMPAIGN RESTRICTIONS   ---
	------------------------------------------------

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
	------------   INITIALIZE COMMAND POSTS   ------
	------------------------------------------------
	
	-- reasign command posts to teams
	SetProperty("cp1", "Team", "1")
    SetProperty("cp2", "Team", "2")
    SetProperty("cp3", "Team", "2")
    SetProperty("cp4", "Team", "2")
    SetProperty("cp5", "Team", "1")
    SetProperty("cp6", "Team", "1")
	
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
 
	SetProperty("cp2", "spawnpath", "cp2_spawn")
    SetProperty("cp2", "captureregion", "cp2_capture")
 
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

    ReadDataFile("sound\\kam.lvl;kam1cw")
	
	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------

	ReadDataFile("dc:sound\\bbp.lvl;bbpcw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	REP_HERO				= "rep_hero_obiwan"
	
	-- cis
	CIS_HERO				= "cis_hero_jangofett"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",                            
				 REP_HERO)
				 
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO)
		
	-- turrets
	ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_chaingun_roof", -- might not be needed
		"tur_weap_built_gunturret")	

    
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
    local weaponCnt = 215
    SetMemoryPoolSize("Aimer", 39)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 210)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 18)
    SetMemoryPoolSize("EntityLight", 70)
    SetMemoryPoolSize("EntitySoundStream", 3)
    SetMemoryPoolSize("EntitySoundStatic", 84)
    SetMemoryPoolSize("MountedTurret", 22)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 800)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("SoundSpaceRegion", 36)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 338)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

	-- load gamemode
    ReadDataFile("kam\\kam1.lvl", "kamino1_conquest")

	-- world height
	MAX_FLY_HEIGHT = 100
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

    -- jetpack
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)

    
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
    SetOutOfBoundsVoiceOver(REP, "repleaving")
	SetOutOfBoundsVoiceOver(CIS, "cisleaving")


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_kam_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_kam_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_kam_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kam_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_kam_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_kam_amb_end",    2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_kam_amb_victory")
    SetDefeatMusic (REP, "rep_kam_amb_defeat")
    SetVictoryMusic(CIS, "cis_kam_amb_victory")
    SetDefeatMusic (CIS, "cis_kam_amb_defeat")


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

	AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922)
	AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774)
	AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919)
	AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421)
	AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089)
	AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552)

end
