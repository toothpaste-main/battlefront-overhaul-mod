--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

-- load mission helper
ScriptCB_DoFile("import")
local memorypool = import("memorypool")
local missionProperties = import("mission_properties")
local TeamConfig = import("TeamConfig")
local objCTF = import("objective_ctf_helper")

-- load BOM assets
ScriptCB_DoFile("bom_cmn")

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
		hints = 512,
		redOmniLights = 96,
		
		-- sounds
		soundStatic = 30, 
		soundStream = 8,
		soundSpace = 50,
		
		-- units
		wookiees = MAX_SPECIAL,
		
		-- vehicles
		turrets = 1,
		
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
    
	ReadDataFile("sound\\dea.lvl;dea1gcw")
	
    
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


	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------

    -- setup teams
	TeamConfig:init{
		teamNameATT = "all", teamNameDEF = "imp",
		teamATTConfigID = "fleet", teamDEFConfigID = "fleet",
	}
	
	-- heroes
    SetHeroClass(ALL, ALL_HERO)    
    SetHeroClass(IMP, IMP_HERO)
	
	
	------------------------------------------------
	------------   MISSION PROPERTIES   ------------
	------------------------------------------------
	
	-- load game type map layer
	ReadDataFile("dea\\dea1.lvl", "dea1_CTF-SingleFlag")
	
	-- set mission properties
	missionProperties:init{
	-- map properties
		-- ceiling and floor limit
		mapCeiling = 72,
		
	-- ai properties
		-- view distance
		urbanEnvironment = true,	
	}
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- open ambient streams
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    OpenAudioStream("sound\\dea.lvl", "dea1")
    OpenAudioStream("sound\\dea.lvl", "dea1")

    -- music
    SetAmbientMusic(ALL, 1.0, "all_dea_amb_start", 0,1)
    SetAmbientMusic(ALL, 0.8, "all_dea_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_dea_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_dea_amb_start", 0,1)
    SetAmbientMusic(IMP, 0.8, "imp_dea_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_dea_amb_end", 2,1)
    
	-- game over song
	SetVictoryMusic(ALL, "all_dea_amb_victory")
    SetDefeatMusic (ALL, "all_dea_amb_defeat")
    SetVictoryMusic(IMP, "imp_dea_amb_victory")
    SetDefeatMusic (IMP, "imp_dea_amb_defeat")
	
	
	------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------

    AddCameraShot(-0.404895, 0.000992, -0.514360, -0.002240, -121.539894, 62.536297, -257.699493)
    AddCameraShot(0.040922, -0.004049, -0.994299, -0.098381, -103.729523, 55.546598, -225.360893)
    AddCameraShot(-1.0, 0.0, -0.514360, 0.0, -55.381485, 50.450953, -96.514324)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

    ------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
	AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
	
	-- remove AI barriers
	--DisableBarriers("dr_left")
    DisableBarriers("circle_bar1")
    DisableBarriers("circle_bar2")
	DisableBarriers("start_room_barrier")
	

	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------

	-- trash compactor
    TrashStuff()
    PlayAnimExtend()
    PlayAnimTakExtend()
    BlockPlanningGraphArcs("compactor")
	BlockPlanningGraphArcs("Connection41")    
    BlockPlanningGraphArcs("Connection115")
    OnObjectKillName(CompactorConnectionOn, "grate01")
    
	-- retractable floor
	OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm")
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm")

    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak")
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak")
	
	-- lock the hangar doors
    --SetProperty("Dr-LeftMain", "IsLocked", 1)
    --SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
    
	
	------------------------------------------------
	------------   INITIALIZE OBJECTIVE   ----------
	------------------------------------------------
    
	-- create and start objective	   
	objCTF:initOneFlag{
		teamNameATT = "all", teamNameDEF = "imp",
		flagName = "flag", homeRegion = "Flag_Home",
		captureRegionATT = "Team2Cap", captureRegionDEF = "Team1Cap",
	}	
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
    
	EnableSPHeroRules()
end

function CompactorConnectionOn()
    UnblockPlanningGraphArcs ("compactor")
end
--START BRIDGEWORK!

-- OPEN
function PlayAnimExtend()
      PauseAnimation("bridgeclose");    
      RewindAnimation("bridgeopen");
      PlayAnimation("bridgeopen");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection122");
    DisableBarriers("BridgeBarrier");
    
end
-- CLOSE
function PlayAnimRetract()
      PauseAnimation("bridgeopen");
      RewindAnimation("bridgeclose");
      PlayAnimation("bridgeclose");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection122");
    EnableBarriers("BridgeBarrier");
      
end

--START BRIDGEWORK TAK!!!

-- OPEN
function PlayAnimTakExtend()
      PauseAnimation("TakBridgeOpen");  
      RewindAnimation("TakBridgeClose");
      PlayAnimation("TakBridgeClose");
        
    -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection128");
    DisableBarriers("Barrier222");
    
end
-- CLOSE
function PlayAnimTakRetract()
      PauseAnimation("TakBridgeClose");
      RewindAnimation("TakBridgeOpen");
      PlayAnimation("TakBridgeOpen");
            
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection128");
    EnableBarriers("Barrier222");
      
end


function TrashStuff()

    trash_open = 1
    trash_closed = 0
    
    trash_timer = CreateTimer("trash_timer")
    SetTimerValue(trash_timer, 7)
    StartTimer(trash_timer)
    trash_death = OnTimerElapse(
        function(timer)
            if trash_open == 1 then
                AddDeathRegion("deathregion")
                SetTimerValue(trash_timer, 5)
                StartTimer(trash_timer)
                trash_closed = 1
                trash_open = 0
                print("death region added")
            
            elseif trash_closed == 1 then
                RemoveRegion("deathregion")
                SetTimerValue(trash_timer, 15)
                StartTimer(trash_timer)
                print("death region removed")
                trash_closed = 0
                trash_open = 1
            end
        end,
        trash_timer
        )
end
