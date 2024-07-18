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
ScriptCB_DoFile("bomcw_ep3") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF

-- gamorrean guards
local GAM = 3
local GAM_UNITS = 3


---------------------------------------------------------------------------
-- FUNCTION:	ScriptInit
-- PURPOSE:	This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:		The name, 'ScriptInit' is a chosen convention, and each
--			mission script must contain a version of this function, as
--			it is called from C to start the mission.
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
		jedi = 2 + GAM_UNITS,
	
		-- map
		lights = 128,
		redOmniLights = 128,
		
		-- sounds
		soundStream = 2,
		soundSpace = 72,
		
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

	ReadDataFile("sound\\tat.lvl;tat3cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_anakin"
	
	-- cis
	local CIS_HERO = "cis_hero_countdooku"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
	ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO)
	
	-- cis
	ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO)

	-- gamorrean guards
	ReadDataFile("SIDE\\gam.lvl",
				 "gam_inf_gamorreanguard")


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
            reinforcements = -1,
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
            reinforcements = -1,
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
	
	-- setup gamorrean guard
	SetTeamName(GAM, "locals")
	SetUnitCount(GAM, GAM_UNITS)
	AddUnitClass(GAM, "gam_inf_gamorreanguard", GAM_UNITS)
	
	
	-- gamorrean enemies with everyone
	AddAIGoal(GAM, "deathmatch", 100)
	SetTeamAsEnemy(GAM, ATT)
	SetTeamAsEnemy(GAM, DEF) 
	SetTeamAsEnemy(ATT, GAM)
	SetTeamAsEnemy(DEF, GAM)


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
	
	-- load gamemode map layer
	ReadDataFile("TAT\\tat3.lvl", "tat3_1flag")
	
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
	AudioStreamAppendSegments("sound\\global.lvl", "gam_unit_vo_slow", voiceSlow)
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
    SetOutOfBoundsVoiceOver(REP, "Repleaving")
    SetOutOfBoundsVoiceOver(CIS, "Cisleaving")

	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "cw_music")
	OpenAudioStream("sound\\tat.lvl", "tat3")
	OpenAudioStream("sound\\tat.lvl", "tat3")
	OpenAudioStream("sound\\tat.lvl", "tat3_emt")

	-- music
	SetAmbientMusic(REP, 1.0, "rep_tat_amb_start", 0,1)
	SetAmbientMusic(REP, 0.8, "rep_tat_amb_middle", 1,1)
	SetAmbientMusic(REP, 0.2, "rep_tat_amb_end", 2,1)
	SetAmbientMusic(CIS, 1.0, "cis_tat_amb_start", 0,1)
	SetAmbientMusic(CIS, 0.8, "cis_tat_amb_middle", 1,1)
	SetAmbientMusic(CIS, 0.2, "cis_tat_amb_end", 2,1)

	-- game over song
	SetVictoryMusic(REP, "rep_tat_amb_victory")
	SetDefeatMusic (REP, "rep_tat_amb_defeat")
	SetVictoryMusic(CIS, "cis_tat_amb_victory")
	SetDefeatMusic (CIS, "cis_tat_amb_defeat")

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

	AddCameraShot(0.685601, -0.253606, -0.639994, -0.236735, -65.939224, -0.176558, 127.400444)
	AddCameraShot(0.786944, 0.050288, -0.613719, 0.039218, -80.626396, 1.175180, 133.205551)
	AddCameraShot(0.997982, 0.061865, -0.014249, 0.000883, -65.227898, 1.322798, 123.976990)
	AddCameraShot(-0.367869, -0.027819, -0.926815, 0.070087, -19.548307, -5.736280, 163.360519)
	AddCameraShot(0.773980, -0.100127, -0.620077, -0.080217, -61.123989, -0.629283, 176.066025)
	AddCameraShot(0.978189, 0.012077, 0.207350, -0.002560, -88.388947, 5.674968, 153.745255)
	AddCameraShot(-0.144606, -0.010301, -0.986935, 0.070304, -106.872772, 2.066469, 102.783096)
	AddCameraShot(0.926756, -0.228578, -0.289446, -0.071390, -60.819584, -2.117482, 96.400620)
	AddCameraShot(0.873080, 0.134285, 0.463274, -0.071254, -52.071609, -8.430746, 67.122437)
	AddCameraShot(0.773398, -0.022789, -0.633236, -0.018659, -32.738083, -7.379394, 81.508003)
	AddCameraShot(0.090190, 0.005601, -0.993994, 0.061733, -15.379695, -9.939115, 72.110054)
	AddCameraShot(0.971737, -0.118739, -0.202524, -0.024747, -16.591295, -1.371236, 147.933029)
	AddCameraShot(0.894918, 0.098682, -0.432560, 0.047698, -20.577391, -10.683214, 128.752563)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- create objective		   
	ctf = createOneFlagObjective{teamATTName = "rep", teamDEFName = "cis",
								 flagName = "1flag_flag", homeRegion = "1flag_capture2",
							     attCaptureRegion = "1flag_capture1", defCaptureRegion = "1flag_capture2"}
	
	-- start objective
	ctf:Start()

	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------

	EnableSPHeroRules()
end
