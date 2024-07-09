--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams") 

-- load BOM constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bom_cw_ep3_marine") 
	
-- these variables do not change
ATT = 1
DEF = 2
-- REP attacking (attacker is always #1)
REP = ATT
CIS = DEF


function ScriptPostLoad()
	
	SoundEvent_SetupTeams(CIS, 'cis', REP, 'rep')
 
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
	------------   SHIELD FUNCTIONALITY   ----------
	------------------------------------------------
	
	OnObjectRespawnName(Revived, "generator_01")
    OnObjectKillName(ShieldDied, "force_shield_01")
    OnObjectKillName(ShieldDied, "generator_01")
    

    OnObjectRespawnName(Revived, "generator_02")
    OnObjectKillName(ShieldDied, "force_shield_02")
    OnObjectKillName(ShieldDied, "generator_02")
   
    OnObjectRespawnName(Revived, "generator_03")
    OnObjectKillName(ShieldDied, "force_shield_03")
    OnObjectKillName(ShieldDied, "generator_03")
	

    ------------------------------------------------
	------------   INITIALIZE FLAGS   --------------
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
    
	
------------------------------------------------
------------   SHIELD LOGIC  -------------------
------------------------------------------------

-- initialize shield
function Init(numberStr)
	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldUp(shieldName, genName, upAnim, downAnim)

	BlockPlanningGraphArcs("shield_" .. numberStr)
	EnableBarriers("shield_" .. numberStr)
end

-- upon shield life
function Revived(actor)
	fullName = GetEntityName(actor)
	numberStr = string.sub(fullName, -2, -1)

	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldUp(shieldName, genName, upAnim, downAnim)
	BlockPlanningGraphArcs("shield_" .. numberStr)
	EnableBarriers("shield_" .. numberStr)
end

-- upon shield death
function ShieldDied(actor)
	fullName = GetEntityName(actor)
	numberStr = string.sub(fullName, -2, -1)

	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldDown(shieldName, genName, upAnim, downAnim)

	UnblockPlanningGraphArcs("shield_" .. numberStr)
	DisableBarriers("shield_" .. numberStr)
end

-- raise shield
function PlayShieldUp(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj)
      RespawnObject(genObj)
      PauseAnimation(downAnim)
      RewindAnimation(upAnim)
      PlayAnimation(upAnim)
end

-- lower shield
function PlayShieldDown(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj)
      KillObject(genObj)
      PauseAnimation(upAnim)
      RewindAnimation(downAnim)
      PlayAnimation(downAnim)
    
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
	------------   DLC SOUNDS   --------------------
	------------------------------------------------
	
	ReadDataFile("dc:sound\\bom.lvl;bomcw")
	

	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

	ReadDataFile("sound\\myg.lvl;myg1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	REP_HERO				= "rep_hero_kiyadimundi"
	
	-- cis
	CIS_HERO				= "cis_hero_grievous"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

		-- republic
	ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_fly_gunship_dome",
				 "rep_hover_barcspeeder",
				 "rep_hover_fightertank")
	
	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO,
				 "cis_fly_gunship_dome",
				 "cis_hover_aat",
				 "cis_hover_stap")
	
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_recoilless_lg")


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
	
	-- memory poo
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    local weaponCnt = 165
    SetMemoryPoolSize("Aimer", 65)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 13)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 460)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
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
	voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    -- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
	-- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
	OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\myg.lvl", "myg1")
    OpenAudioStream("sound\\myg.lvl", "myg1")
	
	-- music
    SetAmbientMusic(REP, 1.0, "rep_myg_amb_start", 0,1)
    SetAmbientMusic(REP, 0.9, "rep_myg_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1, "rep_myg_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.9, "cis_myg_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1, "cis_myg_amb_end", 2,1)
	
	-- game over song
    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

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


