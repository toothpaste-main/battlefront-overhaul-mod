--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_hunt")
ScriptCB_DoFile("bom_memorypool")
ScriptCB_DoFile("bomgcw_all_snow_pilot") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- empire attacking (attacker is always #1)
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
		-- jedi
		jedi = HOT_MAX_WAM_UNITS,
	
		-- map
		lights = 256,
		redOmniLights = 256,
		
		-- sounds
		soundStream = 5,
		soundSpace = 11,
		
		-- units
		totalUnits = HOT_MAX_ALL_UNITS + HOT_MAX_WAM_UNITS,
		totalAIVehicles = 10,
		cloths = HOT_MAX_ALL_UNITS,
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 44,		
		
		-- weapons
		mines = ASSAULT_MINES * MAX_ASSAULT,
		portableTurrets = SNIPER_TURRETS * MAX_SNIPER,
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

    ReadDataFile("sound\\hot.lvl;hot1gcw")
	
    -- wampas
    ReadDataFile("SIDE\\snw.lvl",
                 WAM_SOLDIER_CLASS)
    
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_hoth_dishturret",
				 "tur_bldg_hoth_lasermortar",
				 "tur_bldg_chaingun_tripod",
				 "tur_bldg_chaingun_roof")


	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------

	ReadDataFile("dc:SIDE\\all.lvl",
				 ALL_SOLDIER_CLASS,
				 ALL_ASSAULT_CLASS,
				 ALL_SNIPER_CLASS,
				 ALL_ENGINEER_CLASS,
				 ALL_OFFICER_CLASS,
				 ALL_SPECIAL_CLASS)
				 

	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    SetupTeams{
		-- alliance
        all = {
            team = ALL,
            units = HOT_MAX_ALL_UNITS,
            reinforcements = -1,
            soldier		= {ALL_SOLDIER_CLASS, MIN_SOLDIER, MAX_SOLDIER},
            assault		= {ALL_ASSAULT_CLASS, MIN_ASSAULT, MAX_ASSAULT},
            sniper		= {ALL_SNIPER_CLASS, MIN_SNIPER, MAX_SNIPER},
			engineer	= {ALL_ENGINEER_CLASS, MIN_ENGINEER, MAX_ENGINEER},
            officer		= {ALL_OFFICER_CLASS, MIN_OFFICER, MAX_OFFICER},
            special		= {ALL_SPECIAL_CLASS, MIN_SPECIAL, MAX_SPECIAL},
        },
        -- wampas
        wampa={
            team = IMP,
            units = HOT_MAX_WAM_UNITS,
            reinforcements = -1,
            soldier 	= {WAM_SOLDIER_CLASS, HOT_MAX_WAM_UNITS},
        }
    }
	
	-- localize wampas
	SetTeamName(IMP, "Wampas")
	
	-- WAMPA SMASH
	SetTeamAsEnemy(ALL, IMP)
	SetTeamAsEnemy(IMP, ALL) 
	

	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 150
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = -1
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("HOT\\hot1.lvl", "hoth_hunt")
	
	-- ceiling and floor limit
	SetMaxFlyHeight(MAP_CEILING_AI)			-- AI
	SetMaxPlayerFlyHeight(MAP_CEILING)		-- player
	SetMinFlyHeight(MAP_FLOOR_AI)
	SetMinPlayerFlyHeight(MAP_FLOOR)
	
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
	
	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
	
	-- music
	SetAmbientMusic(ALL, 1.0, "all_hot_amb_hunt", 0, 1)
	SetAmbientMusic(IMP, 1.0, "imp_hot_amb_hunt", 0, 1)

	-- game over song
	SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")

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
	
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)

end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("Death")
	AddDeathRegion("fall")
	
	-- remove AI barriers
	DisableBarriers("conquestbar")
	DisableBarriers("bombbar")
	
	
	------------------------------------------------
	------------   MAP SETUP   ---------------------
	------------------------------------------------
	
	-- set transport health
	SetProperty("ship", "MaxHealth", 1e+37)
	SetProperty("ship", "CurHealth", 1e+37)
	SetProperty("ship2", "MaxHealth", 1e+37)
	SetProperty("ship2", "CurHealth", 1e+37)
	SetProperty("ship3", "MaxHealth", 1e+37)
	SetProperty("ship3", "CurHealth", 1e+37)
	
	-- remove unused CPs
	KillObject("CP7OBJ")
	KillObject("shieldgen")
	KillObject("CP7OBJ")
	KillObject("hangarcp")
	KillObject("enemyspawn")
	KillObject("enemyspawn2")
	KillObject("echoback2")
	KillObject("echoback1")
	KillObject("shield")
    
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create objective
	createHuntObjective{pointsPerKillATT = HOT1_PPK_ATT, pointsPerKillDEF = HOT1_PPK_DEF}
end
 