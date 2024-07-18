--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams") 

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bom_ctf")
ScriptCB_DoFile("bom_memorypool")
ScriptCB_DoFile("bomcw_ep3") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- cis attacking (attacker is always #1)
local REP = DEF
local CIS = ATT


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
		hints = 1280,
		obstacles = 768,
		redOmniLights = 64,
	
		-- sounds
		soundStream = 10,
		music = 33, 
		soundSpace = 22,
		
		-- units
		cloths = MAX_OFFICER + MAX_SNIPER,
		
		-- vehicles
		turrets = 12,
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
 
    ReadDataFile("sound\\cor.lvl;cor1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	local REP_HERO = "rep_hero_macewindu"
	
	-- cis
	local CIS_HERO = "cis_hero_darthmaul"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
	ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_fly_assault_DOME",
				 "rep_fly_gunship_DOME")
	
	-- cis
	ReadDataFile("SIDE\\cis.lvl",
				 CIS_HERO,
				 "cis_fly_droidfighter_DOME")
    
	-- turrets
	ReadDataFile("SIDE\\tur.lvl", 
				 "tur_bldg_laser") 
	

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
    

	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 25
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode map layer
	ReadDataFile("cor\\cor1.lvl", "cor1_CTF")
	
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
	SetMapNorthAngle(180, 1)
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
	local URBAN_ENV = "true"
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

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\cor.lvl", "cor1")
    OpenAudioStream("sound\\cor.lvl", "cor1")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_cor_amb_start", 0,1)
    SetAmbientMusic(REP, 0.9, "rep_cor_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1, "rep_cor_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_cor_amb_start", 0,1)
    SetAmbientMusic(CIS, 0.9, "cis_cor_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1, "cis_cor_amb_end",2,1)

	-- game over song
    SetVictoryMusic(REP, "rep_cor_amb_victory")
    SetDefeatMusic (REP, "rep_cor_amb_defeat")
    SetVictoryMusic(CIS, "cis_cor_amb_victory")
    SetDefeatMusic (CIS, "cis_cor_amb_defeat")

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
	
	AddCameraShot(0.419938, 0.002235, -0.907537, 0.004830, -15.639358, 5.499980, -176.911179)
	AddCameraShot(0.994506, 0.104463, -0.006739, 0.000708, 1.745251, 5.499980, -118.700668)
	AddCameraShot(0.008929, -0.001103, -0.992423, -0.122538, 1.366768, 16.818106, -114.422173)
	AddCameraShot(0.761751, -0.117873, -0.629565, -0.097419, 59.861904, 16.818106, -81.607773)
	AddCameraShot(0.717110, -0.013583, 0.696703, 0.013197, 98.053314, 11.354497, -85.857857)
	AddCameraShot(0.360958, -0.001053, -0.932577, -0.002721, 69.017578, 18.145807, -56.992413)
	AddCameraShot(-0.385976, 0.014031, -0.921793, -0.033508, 93.111061, 18.145807, -20.164375)
	AddCameraShot(0.695468, -0.129569, -0.694823, -0.129448, 27.284357, 18.145807, -12.377695)
	AddCameraShot(0.009002, -0.000795, -0.996084, -0.087945, 1.931320, 13.356332, -16.410583)
	AddCameraShot(0.947720, -0.145318, 0.280814, 0.043058, 11.650738, 16.955814, 28.359180)
	AddCameraShot(0.686380, -0.127550, 0.703919, 0.130810, -30.096384, 11.152356, -63.235146)
	AddCameraShot(0.937945, -0.108408, 0.327224, 0.037821, -43.701199, 8.756138, -49.974789)
	AddCameraShot(0.531236, -0.079466, -0.834207, -0.124787, -62.491230, 10.305247, -120.102989)
	AddCameraShot(0.452286, -0.179031, -0.812390, -0.321572, -50.015198, 15.394646, -114.879379)
	AddCameraShot(0.927563, -0.243751, 0.273918, 0.071982, 26.149965, 26.947924, -46.834148)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	------------------------------------------------
	------------   INITIALIZE LIBRARY   ------------
	------------------------------------------------

	-- set bookcase max health
	SetProperty ("LibCase1","MaxHealth",1000)
	SetProperty ("LibCase2","MaxHealth",1000)
	SetProperty ("LibCase3","MaxHealth",1000)
	SetProperty ("LibCase4","MaxHealth",1000)
	SetProperty ("LibCase5","MaxHealth",1000)
	SetProperty ("LibCase6","MaxHealth",1000)
	SetProperty ("LibCase7","MaxHealth",1000)
	SetProperty ("LibCase8","MaxHealth",1000)
	SetProperty ("LibCase9","MaxHealth",1000)
	SetProperty ("LibCase10","MaxHealth",1000)
	SetProperty ("LibCase11","MaxHealth",1000)
	SetProperty ("LibCase12","MaxHealth",1000)
	SetProperty ("LibCase13","MaxHealth",1000)
	SetProperty ("LibCase14","MaxHealth",1000)

	-- set bookcase health
	SetProperty ("LibCase1","CurHealth",1000)
	SetProperty ("LibCase2","CurHealth",1000)
	SetProperty ("LibCase3","CurHealth",1000)
	SetProperty ("LibCase4","CurHealth",1000)
	SetProperty ("LibCase5","CurHealth",1000)
	SetProperty ("LibCase6","CurHealth",1000)
	SetProperty ("LibCase7","CurHealth",1000)
	SetProperty ("LibCase8","CurHealth",1000)
	SetProperty ("LibCase9","CurHealth",1000)
	SetProperty ("LibCase10","CurHealth",1000)
	SetProperty ("LibCase11","CurHealth",1000)
	SetProperty ("LibCase12","CurHealth",1000)
	SetProperty ("LibCase13","CurHealth",1000)
	SetProperty ("LibCase14","CurHealth",1000)

	-- open doors
	PlayAnimation("DoorOpen01")
	PlayAnimation("DoorOpen02")

   ------------------------------------------------
	------------   OUT OF BOUNDS  ------------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("death")
	AddDeathRegion("death1")
	AddDeathRegion("death2")
	AddDeathRegion("death3")
	AddDeathRegion("death4")
	AddDeathRegion("DeathRegion1")

	-- remove AI barriers	
	DisableBarriers("ComputerRoomDoor1")
	DisableBarriers("MainLibraryDoors")
	DisableBarriers("SideDoor1")
	DisableBarriers("SideDoor2")
	DisableBarriers("SIdeDoor3")
	DisableBarriers("StarChamberDoor1")
	DisableBarriers("StarChamberDoor2")
	DisableBarriers("WarRoomDoor1")
	DisableBarriers("WarRoomDoor2")
	DisableBarriers("WarRoomDoor3") 

	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
	
	-- define flag geometry
	setFlagGeometry{repFlagName = "flag2", cisFlagName = "flag1"}

	-- create objective
	ctf = createCTFObjective{teamATTName = "cis", teamDEFName = "rep",
							 repHomeRegion = "Team2FlagCapture", repCaptureRegion = "Team1FlagCapture",
							 cisHomeRegion = "Team1FlagCapture", cisCaptureRegion = "Team2FlagCapture"}
		
	-- start objective
    ctf:Start()
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------

    EnableSPHeroRules()
end
