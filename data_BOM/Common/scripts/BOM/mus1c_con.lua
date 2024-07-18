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
ScriptCB_DoFile("bomcw_ep3") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF


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
		redOmniLights = 64,
		
		-- sounds
		soundStatic = 116, 
		soundStream = 2,
		soundSpace = 13,
		
		-- units
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		droidekas = MAX_SPECIAL,
		
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
	ReadDataFile("dc:sound\\bom.lvl;bomcw")
    
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

    ReadDataFile("sound\\mus.lvl;mus1cw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_obiwan"
	
	-- cis
	local CIS_HERO = "cis_hero_darthmaul"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
	
	-- cis
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


	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 90
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = -1
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("mus\\mus1.lvl", "mus1_conquest")
	
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    

	-- winning/losing announcement
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
	-- low reinforcement warning
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_victory_im", .1, 1)  

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")
	

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
    OpenAudioStream("sound\\mus.lvl",  "mus1")
	
	-- music
    SetAmbientMusic(REP, 1.0, "rep_mus_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_mus_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_mus_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_mus_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_mus_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_mus_amb_end",    2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_mus_amb_victory")
    SetDefeatMusic (REP, "rep_mus_amb_defeat")
    SetVictoryMusic(CIS, "cis_mus_amb_victory")
    SetDefeatMusic (CIS, "cis_mus_amb_defeat")

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


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

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
	------------   MAP SETUP   ---------------------
	------------------------------------------------
	
	UnblockPlanningGraphArcs("Connection74")	-- idk what this does
	
	-- raise bridges
    PlayAnimRise()

	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
	
	-- bridge work
	OnObjectRespawnName(PlayAnimRise, "DingDong")
    OnObjectKillName(PlayAnimDrop, "DingDong")
	
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
    -- create and start objective	
	createConquestObjective{cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}}
 
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
 
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
