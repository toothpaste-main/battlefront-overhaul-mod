--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

-- load BBP constants
ScriptCB_DoFile("bom_cmn")
ScriptCB_DoFile("bomgcw_all_fleet")
ScriptCB_DoFile("bomgcw_imp_fleet")

-- these variables do not change
local ATT = 1
local DEF = 2
-- empire attacking (attacker is always #1)
local ALL = DEF
local IMP = ATT

hangar_ambush = 5
snipers = 6
flag_rebel = 7


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
	local NUM_CLOTH = 32		-- it's easier this way
	local NUM_CMD_FLY = 0
	local NUM_CMD_WLK = 0
	local NUM_FLAGS = 1
	local NUM_FLYER = 6			-- to account for rocket upgrade
	local NUM_HINTS = 1024
	local NUM_HOVER = 0
	local NUM_JEDI = 2
	local NUM_LGHT = 128
	local NUM_MINE = 32			-- 4 mines * 8 rocketeers
	local NUM_MUSC = 0
	local NUM_OBST = 512
	local NUM_SND_SPA = 50
	local NUM_SND_STC = 30
	local NUM_SND_STM = 0
	local NUM_TENT = 4*MAX_SPECIAL
	local NUM_TUR = 0
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
	SetMemoryPoolSize("EntitySoundStatic", NUM_SND_STC)	
    SetMemoryPoolSize("EntitySoundStream", NUM_SND_STM)
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
	
	-- misc
	--SetMemoryPoolSize ("RedOmniLight", 130)
	
	
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
	
	-- empire
    ReadDataFile("SIDE\\imp.lvl",
				 "imp_fly_ai_trooptrans")
				 
	-- jedi
	ReadDataFile("SIDE\\jed.lvl",
                 "jed_knight_01")
				 
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
                 "tur_bldg_mortar")
    
    
	------------------------------------------------
	------------   LOAD DLC ASSETS   ---------------
	------------------------------------------------	
    
	-- rebels
	ReadDataFile("dc:SIDE\\all.lvl",
				 ALL_SOLDIER_CLASS,
				 ALL_ASSAULT_CLASS,
				 ALL_SNIPER_CLASS,
				 ALL_ENGINEER_CLASS,
				 ALL_OFFICER_CLASS)
	
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
            team = 8,
            units = MAX_UNITS,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier		= {ALL_SOLDIER_CLASS, 4},
            assault		= {ALL_ASSAULT_CLASS, 1},
			engineer	= {ALL_ENGINEER_CLASS, 2},
            officer		= {ALL_OFFICER_CLASS, 1},
        },
		-- empire
        imp = {
            team = 8,
            units = 25,
            reinforcements = DEFAULT_REINFORCEMENTS,
            soldier  	= {IMP_SOLDIER_CLASS, 10},
            assault  	= {IMP_ASSAULT_CLASS, 2},
            sniper   	= {IMP_SNIPER_CLASS, 2},
			engineer 	= {IMP_ENGINEER_CLASS, 2},
            officer 	= {IMP_OFFICER_CLASS, 2},
            special 	= {IMP_SPECIAL_CLASS, 2},
        }
    }

	AllowAISpawn(IMP, false)

	-- local stats
	SetUnitCount (3, 11)
	AddUnitClass (3, "imp_inf_rifleman", 11)
	
	-- rebel ambush team
	SetUnitCount(hangar_ambush, 6)
	AddUnitClass(hangar_ambush, "all_inf_rifleman_fleet", 3)
	AddUnitClass(hangar_ambush, "all_inf_wookiee", 1)
	AddUnitClass(hangar_ambush, "all_inf_engineer_fleet", 1)
	AddUnitClass(hangar_ambush, "all_inf_rocketeer_fleet", 1)
	SetReinforcementCount(hangar_ambush, -1)
	
	-- sniper team
	SetUnitCount(snipers, 2)
	AddUnitClass(snipers, "all_inf_sniper_fleet", 2)
	SetReinforcementCount(snipers, -1)
	
	-- flag rebel team
	SetUnitCount(flag_rebel, 1)
	AddUnitClass(flag_rebel, "all_inf_rifleman_fleet", 2)
	SetReinforcementCount(flag_rebel, -1)

	-- jedi
	AddUnitClass(4, "jed_knight_01", 4)
	SetUnitCount(4, 1)
	SetReinforcementCount(4, -1)
	
	-- establish good relations with the locals
	SetTeamAsEnemy(4, 1)
	SetTeamAsEnemy(1, 4)
	SetTeamAsFriend(4, 2)
	SetTeamAsFriend(2, 4)
	SetTeamAsFriend(4, 6)
	SetTeamAsFriend(6, 4)    
    SetTeamAsEnemy(hangar_ambush, IMP)
    SetTeamAsFriend(hangar_ambush, ALL)
    SetTeamAsFriend(ALL, hangar_ambush)
	SetTeamAsEnemy(snipers, IMP)
    SetTeamAsFriend(snipers, ALL)
    SetTeamAsFriend(ALL, snipers)	
	
	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 72
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 0		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 0		-- 1 fish
	
	-- load gamemode
	ReadDataFile("dea\\dea1.lvl", "dea1_Campaign")
	
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "dea_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)   

	-- low reinforcement warning
    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")


	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
    
	-- open ambient streams
	OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
	
	-- game over song
	SetVictoryMusic(ALL, "all_dea_amb_victory")
    SetDefeatMusic (ALL, "all_dea_amb_defeat")
    SetVictoryMusic(IMP, "imp_dea_amb_victory")
    SetDefeatMusic (IMP, "imp_dea_amb_defeat")
	
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

    AddCameraShot(-0.404895, 0.000992, -0.514360, -0.002240, -121.539894, 62.536297, -257.699493)
    AddCameraShot(0.040922, -0.004049, -0.994299, -0.098381, -103.729523, 55.546598, -225.360893)
    AddCameraShot(-1.0, 0.0, -0.514360, 0.0, -55.381485, 50.450953, -96.514324)
end


function ScriptPostLoad()

    
    SetAIDifficulty(0, -1, "medium")
    TrashStuff();
    SetMissionEndMovie("ingame.mvs", "deamon02")
    BlockPlanningGraphArcs("compactor")
    BlockPlanningGraphArcs("Connection146")
    ScriptCB_SetGameRules("campaign")
    ScriptCB_PlayInGameMovie("ingame.mvs", "deamon01")


    SetProperty("CAM_CP2", "Value_ATK_Empire", 10)
    SetProperty("CAM_CP2", "Value_DEF_Alliance", 10)
    
    SetClassProperty("jed_knight_01", "MaxHealth", 1500)
    SetClassProperty("jed_knight_01", "CurHealth", 1500)
    SetClassProperty("jed_knight_01", "AddHealth", 0.0)
--      SetProperty("trans02", "MaxHealth", 150)
--      SetProperty("trans02", "CurHealth", 150)

    
    --delete the other alliance CPs for the first couple of objectives.
    KillObject("CAM_CP4")
    KillObject("CAM_CP5")
    KillObject("CAM_CP2")
    KillObject("CAM_CP7")
    KillObject("CAM_CP1")
    KillObject("CAM_CP8")
    SetProperty("Panel-Tak", "CurHealth", 0)
    
    SetProperty("obj6_shuttle", "MaxHealth", 1e+37)
    SetProperty("obj6_shuttle", "CurHealth", 1e+37)
    
	AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
    
    ActivateRegion("cam_cp2_capture")
    ActivateRegion("obj6_ambush2")
    ActivateRegion("obj6_ambush3")
    
    --Sets CPs un-capturable by AI
    
    AICanCaptureCP("CAM_CP2", ATT, false)
    
    SetProperty("Dr-LeftMain", "IsLocked", 1)
    SetProperty("dea1_prop_door_blast0", "IsLocked", 1)
    
    --close the door by the initial spawn
    SetProperty("dea1_prop_door0", "IsLocked", 1)
    BlockPlanningGraphArcs("start_room_door")
    EnableBarriers("start_room_barrier")
    
    DisableBarriers("dr_left")
    BlockPlanningGraphArcs("Connection41")    
    BlockPlanningGraphArcs("Connection115")

    ActivateRegion("transtrip")
    KillObject("grate01")
    
    SetProperty("Trans01", "CurHealth", 1e+37)
    
        

    
    EntityFlyerInitAsLanded("trans01")
    --    EntityFlyerInitAsFlying("trans02")

    PlayAnimation("incoming01");
    
    landingTimer = CreateTimer("landingTimer")
    SetTimerValue(landingTimer, 8)
    StartTimer(landingTimer)
    
    shuttle_land = OnTimerElapse(
        function(timer)
            DestroyTimer(landingTimer)
            PauseAnimation("incoming01");
            RewindAnimation("incoming03");
            PlayAnimation("incoming03");
            ReleaseTimerElapse(shuttle_land)
        end,
        landingTimer
        )
    PlayAnimExtend();
    PlayAnimTakExtend();

    OnObjectRespawnName(PlayAnimExtend, "Panel-Chasm");
    OnObjectKillName(PlayAnimRetract, "Panel-Chasm");
    OnObjectRespawnName(PlayAnimTakExtend, "Panel-Tak");
    OnObjectKillName(PlayAnimTakRetract, "Panel-Tak");
    OnObjectKillName(CompactorConnectionOn, "grate01")
    EnableSPScriptedHeroes()
    
    --Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ScriptCB_PlayInGameMusic("imp_dea_amb_obj1_2_explore")
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                start_timer = CreateTimer("start_timer")
                SetTimerValue(start_timer, 3)
                StartTimer(start_timer)
                begin_objectives = OnTimerElapse(
                    function()
                        BeginObjectives()
                        ReleaseTimerElapse(begin_objectives)
                    end,
                    start_timer
                    )
             end
        end)

            
    --This is objective 1  Go to the hangar
    Objective1 = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.1", popupText = "level.dea1.objectives.campaign.1_popup", AIGoalWeight = 0, regionName = "transreg"}

    Objective1.OnStart = function(self)
    MapAddEntityMarker("Trans01", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    ScriptCB_EnableCommandPostVO(0)
    --ScriptCB_SndPlaySound("DEA_obj_10")
    SetProperty("Panel-Chasm", "CurHealth", 0)
    BroadcastVoiceOver("DEA_obj_27", ATT)
    PlayAnimRetract()
    
    
    end

    Objective1.OnComplete = function(self)
        MapRemoveEntityMarker("Trans01")
--      ScriptCB_SndPlaySound("DEA_obj_11")
        SetProperty("imp_base", "SpawnPath", "CAM_CP1Spawn")
        --BatchChangeTeams(3, ATT, 3)
        AllowAISpawn(ATT, true) 
        RespawnObject("CAM_CP1")
        SetProperty("CAM_CP1", "SpawnPath", "imp_base_spawn")
        ShowMessageText("game.objectives.complete", ATT)
        
        
        --KillObject("all_spawn")
        BroadcastVoiceOver("DEA_obj_28", ATT)
    end             

    --Objective 2 - Defend the Hangar
    Objective2CP = CommandPost:New{name = "CAM_CP1"}
    Objective2 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, textATT = "blah", textDEF = "level.dea1.objectives.campaign.2", popupText = "level.dea1.objectives.campaign.2_popup", AIGoalWeight = 0, timeLimit = 120}--set back to 120 
    Objective2:AddCommandPost(Objective2CP)
    
    Objective2.OnStart = function(self)
        Ambush("defend_ambush", 3, 5)
        AddAIGoal(5, "Defend", 99999, "CAM_CP1")
        SetAIDamageThreshold("obj6_shuttle", 0.2)
        hangar_ambush_timer = CreateTimer("hangar_ambush_timer")
        SetTimerValue(hangar_ambush_timer, 45)
        StartTimer(hangar_ambush_timer)
        MapAddEntityMarker("CAM_CP1", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
        hangar_ambush_go = OnTimerElapse(
            function(timer)
                SetProperty("Dr-LeftMain", "IsLocked", 0)
                Ambush("hangar_ambush_spawn", 6, 5)
                --ShowMessageText("level.dea1.hangar_ambush", ATT)
                SetTimerValue(hangar_ambush_timer, 10)
                
                ReleaseTimerElapse(hangar_ambush_go)
                UnblockPlanningGraphArcs("Connection41")
                hangar_ambush_off = OnTimerElapse(
                    function(timer)
                        BlockPlanningGraphArcs("Connection41")
                        ReleaseTimerElapse(hangar_ambush_off)
                        SetProperty("Dr-LeftMain", "IsLocked", 1)
                    end,
                    hangar_ambush_timer
                    )
            end,
            hangar_ambush_timer
            )
        
        imp_base_spawnswitch_t = CreateTimer("imp_base_spawnswitch_t")
        SetTimerValue(imp_base_spawnswitch_t, 4)
        StartTimer(imp_base_spawnswitch_t)
        imp_base_spawnswitch = OnTimerElapse(
            function(timer)
                SetProperty("imp_base", "SpawnPath", "imp_base_spawn")
                ReleaseTimerElapse(imp_base_spawnswitch)
            end,
            imp_base_spawnswitch_t
            )
        AddAIGoal(ATT, "Defend", 9999, "CAM_CP1")
        -- tell the alliance to take over that CP
        AddAIGoal(DEF, "Conquest", 9999)
        SetProperty("cam_cp1", "Value_ATK_Alliance", 100)
        -- but not the other one, since you can't capture it
        SetProperty("imp_base", "Value_ATK_Alliance", 0)
        SetProperty("imp_base", "Value_DEF_Alliance", 0)
        -- and have these guys defend it
        SetProperty("cam_cp1", "Value_DEF_Empire", 100)
        SetProperty("imp_base", "Value_DEF_Empire", 0)
        SetProperty("cam_cp2", "Value_ATK_Empire", 0)
        
        SetProperty("CAM_CP2", "Value_DEF_Alliance", 0)
    
    end
    
    Objective2.OnComplete = function(self, winningTeam)
        if winningTeam == ATT then
            RespawnObject("CAM_CP2")
            MapRemoveEntityMarker("CAM_CP1")
            ClearAIGoals(ATT)
            ClearAIGoals(DEF)
            ClearAIGoals(5)
            ShowMessageText("game.objectives.complete", ATT)
            SetProperty("CAM_CP1", "Team", 1)
            AICanCaptureCP("CAM_CP1", DEF, false)
            AICanCaptureCP("CAM_CP1", 5, false)
            AICanCaptureCP("CAM_CP1", 6, false)
            AICanCaptureCP("CAM_CP1", 7, false)
            KillObject("imp_base")
            --Give player's team more reinforcements
            ATT_ReinforcementCount = GetReinforcementCount(ATT)
            SetReinforcementCount(ATT, ATT_ReinforcementCount + 15)
            BroadcastVoiceOver("DEA_obj_37", ATT)
            ScriptCB_PlayInGameMusic("imp_dea_objComplete_01")
            -- Music Timer -- 
         music01Timer = CreateTimer("music01")
        SetTimerValue(music01Timer, 15.0)
                              
            StartTimer(music01Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_dea_objComplete_01")
                ScriptCB_PlayInGameMusic("imp_dea_act_01")
                DestroyTimer(timer)
            end,
            music01Timer
        ) 
        end
    end
            
    --Objective 3 - Capture the Denention Block
    
    Objective3CP = CommandPost:New{name = "CAM_CP2"}
    Objective3 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.3", popupText = "level.dea1.objectives.campaign.3_popup", AIGoalWeight = 0}
    Objective3:AddCommandPost(Objective3CP)

    Objective3.OnStart = function(self)
        KillObject("all_spawn")
        BroadcastVoiceOver("DEA_obj_29", ATT)
        sniperspawn = OnEnterRegion(
            function()
                Ambush("sniper_spawn2", 2, 6)
                --ShowMessageText("rara", ATT)
                AddAIGoal(snipers, "Deathmatch", 9999)
                ReleaseEnterRegion(sniperspawn)
            end,
            "sniper_spawn2"
            )
        AddAIGoal(ATT, "Defend", 99999, "CAM_CP2")
        AddAIGoal(DEF, "Defend", 99999, "CAM_CP2")
    end
    
    Objective3.OnComplete = function(self)
        RespawnObject("all_spawn")
        SetProperty("all_spawn", "SpawnPath", "CAM_CP5Spawn")
        KillObject("CAM_CP1")
        SetProperty("CAM_CP5", "Team", 2)
        SetProperty("CAM_CP2", "Team", 1)
        AICanCaptureCP("CAM_CP5", ATT, false)
        AICanCaptureCP("CAM_CP2", DEF, false)
        AICanCaptureCP("CAM_CP2", 5, false)
        AICanCaptureCP("CAM_CP2", 6, false)
        AICanCaptureCP("CAM_CP2", 7, false)
        Ambush("obj4_ambush_spawn", 6, 5)
        --ShowMessageText("level.dea1.platform_ambush", ATT)
        
        --sets the geometry, and carried geometry
        
        Ambush("plans_spawn", 1, flag_rebel)
        
        --spawn the plans
        PlansSpawn = GetPathPoint("plans_spawn", 0) --gets the path point
        CreateEntity("dea_icon_disk", PlansSpawn, "plans") --spawns the flag
        
        MapAddEntityMarker(GetCharacterUnit(GetTeamMember(flag_rebel, 0)), "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
        --ShowMessageText("rara", ATT)
        
        ShowMessageText("game.objectives.complete", ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(ATT)
        BroadcastVoiceOver("DEA_obj_31", ATT)
        
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 15)
        
        
    end

    
    --Objective 4 - get the plans from that jerk
    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.dea1.objectives.campaign.4", popupText = "level.dea1.objectives.campaign.4_popup", AIGoalWeight = 0}
    Objective4:AddFlag{name = "plans", homeRegion = "", captureRegion = "planreturn01",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                mapIcon = "flag_icon", mapIconScale = 2.0}
    
    Objective4.OnStart = function(self)
        AddAIGoal(flag_rebel, "Destroy", 99999, "flagguy_defend")
        SetTeamAsEnemy(flag_rebel, IMP)
        SetTeamAsEnemy(IMP, flag_rebel)
        SetTeamAsFriend(flag_rebel, ALL)
        SetTeamAsFriend(ALL, flag_rebel)
        SetTeamAsFriend(flag_rebel, hangar_ambush)
        SetTeamAsFriend(hangar_ambush, flag_rebel)
        BroadcastVoiceOver("DEA_obj_30", ATT)
        AddAIGoal(ATT, "Deathmatch", 99999)
        AddAIGoal(DEF, "Deathmatch", 500)
        AddAIGoal(DEF, "Defend", 500, "CAM_CP2")
        --Ambush, send some dudes at the player for the beginning of this objective
        
        AddAIGoal(5, "Defend", 99999, "CAM_CP2")
        --set up markers for capture location
        plans_capture_on = OnFlagPickUp(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
                MapAddEntityMarker("CAM_CP2", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)               
            end
        end,
        "plans"
        )
        
        plans_capture_off = OnFlagDrop(
        function(flag, carrier)
            if IsCharacterHuman(carrier) then
                MapRemoveEntityMarker("CAM_CP2")
                ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)               
            end
        end,
        "plans"
        )
        
        --This makes the plans not pick-upable by AI after the first guy drops them
        plans_aipickup_off = OnFlagDrop(
        function(flag, carrier)
            if not IsCharacterHuman(carrier) then
                SetProperty("plans", "AllowAIPickUp", 0)
                ReleaseFlagDrop(plans_aipickup_off)             
            end
            --make sure there's no more marker on the dead guy
            MapRemoveEntityMarker(GetCharacterUnit(GetTeamMember(flag_rebel, 0)))
        end,
        "plans"
        )
    end
                
    Objective4.OnComplete = function (self)
        BroadcastVoiceOver("DEA_obj_38", ATT)
        ScriptCB_PlayInGameMusic("imp_dea_objComplete_02")
         -- Music Timer -- 
         music02Timer = CreateTimer("music02")
        SetTimerValue(music02Timer, 33.0)
                              
            StartTimer(music02Timer)
            OnTimerElapse(
                function(timer)
                ScriptCB_StopInGameMusic("imp_dea_objComplete_02")
                ScriptCB_PlayInGameMusic("imp_dea_amb_obj5_explore")
                DestroyTimer(timer)
            end,
            music02Timer
        ) 
        ReleaseFlagPickUp(plans_capture_on)
        ReleaseFlagDrop(plans_capture_off)
        ShowMessageText("game.objectives.complete", ATT)
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
        MapRemoveEntityMarker("CAM_CP2")
        
    end
    
    Objective5CP = CommandPost:New{name = "CAM_CP5"}
    Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.5", popupText = "level.dea1.objectives.campaign.5_popup", AIGoalWeight = 0}
    Objective5:AddCommandPost(Objective5CP)
    
    Objective5.OnStart = function(self)
        BroadcastVoiceOver("DEA_obj_17", ATT)
        KillObject("all_spawn")
        RespawnObject("CAM_CP5")
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(5)
        ClearAIGoals(6)
        ClearAIGoals(7)
        AddAIGoal(ATT, "Defend", 99999, "CAM_CP5")
        AddAIGoal(DEF, "Defend", 99999, "CAM_CP5")
        fire_control_ambush = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("fire_control_ambush_spawn", 4, 5)
                end
            end,
            "fire_control_ambush"
            )
    end
    
    Objective5.OnComplete = function(self)
        BroadcastVoiceOver("DEA_obj_39", ATT)
        KillObject("CAM_CP2")
        SetProperty("Dr-LeftMain", "IsLocked", 1)
        SetProperty("CAM_CP5", "Team", 1)
        SetProperty("dea1_prop_door_blast0", "IsLocked", 0)
        RespawnObject("CAM_CP7")
        --KillObject("CAM_CP5")
        AICanCaptureCP("CAM_CP5", DEF, false)
        --Give player's team more reinforcements
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10) 
        ShowMessageText("game.objectives.complete", ATT)    
    end
    

    --Objective6 - Destroy the Shuttle Before it takes off

    Shuttle = Target:New{name = "obj6_shuttle", killedByPlayer = true}
    
    Objective6 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                              text = "level.dea1.objectives.campaign.6", popupText = "level.dea1.objectives.campaign.6_popup", timeLimit = 180, timeLimitWinningTeam = DEF}
    Objective6:AddTarget(Shuttle)

    --This is objective 6  Go to the TIE Hangar
    
    Objective6.OnStart = function(self)
        BroadcastVoiceOver("DEA_obj_33", ATT)
        ScriptCB_PlayInGameMusic("imp_dea_immVict_01")
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        ClearAIGoals(5)
--      AddAIGoal(ATT, "Destroy", 99999, "obj6_shuttle")
--      AddAIGoal(DEF, "Defend", 99999, "obj6_shuttle")
        AddAIGoal(5, "Deathmatch", 999999)
        SetProperty("obj6_shuttle", "MaxHealth", 9000)
        SetProperty("obj6_shuttle", "CurHealth", 9000)
        SetProperty("obj6_shuttle", "Team", DEF)        --Very important that the shuttle is on the other team,
                                                        --since players can turn off friendly fire! - BradR
        Ambush("obj6_ambush1", 6, 5)
        --ShowMessageText("level.dea1.obj6_ambush1", ATT)
        obj6_ambush2 = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("obj6_ambush2", 6, 5)
                    --ShowMessageText("level.dea1.obj6_ambush2", ATT)
                    ReleaseEnterRegion(obj6_ambush2)
                end
            end,
            "obj6_ambush2"
            )
            
        obj6_ambush3 = OnEnterRegion(
            function(region, character)
                if IsCharacterHuman(character) then
                    Ambush("obj6_ambush3", 3, 5)
                    --ShowMessageText("level.dea1.obj6_ambush3", ATT)
                    ReleaseEnterRegion(obj6_ambush3)
                    RespawnObject("CAM_CP8")
                    KillObject("CAM_CP5")
                end
            end,
            "obj6_ambush3"
            )
        
    end
    
    Objective6.OnComplete = function(self, winningTeam)
    
        if winningTeam == ATT then
            BroadcastVoiceOver("DEA_obj_40", ATT)
                    -- add Jedi as a new unit
            --local characterindex = GetTeamMember(4, 0)
            --BatchChangeTeams(4, DEF, 1)
            --SetHeroClass(ALL, "jed_knight_01")
            --SelectCharacterClass(characterindex, "jed_knight_01")
            --SpawnCharacter(characterindex, GetPathPoint("jedi", 0)) 
            --Give player's team more reinforcements
            ATT_ReinforcementCount = GetReinforcementCount(ATT)
            SetReinforcementCount(ATT, ATT_ReinforcementCount + 5) 
            ShowMessageText("game.objectives.complete", ATT)
            
        elseif winningTeam == DEF then
            BroadcastVoiceOver("DEA_obj_34", ATT)
        end     
    end    

--This is objective 7  Destroy The Rebel Leader
    
    Objective7 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.dea1.objectives.campaign.7", popupText = "level.dea1.objectives.campaign.7_popup"}

    JediKiller = TargetType:New{classname = "jed_knight_01", killLimit = 1}
    Objective7:AddTarget(JediKiller)
    
    Objective7.OnStart = function(self)
    	Ambush("jedi", 1, 4, 0.5)
        jedigoal = AddAIGoal(4, "Defend", 100, "CAM_CP7")
        BroadcastVoiceOver("DEA_obj_19", ATT)
        UnblockPlanningGraphArcs("Connection115")
        SetProperty("CAM_CP7", "Value_ATK_Empire", 10)
        SetProperty("CAM_CP7", "Value_DEF_Alliance", 10)
        ClearAIGoals(ATT)
        ClearAIGoals(DEF)
        AddAIGoal(ATT, "Deathmatch", 99999)
        AddAIGoal(ATT, "Deathmatch", 99999)
    end
    
    Objective7.OnComplete = function(self, winningTeam)
        if winningTeam == ATT then
            ShowMessageText("game.objectives.complete", ATT)
            BroadcastVoiceOver("DEA_obj_36", ATT)
            BroadcastVoiceOver("DEA_obj_35", ATT)
        end
    end
    
    --Objective8        
    --This is the actual objective setup
    Objective8 = ObjectiveTDM:New{teamATT = ATT, teamDEF = DEF, 
                           textATT = "level.dea1.objectives.8",
                           textDEF = "Kill Everyone!"}
    
    Objective8.OnStart = function(self)
        SetReinforcementCount(DEF, 20)
        --ScriptCB_SndPlaySound("DEA_obj_23")
    end
    
    Objective8.OnComplete = function(self)
        
        --ScriptCB_SndPlaySound("DEA_obj_20")
    end

function BeginObjectives()
--This creates the objective "container" and specifies order of objectives, and gets that running           
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 11.5}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective7)
    --objectiveSequence:AddObjectiveSet(Objective8)
    objectiveSequence:Start()
end








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