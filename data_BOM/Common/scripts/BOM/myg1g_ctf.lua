--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams") 

-- load BBP constants
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_g_snow")

--  These variables do not change
ATT = 1
DEF = 2
--  ALL Attacking (attacker is always #1)
ALL = ATT
IMP = DEF


function ScriptPostLoad()
	
	SoundEvent_SetupTeams(IMP, 'imp', ALL, 'all')
 
	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("deathregion")
 
	-- remove AI barriers
	DisableBarriers("coresh1")
	DisableBarriers("corebar1")
	DisableBarriers("corebar2")
	DisableBarriers("corebar3")
	DisableBarriers("corebar4")
	DisableBarriers("coresh1")
	DisableBarriers("dropship")
	DisableBarriers("shield_01")
	DisableBarriers("shield_02")
	DisableBarriers("shield_03")
	
    ------------------------------------------------
	------------   INITIALIZE FLAGS   ------
	------------------------------------------------
	
    -- define flag geometry
	SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
	SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
	SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
	SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")
	SetClassProperty("com_item_flag", "DroppedColorize", 1)

	-- create objective
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, 
						   captureLimit = 5, 
						   textATT = "game.modes.CTF", 
						   textDEF = "game.modes.CTF2", 
						   hideCPs = true, 
						   multiplayerRules = true}
    
	-- add flags to objective
	ctf:AddFlag{name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
				
	-- start objective
    ctf:Start()
    
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

	
	-----------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	
	-- global
	ReadDataFile("dc:sound\\bom.lvl;bom_cmn")
	
	-- era
	ReadDataFile("dc:sound\\bom.lvl;bomgcw")
	
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------
	
	ReadDataFile("sound\\myg.lvl;myg1gcw")


	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- rebels
	ALL_HERO				= "all_hero_luke_pilot"
	
	-- empire
	IMP_HERO				= "imp_hero_darthvader"
	
    
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
				 "tur_bldg_recoilless_lg")


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
	
	-- walkers
	ClearWalkers()
	
	
	------------------------------------------------
	------------   LEVEL STATS   -------------------
	------------------------------------------------
	
	-- memory pool
	SetMemoryPoolSize("Aimer", 80)
	SetMemoryPoolSize("EntityCloth", 31)
	SetMemoryPoolSize("EntityHover", 8)
	SetMemoryPoolSize("EntityFlyer", 6)
	SetMemoryPoolSize("EntityLight", 36)
	SetMemoryPoolSize("EntitySoundStream", 1)
	SetMemoryPoolSize("EntitySoundStatic", 76)     
	SetMemoryPoolSize("FlagItem", 2) 
	SetMemoryPoolSize("MountedTurret", 14)
	SetMemoryPoolSize("Obstacle", 520)
	SetMemoryPoolSize("PassengerSlot", 0)
	SetMemoryPoolSize("PathNode", 512)
	SetMemoryPoolSize("TreeGridStack", 300)
	SetMemoryPoolSize("Weapon", 260)

	-- load gamemode
	ReadDataFile("myg\\myg1.lvl", "myg1_ctf")
	
    -- world height
	MAX_FLY_HEIGHT = 20
	SetMaxFlyHeight(MAX_FLY_HEIGHT)			-- AI
    SetMaxPlayerFlyHeight(MAX_FLY_HEIGHT)	-- player

	
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
	voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_quick", voiceQuick)   

	-- out of bounds warning
	SetOutOfBoundsVoiceOver(ALL, "allleaving")
	SetOutOfBoundsVoiceOver(IMP, "impleaving")
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\myg.lvl", "myg1")
	OpenAudioStream("sound\\myg.lvl", "myg1")
	
	-- music
	SetAmbientMusic(ALL, 1.0, "all_myg_amb_start", 0,1)
	SetAmbientMusic(ALL, 0.9, "all_myg_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.1, "all_myg_amb_end", 2,1)
	SetAmbientMusic(IMP, 1.0, "imp_myg_amb_start", 0,1)
	SetAmbientMusic(IMP, 0.9, "imp_myg_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.1, "imp_myg_amb_end", 2,1)

	-- game over song
	SetVictoryMusic(ALL, "all_myg_amb_victory")
	SetDefeatMusic (ALL, "all_myg_amb_defeat")
	SetVictoryMusic(IMP, "imp_myg_amb_victory")
	SetDefeatMusic (IMP, "imp_myg_amb_defeat")

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
	
	-- Collector Shot
    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090)
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359)
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212)
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887)
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128)
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712)
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550)
end
