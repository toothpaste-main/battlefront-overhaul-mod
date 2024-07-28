--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objConquest  = import("objective_conquest_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomgcw_all_urban")
ScriptCB_DoFile("bomgcw_imp")

-- these variables do not change
local ATT = 1
local DEF = 2
-- alliance attacking (attacker is always #1)
local ALL = ATT
local IMP = DEF


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
		hints = 1280,
		obstacles = 768,
		redOmniLights = 64,
	
		-- sounds
		soundStream = 10,
		music = 33, 
		soundSpace = 22,
		
		-- units
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 12,
		
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
	ReadDataFile("dc:sound\\bom.lvl;bomgcw")
    
	
	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------
    
    ReadDataFile("sound\\cor.lvl;cor1gcw")
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- alliance
	local ALL_HERO = "all_hero_luke_jedi"
	
	-- empire
	local IMP_HERO = "imp_hero_emperor"
	
    
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
    
	-- alliance
    ReadDataFile("SIDE\\all.lvl",
				 ALL_HERO)
                
	-- empire
	ReadDataFile("SIDE\\imp.lvl",
				 IMP_HERO)
    
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_fly_assault_DOME",
				 "rep_fly_gunship_DOME")
				
    -- cis
	ReadDataFile("SIDE\\cis.lvl",
				 "cis_fly_droidfighter_DOME")
				 
	-- turrets
    ReadDataFile("SIDE\\tur.lvl", 
    			 "tur_bldg_laser")          
     
	 
    ------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------

	-- alliance
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
		-- alliance
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
	
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
	}
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("cor\\cor1.lvl", "cor1_Conquest")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- misc
		mapNorthAngle = 180,
		
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}
	

	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "gcw_music")
	OpenAudioStream("sound\\cor.lvl", "cor1")
    OpenAudioStream("sound\\cor.lvl", "cor1")
	
	-- music
	SetAmbientMusic(ALL, 1.0, "all_cor_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_cor_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_cor_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_cor_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_cor_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_cor_amb_end", 2,1)
	
	-- game over song
	SetVictoryMusic(ALL, "all_cor_amb_victory")
    SetDefeatMusic (ALL, "all_cor_amb_defeat")
    SetVictoryMusic(IMP, "imp_cor_amb_victory")
    SetDefeatMusic (IMP, "imp_cor_amb_defeat")


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
    
	-- create and start objective	
	objConquest:initConquest{
		cps = {"cp1", "cp2", "cp3", "cp4", "cp5", "cp6"}
	}
	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
	
	EnableSPHeroRules()
 end
