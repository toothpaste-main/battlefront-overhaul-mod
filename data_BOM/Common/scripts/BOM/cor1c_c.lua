--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- This is the Campaign Script for JEDI TEMPLE: KNIGHTFALL, map name COR1C_C (Designer: P. Baker)

-- load the gametype script
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")     
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveTDM")  
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("setup_teams") 
ScriptCB_SetGameRules("campaign")

-- load BOM constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bom_cw_ep3") 
 
ATT = 1
DEF = 2
GAR = DEF		--the dorky looking naboo guards
RUN = 5		--the flag runners
BOS = 6		--the boss team (several powerful jedi)

AMB = 3	--the "JED" team is actually the extra henchmen jedis that surround the boss jedis at the last objective
REP = ATT	--the player is on the republic team

ambushTeamAMB = AMB
ambushTeamJED = AMB
ambushTeam3 = GAR
ambushcount1 = 1
ambushCount3 = 3
ambushCount4 = 4   
ambushCount5 = 5    
ambushCount10 = 10
ambushCount15 = 15
ambushCountBOS = 3


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
	
	-- constants
	local NUM_AIMER = 96		-- it's easier this way
	local NUM_ANIM = 512
	local NUM_CLOTH = 32		-- jedi and clones
	local NUM_CMD_FLY = 0
	local NUM_CMD_WLK = 0
	local NUM_FLAGS = 2
	local NUM_FLYER = 6
	local NUM_HINTS = 1024
	local NUM_HOVER = 0
	local NUM_JEDI = 24
	local NUM_LGHT = 128
	local NUM_MINE = 32			-- 4 mines * 8 rocketeers
	local NUM_MUSC = 33
	local NUM_OBST = 512
	local NUM_SND_SPA = 38
	local NUM_SND_STC = 0
	local NUM_SND_STM = 10
	local NUM_TENT = 0
	local NUM_TUR = 15
	local NUM_UNITS = 96		-- it's easier this way
	local NUM_WEAP = 256		-- more if locals and vehicles!
	local WALKER0 = 0
	local WALKER1 = 0
	local WALKER2 = 0
	local WALKER3 = 0
	
	-- walkers
	ClearWalkers()
	SetMemoryPoolSize("EntityWalker", -NUM_CMD_WLK)
	AddWalkerType(0, WALKER0)	-- droidekas (special case: 0 leg pairs)
	AddWalkerType(1, WALKER1)	-- 1x2 (1 pair of legs)
	AddWalkerType(2, WALKER2)	-- 2x2 (2 pairs of legs)
	AddWalkerType(3, WALKER3)	-- 3x2 (3 pairs of legs)
	
	-- memory pool
    SetMemoryPoolSize("Aimer", NUM_AIMER)
    SetMemoryPoolSize("AmmoCounter", NUM_WEAP)
	SetMemoryPoolSize("BaseHint", NUM_HINTS)					-- number of hint nodes
	SetMemoryPoolSize("CommandFlyer", NUM_CMD_FLY)				-- number of gunships
	SetMemoryPoolSize("CommandWalker", NUM_CMD_WLK)				-- number of ATTEs or ATATs
    SetMemoryPoolSize("EnergyBar", NUM_WEAP)
    SetMemoryPoolSize("EntityCloth", NUM_CLOTH)					-- 1 per clone marine
	SetMemoryPoolSize("EntityFlyer", NUM_FLYER)					-- to account for rocket upgrade (incrase for ATST)
    SetMemoryPoolSize("EntityHover", NUM_HOVER)					-- hover tanks/speeders
    SetMemoryPoolSize("EntityLight", NUM_LGHT)
	SetMemoryPoolSize("EntityMine", NUM_MINE)
	SetMemoryPoolSize("EntitySoundStatic", 0)	
    SetMemoryPoolSize("EntitySoundStream", NUM_SND_STC)
    SetMemoryPoolSize("FlagItem", NUM_FLAGS)					-- ctf
    SetMemoryPoolSize("MountedTurret", NUM_TUR)
    SetMemoryPoolSize("Music", NUM_MUSC)						-- applicable to campaigns
    SetMemoryPoolSize("Navigator", NUM_UNITS)
    SetMemoryPoolSize("Obstacle", NUM_OBST)
    SetMemoryPoolSize("PathFollower", NUM_UNITS)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", NUM_ANIM)
    SetMemoryPoolSize("SoundSpaceRegion", NUM_SND_SPA)
    SetMemoryPoolSize("TentacleSimulator", NUM_TENT)			-- 4 per wookiee
    SetMemoryPoolSize("TreeGridStack", 256)
	SetMemoryPoolSize("UnitAgent", NUM_UNITS)
	SetMemoryPoolSize("UnitController", NUM_UNITS)
    SetMemoryPoolSize("Weapon", NUM_WEAP)
	
	-- jedi
	SetMemoryPoolSize("Combo", NUM_JEDI*4)						-- should be ~ 2x number of jedi classes
    SetMemoryPoolSize("Combo::State", NUM_JEDI*4*12)			-- should be ~12x #Combo
    SetMemoryPoolSize("Combo::Transition", NUM_JEDI*4*12*2)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Condition", NUM_JEDI*4*12*2)		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize("Combo::Attack", NUM_JEDI*4*12)			-- should be ~8-12x #Combo
    SetMemoryPoolSize("Combo::DamageSample", NUM_JEDI*4*12*12)	-- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize("Combo::Deflect", NUM_JEDI*4) 			-- should be ~1x #combo
	
	
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
	local REP_HERO = "rep_hero_cloakedanakin"
	
	
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
				 "cis_fly_droidfighter_DOME")
	
	-- jedi
    ReadDataFile("SIDE\\jed.lvl",
				 "jed_knight_01",
				 "jed_knight_02",
				 "jed_knight_03",
				 "jed_knight_04",
				 "jed_master_01",
				 "jed_master_02",
				 "jed_master_03",
				 "jed_runner")
 
	-- guards
    ReadDataFile("SIDE\\gar.lvl",
				 "gar_inf_temple_soldier",
				 "gar_inf_temple_vanguard")
    
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
				 "tur_bldg_laser",
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
         
    
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    -- republic
	SetupTeams{
        rep = {
            team = REP,
            units = 32,
            reinforcements = 50,
            soldier		= {REP_SOLDIER_CLASS, 13, 16},
            assault		= {REP_ASSAULT_CLASS, 3, 4},
			sniper		= {REP_SNIPER_CLASS, 2, 4},
            engineer	= {REP_ENGINEER_CLASS, 3, 4},
            officer		= {REP_OFFICER_CLASS, 2, 4},
            special		= {REP_SPECIAL_CLASS, 2, 4},
			
			hero 		= {"rep_hero_cloakedanakin"},
        }
	}
	
	-- heroes
	SetHeroClass(REP, REP_HERO)
    
	-- guards
    SetupTeams{ 
        all = {
            team = GAR,
            units = 8,
            reinforcements = -1,
            soldier		= {"gar_inf_temple_soldier", 3, 4},
            assault 	= {"gar_inf_temple_vanguard", 3, 4},
            
        }
    }
    
	-- jedi knights
    SetupTeams{ 
        jedi = {
            team = AMB,
            units = 17,
            reinforcements = 0,
            soldier  	= {"jed_knight_01", 4, 6},
            assault  	= {"jed_knight_02", 4, 6},
            engineer  	= {"jed_knight_03", 3, 6},
            sniper 		= {"jed_knight_04", 2, 6},
        }
    }
    
	-- jedi masters
	SetupTeams{
    	bos = {
    		team = BOS,
    		units = ambushCountBOS,
    		reinforcements = 3,
    		soldier = {"jed_master_01", 1, 1},
    		assault = {"jed_master_02", 1, 1},
    		engineer = {"jed_master_03", 1, 1},
    	}
    }
	
	-- jedi master (for holocron)
    SetupTeams{ 
        bos = {
            team = RUN,
            units = 1,
            reinforcements = 0,
            soldier  = {"jed_master_03", 1, 1},
        }
    }
 
	-- establish good relations with the locals
    SetTeamAsEnemy(AMB, ATT)
    SetTeamAsEnemy(ATT, AMB)
    SetTeamAsEnemy(ATT, GAR)
    SetTeamAsEnemy(GAR, ATT)
    SetTeamAsEnemy(DEF, ATT)
    SetTeamAsEnemy(ATT, DEF)
    SetTeamAsEnemy(RUN, ATT)
    SetTeamAsEnemy(ATT, RUN)
    SetTeamAsEnemy(BOS, ATT)
    SetTeamAsEnemy(ATT, BOS)
    SetTeamAsFriend(AMB, DEF)
    SetTeamAsFriend(DEF, AMB)
    SetTeamAsFriend(AMB, GAR)
    SetTeamAsFriend(GAR, AMB)    
    SetTeamAsFriend(GAR, DEF)
    SetTeamAsFriend(DEF, GAR)    
    SetTeamAsFriend(RUN, DEF)
    SetTeamAsFriend(DEF, RUN)    
    SetTeamAsFriend(RUN, GAR)
    SetTeamAsFriend(GAR, RUN)    
    SetTeamAsFriend(RUN, AMB)
    SetTeamAsFriend(AMB, RUN)    
    SetTeamAsFriend(RUN, DEF)
    SetTeamAsFriend(DEF, RUN)    
    SetTeamAsFriend(BOS, DEF)
    SetTeamAsFriend(DEF, BOS)    
    SetTeamAsFriend(BOS, AMB)
    SetTeamAsFriend(AMB, BOS)    
    SetTeamAsFriend(BOS, GAR)
    SetTeamAsFriend(GAR, BOS)
    
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
	
	-- load gamemode
	ReadDataFile("cor\\cor1.lvl", "cor1_campaign")
	
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
	SetMapNorthAngle(0.0)
	--SetWorldExtents(0.0)
	
	-- idk what this does
	ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
	
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
	if AUTO_BLNC then EnableAIAutoBalance() end -- redistributes more AI onto losing team
	SetAIDifficulty(DIFF_PLAYER, DIFF_ENEMY)
	
	-- behavior
	--SetTeamAggressiveness(TEAM_NUM, 1.0)
	
	-- spawn delay
	SetSpawnDelay(1.0, 0.25)
	SetSpawnDelayTeam(2.0, 0.5, ATT)
    SetSpawnDelayTeam(10.0, 0.5, DEF)
    SetSpawnDelayTeam(10.0, 0.5, AMB)
    SetSpawnDelayTeam(10.0, 0.5, GAR)
	
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "cor_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 

   	-- out of bounds warnin
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(GAR, "allleaving")


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- open ambient streams
	OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\cor.lvl", "cor1")
    OpenAudioStream("sound\\cor.lvl", "cor1")

	-- game over song
    SetVictoryMusic(REP, "rep_cor_amb_victory")
    SetDefeatMusic (REP, "rep_cor_amb_defeat")
    --SetVictoryMusic(JED, "JED_cor_amb_victory")
    --SetDefeatMusic (JED, "JED_cor_amb_defeat")

	-- misc sound effects
    if NUM_BIRD_TYPE >= 1 then SetSoundEffect("BirdScatter", "birdsFlySeq1") end
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
function ScriptPostLoad ()
	
	SetAIDifficulty(2, -2, "medium")
    SetMapNorthAngle(180, 1)
	SetMissionEndMovie("ingame.mvs", "cormon02")
	DisableAIAutoBalance() 


	    AddDeathRegion("death")
	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")




	EnableSPScriptedHeroes()
	
	SetClassProperty ("rep_hero_cloakedanakin","MaxHealth",2200)
    
        
    SetProperty ("Library_CP","team",DEF)    
    SetProperty ("Consul_CP","team",DEF)
    SetProperty ("WarRoom_CP","team",DEF)
    SetProperty ("StarChamber_CP","team",DEF)
    SetProperty ("CommRoom_CP","team",DEF)
    SetProperty ("ExtraSpawn_CP","team",DEF)

    ScriptCB_PlayInGameMovie("ingame.mvs","cormon01")
    
    
    onfirstspawn = OnCharacterSpawn( 
        function(character)
            if IsCharacterHuman(character) then
            	ReleaseCharacterSpawn(onfirstspawn)
	        onfirstspawn = nil
            	objectives_timer = CreateTimer("objectives_timer")
            	SetTimerValue(objectives_timer, 2)
            	StartTimer(objectives_timer)
            	begin_objectives = OnTimerElapse(
            		function(timer)
	                	StartObjectives ()
	                	ScriptCB_EnableCommandPostVO(0)
	                	ScriptCB_SndPlaySound("cor_obj_26")
	               		ScriptCB_PlayInGameMusic("rep_cor_amb_obj1_2_explore")
	                	PlayAnimationFromTo("GunShipDropOff",0.0,20.5)
	                	
               		end,
               		objectives_timer
               		)
            end
        end
        )
    
    KillObject ("Library_CP")
    KillObject ("StarChamber_CP")
    KillObject ("WarRoom_CP")
    KillObject ("CommRoom_CP")
    KillObject ("ExtraSpawn_CP")
    
    SetProperty ("LibCase1","Team",0)
    SetProperty ("LibCase2","Team",0)
    SetProperty ("LibCase3","Team",0)
    SetProperty ("LibCase4","Team",0)
    
    BlockPlanningGraphArcs (1)
    BlockPlanningGraphArcs (2)
    BlockPlanningGraphArcs (3)
    BlockPlanningGraphArcs (4)
    BlockPlanningGraphArcs (5)
    BlockPlanningGraphArcs (6)


                        
    -- OBJECTIVE ONE Conquest Objective. Capture the Jedi Concil Chamber.-----------------------
       
    Objective1CP = CommandPost:New{name = "Consul_CP", hideCPs = false}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = GAR, text = "level.cor1.objectives.Campaign.1",
        popupText = "level.cor1.objectives.Campaign.1_popup"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function (self)
    
       	SetupAmbushTrigger("Minor_Hall_Entrance_Trigger", "Minor_Hall_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Consul_Room_Trigger", "Consul_Room_Trigger_SpawnPath", ambushCount5, ambushTeamAMB) 
		AICanCaptureCP("Consul_CP", ATT, false)
        SetProperty ("Consul_CP","Value_ATK_Republic",10)
        SetProperty ("Library_CP","Value_DEF_CIS",10)
        ConcilAmbushAMB = AddAIGoal (AMB, "Deathmatch",1)
        ATTgoal = AddAIGoal (ATT, "Defend", 100, "Consul_CP")
        
    end
    
    Objective1.OnComplete = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        SetProperty("Library_CP", "CaptureRegion","fake_cp")
        SetProperty("Library_CP", "value_ATK_CIS","0") 
        SetProperty("Library_CP", "value_DEF_Republic","0")
        SetProperty ("Library_CP","team",DEF)
        DeleteAIGoal(ConcilAmbushAMB)
        DeleteAIGoal(ATTgoal)
		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 30)
	    ShowMessageText("game.objectives.complete", ATT)
        
    end 

    -- Objective 2 A Goto Obj. Go to the Library.-------------------------------------------------
    
    Objective2a = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.cor1.objectives.campaign.2.a",
    popupText = "level.cor1.objectives.campaign.2.a_popup", regionName = "GotoEnd", mapIcon = "imp_icon"}

    Objective2a.OnStart = function (self)
    	ATTGotoLibrary = AddAIGoal (ATT,"Defend", 100, "Library_CP")
    	GARGotoLibrary = AddAIGoal (GAR,"Defend" ,100,"Library_CP")
    	SetProperty ("Consul_CP", "Team", 1)
    	SetProperty ("Consul_CP","SpawnPath", "CP3CampSpawnPath")
    	SetProperty ("Consul_CP", "CaptureRegion","fake_cp")
    	AICanCaptureCP("Consul_CP", DEF, false)

    	MapAddEntityMarker("Library_CP", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
    	RespawnObject ("Library_CP")
    	PlayAnimation("DoorOpen01")
        DisableBarriers("SideDoor1")
        DisableBarriers("MainLibraryDoors")
        UnblockPlanningGraphArcs (1)

    	RespawnObject ("ExtraSpawn_CP")
    	SetAIDamageThreshold("LibCase1", 1)
    	SetAIDamageThreshold("LibCase2", 1)
    	SetAIDamageThreshold("LibCase3", 1)
    	SetAIDamageThreshold("LibCase4", 1)
    	
    	SetProperty ("LibCase1","CurHealth",999999)
    	SetProperty ("LibCase2","CurHealth",999999)
    	SetProperty ("LibCase3","CurHealth",999999)
    	SetProperty ("LibCase4","CurHealth",999999)

    	SetProperty ("LibCase1","Team",1)
    	SetProperty ("LibCase2","Team",1)
    	SetProperty ("LibCase3","Team",1)
    	SetProperty ("LibCase4","Team",1)
        
        --KillObject ("Veranda_CP")
        ScriptCB_SndPlaySound("cor_obj_29")       
        
    end
    
    Objective2a.OnComplete = function (self)
    
    	
        MapRemoveEntityMarker("Library_CP")
        DeleteAIGoal(ATTGotoLibrary)
        DeleteAIGoal(GARGotoLibrary)
        OBJ2a_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ2a_ReinforcementCount + 30)
	    ShowMessageText("game.objectives.complete", ATT)

    end
    
    -- OBJECTIVE 2 C Defend the Library for 2 minutes while we search for the Holocron information----------------------------------------    

	Bookcases = TargetType:New{classname = "cor1_prop_librarystack", killLimit = 4, icon = nil}
   	Objective2c = ObjectiveAssault:New{teamATT = AMB , teamDEF = ATT, textDEF = "level.cor1.objectives.Campaign.2.c",
   										popupText = "level.cor1.objectives.campaign.2.c_popup", timeLimit = 120, timeLimitWinningTeam = ATT, AIGoalWeight = 0.0} -- should really rename the loc file
    Objective2c:AddTarget(Bookcases) 
    book_count = 4 
        
    Bookcases.OnDestroy = function(self, objectPtr)
        book_count = book_count - 1
        if book_count == 3 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.3", ATT)
    	elseif
    		book_count == 2 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.2", ATT)
    	elseif
    		book_count == 1 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.1", ATT)
    	elseif
        	book_count == 0 then 
        	MissionVictory (DEF)
        end
    end

    Objective2c.OnStart = function (self)
    	objectiveSequence.delayNextSetTime = 0.5
    	
    	
    	SetProperty ("LibCase1","CurHealth",11000)
    	SetProperty ("LibCase2","CurHealth",11000)
    	SetProperty ("LibCase3","CurHealth",11000)
    	SetProperty ("LibCase4","CurHealth",11000)

    	--ScriptCB_PlayInGameMovie("ingame.mvs", "cor1cam1") 
        MapRemoveEntityMarker("Library_CP")
        ScriptCB_SndPlaySound("cor_obj_30")
        ScriptCB_PlayInGameMusic("rep_cor_amb_defend_library_01")
    	RespawnObject ("ExtraSpawn_CP")
    	SetProperty ("ExtraSpawn_CP", "Team", GAR)
    	Ambush("JediLibraryDefenders", ambushCount10, AMB)

        LibraryAmbushTimer = CreateTimer("LibraryAmbushTimer")
        SetTimerValue(LibraryAmbushTimer, 60)
		StartTimer(LibraryAmbushTimer)
		LibraryAmbush = OnTimerElapse(
			function (timer) 
		    	LibraryAmbush2 = Ambush("SecondJediLibraryAmbush", ambushCount10, AMB)
		    	DestroyTimer(Timer)
			end,
			LibraryAmbushTimer
			)

    	--KillObject ("Consul_CP")
    	
    	
    	SetAIDamageThreshold("LibCase1",0)
    	SetAIDamageThreshold("LibCase2",0)
    	SetAIDamageThreshold("LibCase3",0)
    	SetAIDamageThreshold("LibCase4",0)

    	
    	SetProperty ("LibCase1","Team",1)
    	SetProperty ("LibCase2","Team",1)
    	SetProperty ("LibCase3","Team",1)
    	SetProperty ("LibCase4","Team",1)

    	MapAddEntityMarker("LibCase1", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase2", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase3", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase4", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	
    	
   		SetProperty("Library_CP","value_ATK_CIS",10) 
   		SetProperty("Library_CP","value_DEF_Republic",10)
    	SetProperty ("Library_CP","Team", ATT)
		
		AMBDeathmatch = AddAIGoal (AMB, "Deathmatch", 50)
		GARDeathmatch = AddAIGoal (GAR, "Deathmatch", 50)
		ATTLibraryDefend = AddAIGoal (ATT, "Defend",50, "Library_CP")
		ATTDeathmatch = AddAIGoal (ATT, "Deathmatch", 50)
		
		AMBLibraryDestroy1 = AddAIGoal (AMB, "Destroy", 50, "LibCase1")
		AMBLibraryDestroy2 = AddAIGoal (AMB, "Destroy", 50, "LibCase2")
        AMBLibraryDestroy3 = AddAIGoal (AMB, "Destroy", 50, "LibCase3")
        AMBLibraryDestroy4 = AddAIGoal (AMB, "Destroy", 50, "LibCase4")
        
        GARLibraryDestroy1 = AddAIGoal (GAR, "Destroy", 50, "LibCase1")
		GARLibraryDestroy2 = AddAIGoal (GAR, "Destroy", 50, "LibCase2")
        GARLibraryDestroy3 = AddAIGoal (GAR, "Destroy", 50, "LibCase3")
        GARLibraryDestroy4 = AddAIGoal (GAR, "Destroy", 50, "LibCase4")
    end    
    
    Objective2c.OnComplete = function (self)
    	if self.winningTeam == self.teamATT then
            BroadcastVoiceOver("cor_obj_24")
		end
	    
    	DeleteAIGoal(AMBLibraryDestroy1)
    	DeleteAIGoal(AMBLibraryDestroy2)
    	DeleteAIGoal(AMBLibraryDestroy3)
    	DeleteAIGoal(AMBLibraryDestroy4)
    	
		DeleteAIGoal(GARLibraryDestroy1)
    	DeleteAIGoal(GARLibraryDestroy2)
    	DeleteAIGoal(GARLibraryDestroy3)
    	DeleteAIGoal(GARLibraryDestroy4)
    	
    	DeleteAIGoal(AMBDeathmatch)
    	DeleteAIGoal(GARDeathmatch)
		DeleteAIGoal(ATTLibraryDefend)
    	DeleteAIGoal(ATTDeathmatch)
    	
		OBJ2c_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ2c_ReinforcementCount + 30)
	    
	    MapRemoveEntityMarker("LibCase1")
        MapRemoveEntityMarker("LibCase2")
        MapRemoveEntityMarker("LibCase3")
        MapRemoveEntityMarker("LibCase4")


    end

    -- Objective 4  - Retrieve Holocron from Comm. Room and return to Gunship

    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = GAR, captureLimit = 1, text = "level.cor1.objectives.campaign.4",
                                    popupText = "level.cor1.objectives.campaign.4_popup"}
    
    Objective4:AddFlag{name = "holocron1", captureRegion = "Veranda_Flag_Cap"}
                    
    Objective4.OnStart = function (self)
    
        Holocron1Spawn = GetPathPoint("holocronspawn_a", 0) 
        CreateEntity("cor1_item_holocron", Holocron1Spawn, "holocron1")
        SetProperty ("holocron1", "AllowAIPickUp", 0)
    
		holocron_capture_on = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					--ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
					MapAddEntityMarker("Veranda_CP", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
					ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")
				end
			end,
			"holocron"
		)
		
		holocron_capture_off = OnFlagDrop(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					MapRemoveEntityMarker("Veranda_CP")
					--ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)				
				end
			end,
			"holocron"
		)

     	objectiveSequence.delayNextSetTime = 0.5
		ScriptCB_SndPlaySound("cor_obj_33")
		ScriptCB_PlayInGameMusic("rep_cor_objComplete_01")
		
-- Music Timer -- 
 	music01Timer = CreateTimer("music01")
	SetTimerValue(music01Timer, 13.0)
		              
	StartTimer(music01Timer)
	OnTimerElapse(
		function(timer)
		ScriptCB_StopInGameMusic("rep_cor_objComplete_01")
		ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_retrieve_01")
		DestroyTimer(Timer)
	end,
	music01Timer
        )  	
 
		-- Open main star room and war room
		RespawnObject ("Veranda_CP")
		SetupAmbushTrigger("Library_SideDoor_Trigger","Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) --Library Side Door 1
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount4, AMB) -- Comm. Room
		SetupAmbushTrigger("GrandHall_Trigger_a", "GrandHall_Trigger_a_Path", ambushCount3, AMB)	
    	SetupAmbushTrigger("GrandHall_Trigger_b", "GrandHall_Trigger_b_Path", ambushCount3, AMB) 
		SetupAmbushTrigger("Mainframe_Jedi_ambush_trigger", "JediMainframeDefenders", ambushCount10, AMB)	

		--KillObject ("Library_CP")
		
        PlayAnimation ("DoorOpen02")        
        DisableBarriers("ComputerRoomDoor1")        
        UnblockPlanningGraphArcs (2)
        
        PlayAnimation("DoorOpen01")
        PlayAnimationFromTo("GunShipDropOff",20.5,30.0)
        
        
        AMBDeathmatch = AddAIGoal (AMB, "Deathmatch",100)
        GARDeathmatch = AddAIGoal (GAR, "Deathmatch",100)

    end
    
    Objective4.OnComplete = function (self)
		ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")

    	MapRemoveEntityMarker("Veranda_CP")
    
    	ReleaseFlagPickUp(holocron_capture_on)
		ReleaseFlagDrop(holocron_capture_off)

    	OBJ4_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ4_ReinforcementCount + 30)
	    
	    DeleteAIGoal(AMBDeathmatch)
	    DeleteAIGoal(GARDeathmatch)
	    
	    UnlockHeroForTeam(ATT)
	    ShowMessageText("game.objectives.complete", ATT)


	end

   
    -- OBJECTIVE 5 Catch the Jedi with the Flag----------------------------------------------------------------------
            
    Objective5 = ObjectiveCTF:New{teamATT = ATT, teamDEF = GAR, captureLimit = 1, text = "level.cor1.objectives.campaign.5",
        popupText = "level.cor1.objectives.campaign.5_popup", AIGoalWait = 0}

    Objective5:AddFlag{name = "holocron2",  captureRegion = "Veranda_Flag_Cap"}
                        
    Objective5.OnDrop = function(self, flag)
        SetProperty(flag.name, "AllowAIPickUp", 0)
    end
        
--    FlagJedi = GetTeamMember(RUN, 0)
--	FlagJediName = GetEntityName(FlagJedi)
--	
--	JediNextGoal = OnEnterRegion(
--		function(region, character)
--			DeleteAIGoal (RunnerGoal1) 
--	        RunnerGoal2 = AddAIGoal(RUN, "Defend",100,"Runner_Goto_2")
--		end,
--		"CP3CaptureCamp",
--		FlagJediName
--		)
                
    Objective5.OnStart = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        holocron_capture_on = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					--ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
					MapAddEntityMarker("Veranda_CP", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
					ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")
				else
					MapAddEntityMarker(GetCharacterUnit(carrier), "hud_target_flag_onscreen", 4.0, ATT, "YELLOW", true)
				end
			end,
			"holocron"
			)
		
		holocron_capture_off = OnFlagDrop(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					MapRemoveEntityMarker("Veranda_CP")
					--ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)				
				else
					MapRemoveEntityMarker(GetCharacterUnit(carrier))
				end
			end,
			"holocron"
			)
		
        ---ScriptCB_PlayInGameMovie("ingame.mvs", "cor1cam2") 
		RespawnObject ("WarRoom_CP")
        ScriptCB_SndPlaySound("cor_obj_35")
        ScriptCB_PlayInGameMusic("rep_cor_act_01")

        Ambush("flagrunner", 1, RUN)        
        
        DisableBarriers("StarChamberDoor1")
        DisableBarriers("StarChamberDoor2")
        DisableBarriers("WarRoomDoor1")
        DisableBarriers("WarRoomDoor2")
        DisableBarriers("WarRoomDoor3")
        
		UnblockPlanningGraphArcs (3)
		UnblockPlanningGraphArcs (4)
		
		PlayAnimation ("DoorOpen03") 
        PlayAnimation ("DoorOpen04") 

        SetProperty ("Consul_CP" ,"CaptureRegion", "fake_cp")
        KillObject ("tur_weap_built_gunturret")
        KillObject ("tur_weap_built_gunturret")
        KillObject ("tur_weap_built_gunturret")

        GARDeathmatchCatchJEdi = AddAIGoal (GAR, "Deathmatch", 100)
        AMBDeathmatch = AddAIGoal (AMB, "Deathmatch",100) 
	    REPCatchtheJedi = AddAIGoal (ATT,"Deathmatch",100)
	    REPCatchtheJediDeathmatch = AddAIGoal (ATT,"Deathmatch",1)
        RunnerGoal1 = AddAIGoal (RUN, "Defend",100,"WarRoom_CP") 

        
   		SetupAmbushTrigger("Library_SideDoor_Trigger","Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
		SetupAmbushTrigger("GrandHall_Trigger_a", "GrandHall_Trigger_a_Path", ambushCount3, ambushTeamAMB)	
    	SetupAmbushTrigger("GrandHall_Trigger_b", "GrandHall_Trigger_b_Path", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Balconey_Ambush", "Balconey_Ambush_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Star_Chamber_trigger", "Star_Chamber_trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("War_Room_trigger", "War_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Minor_Hall_Corner_Trigger", "Minor_Hall_Corner_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Library_SideDoor_Trigger", "Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Consul_Room_Trigger", "Consul_Room_Trigger_SpawnPath", ambushCount5, ambushTeamAMB) 
 
--        SetProperty ("Consul_CP","Team",AMB)
--        RespawnObject ("Consul_CP")
        --ScriptCB_SndPlaySound("cor_obj_16")

    end
            
    Objective5.OnComplete = function (self)
  		PlayAnimationFromTo("GunShipDropOff",30.0,35.0)
    	ReleaseFlagPickUp(holocron_capture_on)
		ReleaseFlagDrop(holocron_capture_off)
		MapRemoveEntityMarker("Veranda_CP")
		
        --KillObject ("Consul_CP")
        DeleteAIGoal(GARDeathmatchCatchJEdi)
        DeleteAIGoal(AMBDeathmatch)
        DeleteAIGoal(REPCatchtheJedi)
        DeleteAIGoal(REPCatchtheJediDeathmatch)
        DeleteAIGoal(RunnerGoal1)
        --DeleteAIGoal(RunnerGoal2)

        DeactivateRegion ("Star_Chamber_trigger")
        DeactivateRegion ("War_Room_trigger")
        DeactivateRegion ("Minor_Hall_Corner_Trigger")
        DeactivateRegion ("Coom_Room_Trigger")
        DeactivateRegion ("Library_SideDoor_Trigger")
        DeactivateRegion ("Balconey_Ambush")
        DeactivateRegion ("GrandHall_Trigger_a")
        DeactivateRegion ("GrandHall_Trigger_b")

        OBJ5_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ5_ReinforcementCount + 50)
	    ShowMessageText("game.objectives.complete", ATT)
	     

    end  
                      
    --OBJECTIVE 6 TDM - Kill all the Jedi.

    Objective6 = Objective:New{teamATT = ATT, teamDEF = DEF, text ="level.cor1.objectives.campaign.6",
        popupText = "level.cor1.objectives.campaign.6_popup"}
       
    Objective6.OnStart = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        
        SetProperty ("ExtraSpawn_CP", "Team", 3)
		
        ATTKillAllJedi = AddAIGoal (ATT, "deathmatch",100)
        GARKillAllJedi = AddAIGoal (GAR, "deathmatch",100)
        AMBiFinalStand = AddAIGoal (AMB, "Deathmatch", 100)
        BossGoal = AddAIGoal(BOS, "Deathmatch", 100)
        
        ScriptCB_SndPlaySound("cor_obj_38")
        ScriptCB_PlayInGameMusic("rep_cor_objComplete_02")
        
			
	-- Music Timer -- 
	 	music03Timer = CreateTimer("music03")
		SetTimerValue(music03Timer, 26.0)
			              
		StartTimer(music03Timer)
		OnTimerElapse(
			function(timer)
			ScriptCB_StopInGameMusic("rep_cor_objComplete_02")
			ScriptCB_PlayInGameMusic("rep_cor_act_01")
			DestroyTimer(timer)
		end,
		music03Timer
        ) 
        
        --SetReinforcementCount (ATT,100)
        
--        SetProperty ("Consul_CP","Team",AMB)
--        SetProperty ("Consul_CP","SpawnPath","HenchMen")
--        RespawnObject ("Consul_CP")
        SetReinforcementCount(AMB, -1)
        
        Ambush("SuperJedi", ambushCountBOS, BOS, 0.3)
       
        MapAddClassMarker("jed_master_01", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
        MapAddClassMarker("jed_master_02", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
        MapAddClassMarker("jed_master_03", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
       
        boss_count = ambushCountBOS
        Objective6KillBosses = OnObjectKillTeam( 
            function(object, killer) 
                if boss_count > 0 then
                    boss_count = boss_count - 1
                end 
                if boss_count == 2 then
               		ShowMessageText ("level.cor1.objectives.Campaign.mastercount.2", ATT)
                elseif boss_count == 1 then
                  	ShowMessageText ("level.cor1.objectives.Campaign.mastercount.1", ATT)
                elseif boss_count == 0 then
                    ScriptCB_SndPlaySound("cor_obj_21") 
                    Objective6:Complete(ATT) 
                    ReleaseObjectKill(Objective6KillBosses)
                end 
            end,
            BOS
        )       
    end
    
    Objective6.OnComplete = function(self)
        DeleteAIGoal(ATTKillAllJedi)
        DeleteAIGoal(GARKillAllJedi)
        DeleteAIGoal(AMBiFinalStand)
        DeleteAIGoal(BossGoal)
        if self.winningTeam == self.teamDEF then
            BroadcastVoiceOver("cor_obj_24")
        elseif self.winningTeam == self.teamATT then
        	ShowMessageText("game.objectives.complete", ATT)
            BroadcastVoiceOver("cor_obj_05")
        end
     end    


	----------------------------------------------------------------------------------------------------------------

    
         
end


----This creates the objective "container" and specifies order of objectives, and gets that shit running          
function StartObjectives() 
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0 }
	objectiveSequence:AddObjectiveSet(Objective1)
	objectiveSequence:AddObjectiveSet(Objective2a)
	objectiveSequence:AddObjectiveSet(Objective2c)
	objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:Start()
end
