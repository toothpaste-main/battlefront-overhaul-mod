--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams") 

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objHunt  = import("objective_hunt_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")

-- these variables do not change
local ATT = 1
local DEF = 2
-- cis attacking (attacker is always #1)
local REP = DEF
local CIS = ATT

-- ambient teams
local GAR_AMBIENT = 6
local GAR_AMBIENT_UNITS = 4
local CIS_AMBIENT = 7
local CIS_AMBIENT_UNITS = 4

    
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
	
	memorypool:init{
		-- map
		redOmniLights = 96,
		
		-- sounds
		soundStatic = 36, 
		soundStream = 1,
		
		-- units
		gungans = NAB2_NUM_GUNGANS,
		
		-- vehicles
		turrets = 9,
		droidekas = NAB2_MAX_SPECIAL,
		
		-- weapons
		mines = 0,
		portableTurrets = 0,
	}
	
	-- misc
	SetMemoryPoolSize("RedShadingState", 20)
	
	
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
	ReadDataFile("dc:sound\\bom.lvl;bomgcw")
    
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

    ReadDataFile("sound\\nab.lvl;nab2cw")
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- turrets
	ReadDataFile("SIDE\\tur.lvl", 
				 "tur_bldg_laser") 

	
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------
	
	-- cis
	ReadDataFile("dc:SIDE\\cis.lvl",
				 CIS_SOLDIER_CLASS,
				 CIS_SPECIAL_CLASS)
	
	-- naboo guard
	ReadDataFile("dc:SIDE\\gar.lvl",
				 NAB_OFFICER_CLASS)
	
	-- gungans
    ReadDataFile("dc:SIDE\\gun.lvl",
				 GUN_SOLDIER_CLASS,
				 GUN_ENGINEER_CLASS)


	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- setup teams
	SetupTeams{
		-- gungans
		gungan = {
			team = REP,
			units = NAB2_MAX_UNITS,
			reinforcements = -1,
			soldier		= {GUN_SOLDIER_CLASS, NAB2_NUM_GUNGANS/2},
			engineer  	= {GUN_ENGINEER_CLASS, NAB2_NUM_GUNGANS/2},
			officer  	= {NAB_OFFICER_CLASS},
		},
		-- cis
		cis = {
			team = CIS,
			units = NAB2_MAX_UNITS,
			reinforcements = -1,
			soldier  	= {CIS_SOLDIER_CLASS},
			special		= {CIS_SPECIAL_CLASS, NAB2_MIN_SPECIAL, NAB2_MAX_SPECIAL},
		}
	}
    
    TeamConfig:init{
		teamNameATT = "cis", teamNameDEF = "all",
	}
	
	-- naboo guard ambient team	
	SetTeamName(GAR_AMBIENT, "gar")
    SetUnitCount(GAR_AMBIENT, GAR_AMBIENT_UNITS)
    AddUnitClass(GAR_AMBIENT, "gar_inf_soldier_light")
	
	-- cis ambient team
	SetTeamName(CIS_AMBIENT, "cis")
    SetUnitCount(CIS_AMBIENT, CIS_AMBIENT_UNITS)
    AddUnitClass(CIS_AMBIENT, "cis_inf_bdroid_hunt")

	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("NAB\\nab2.lvl","naboo2_hunt")
	
	-- set mission properties
	missionProperties:init{		
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}
    
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\nab.lvl", "nab2")
    OpenAudioStream("sound\\nab.lvl", "nab2")
    OpenAudioStream("sound\\nab.lvl", "nab2_emt")

	-- music
    SetAmbientMusic(REP, 1.0, "rep_nab_amb_hunt", 0,1)
    SetAmbientMusic(CIS, 1.0, "cis_nab_amb_hunt", 0,1)

	-- game over song
    SetVictoryMusic(REP, "rep_nab_amb_victory")
    SetDefeatMusic (REP, "rep_nab_amb_defeat")
    SetVictoryMusic(CIS, "cis_nab_amb_victory")
    SetDefeatMusic (CIS, "cis_nab_amb_defeat")


	------------------------------------------------
	------------   CAMERA SHOTS   ------------------
	------------------------------------------------

	AddCameraShot(0.038177, -0.005598, -0.988683, -0.144973, -0.985535, 18.617458, -123.316505)
    AddCameraShot(0.993106, -0.109389, 0.041873, 0.004612, 6.576932, 24.040697, -25.576218)
    AddCameraShot(0.851509, -0.170480, 0.486202, 0.097342, 158.767715, 22.913860, -0.438658)
    AddCameraShot(0.957371, -0.129655, -0.255793, -0.034641, 136.933548, 20.207420, 99.608246)
    AddCameraShot(0.930364, -0.206197, 0.295979, 0.065598, 102.191856, 22.665434, 92.389435)
    AddCameraShot(0.997665, -0.068271, 0.002086, 0.000143, 88.042351, 13.869274, 93.643898)
    AddCameraShot(0.968900, -0.100622, 0.224862, 0.023352, 4.245263, 13.869274, 97.208542)
    AddCameraShot(0.007091, -0.000363, -0.998669, -0.051089, -1.309990, 16.247049, 15.925866)
    AddCameraShot(-0.274816, 0.042768, -0.949121, -0.147705, -55.505108, 25.990822, 86.987534)
    AddCameraShot(0.859651, -0.229225, 0.441156, 0.117634, -62.493008, 31.040747, 117.995369)
    AddCameraShot(0.703838, -0.055939, 0.705928, 0.056106, -120.401054, 23.573559, -15.484946)
    AddCameraShot(0.835474, -0.181318, -0.506954, -0.110021, -166.314774, 27.687098, -6.715797)
    AddCameraShot(0.327573, -0.024828, -0.941798, -0.071382, -109.700180, 15.415476, -84.413605)
    AddCameraShot(-0.400505, 0.030208, -0.913203, -0.068878, 82.372711, 15.415476, -42.439548)
end

function ScriptPostLoad()

	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------

	-- death regions
	AddDeathRegion("Waterfall")
	
	-- remove AI barriers
	DisableBarriers("cambar1")
    DisableBarriers("cambar2")
    DisableBarriers("cambar3")
	DisableBarriers("camveh")
    DisableBarriers("turbar1")
    DisableBarriers("turbar2")
    DisableBarriers("turbar3")
	
	
	------------------------------------------------
	------------   UNIT PROPERTIES  ----------------
	------------------------------------------------
	
	-- This is code for cycling rifleman models
	-- Author: KinetosImpetus
	-- Edited: ToothpasteMain

	-- constants
	local INTERVAL = AI_WAVE_SPAWN_DELAY
	local MAX_SKIN = 3
	
	-- create timer
	skintimer = CreateTimer("timeout")
	SetTimerValue(skintimer , INTERVAL)
	
	-- cycler
	local skin = 0
	OnTimerElapse(
		function(timer)
			-- asign skin
			if skin == 0 then
				SetClassProperty(NAB_OFFICER_CLASS, "GeometryName", "gar_inf_nabooguard_blue")
			elseif skin == 1 then
				SetClassProperty(NAB_OFFICER_CLASS, "GeometryName", "gar_inf_nabooguard_red")
			elseif skin == 2 then
				SetClassProperty(NAB_OFFICER_CLASS, "GeometryName", "gar_inf_nabooguard_yellow")
			end
			
			-- cycle skin
			skin = skin + 1
			if skin >= MAX_SKIN then
				skin = 0
			end
			
			-- reset timer
			SetTimerValue(skintimer , INTERVAL)
			StartTimer(skintimer)
		end,
		skintimer
	)

	-- start timer for first time
	StartTimer(skintimer)

	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------

	
	-- create and start objective
	objHunt:initHunt{
		pointsPerKillATT = objHunt.NAB2_PPK_ATT, pointsPerKillDEF = objHunt.NAB2_PPK_DEF
	}
	
	-- set ambient AI goal
	AddAIGoal(GAR_AMBIENT, "Deathmatch", 100)
	AddAIGoal(CIS_AMBIENT, "Deathmatch", 100)
end
