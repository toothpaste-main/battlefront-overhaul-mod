    --
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("setup_teams")


-- load BBP constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bom_cw_ep3_jungle") 

-- these variables do not change
local ATT = 1
local DEF = 2
-- republic attacking (attacker is always #1)
local REP = ATT
local CIS = DEF

local CIS2 = 4
local CIS2_UNITS = 8

local ACK1 = 3
local ACK1_UNITS = nil

local ACK2 = 5
local ACK2_UNITS = 4


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
	local NUM_CMD_WLK = 1
	local NUM_FLAGS = 0
	local NUM_FLYER = 6			-- to account for rocket upgrade
	local NUM_HINTS = 1024
	local NUM_HOVER = 4
	local NUM_JEDI = 2
	local NUM_LGHT = 33
	local NUM_MINE = 32			-- 4 mines * 8 rocketeers
	local NUM_MUSC = 39
	local NUM_OBST = 512
	local NUM_SND_SPA = 0
	local NUM_SND_STC = 0
	local NUM_SND_STM = 1
	local NUM_TENT = 0
	local NUM_TUR = 7
	local NUM_UNITS = 96		-- it's easier this way
	local NUM_WEAP = 256		-- more if locals and vehicles!
	local WALKER0 = 0
	local WALKER1 = 0
	local WALKER2 = 3
	local WALKER3 = 1
	
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
	SetMemoryPoolSize("AcklayData", 6)
	
	
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
	
    ReadDataFile("sound\\fel.lvl;fel1cw")

	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------
	
	-- republic
	local REP_HERO = "rep_hero_aalya"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------
	
	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 "rep_walk_atte")
	
	-- cis
		
    ReadDataFile("SIDE\\cis.lvl",
				 "cis_tread_snailtank")

	-- acklay
    ReadDataFile("SIDE\\geo.lvl",
				 "geo_inf_acklay")
    
	-- turrets
   	ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_recoilless_fel_auto")


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
				 CIS_OFFICER_CLASS)
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    SetupTeams{
		-- republic
        rep = {
            team = REP,
            units = 18,
            reinforcements = 40,
            soldier		= {REP_SOLDIER_CLASS, 10},
            assault		= {REP_ASSAULT_CLASS, 3},
			sniper		= {REP_SNIPER_CLASS, 3},
            engineer	= {REP_ENGINEER_CLASS, 3},
            officer		= {REP_OFFICER_CLASS, 3},
            special		= {REP_SPECIAL_CLASS, 3},
        },
		-- cis
        cis = {
            team = CIS,
            units = 10,
            reinforcements = -1,
            soldier		= {CIS_SOLDIER_CLASS, 5},
            assault		= {CIS_ASSAULT_CLASS, 5},
        }
    }
    
	-- heroes
    SetHeroClass(REP, REP_HERO)


	-- acklay
	SetTeamName(ACK1, "acklay")
	SetTeamName(ACK2, "acklay")
	SetUnitCount(ACK2, ACK2_UNITS)
	SetReinforcementCount(ACK2, -1)
	AddUnitClass(ACK2, "geo_inf_acklay", ACK2_UNITS)
	
	-- cis ambush
	SetTeamName(CIS2, "cis")
	SetUnitCount(CIS2, CIS2_UNITS)
	SetReinforcementCount(CIS2, -1)
	AddUnitClass(CIS2, CIS_SNIPER_CLASS, 3)
	AddUnitClass(CIS2, CIS_ENGINEER_CLASS, 2)
	AddUnitClass(CIS2, CIS_OFFICER_CLASS, 3)
	
	
	-- establish good relations with the locals
	SetTeamAsEnemy(ACK1, ATT)
	SetTeamAsEnemy(ACK1, DEF)
	SetTeamAsEnemy(ATT, ACK1)
	SetTeamAsEnemy(DEF, ACK1)
	SetTeamAsEnemy(CIS2, ATT)
	SetTeamAsFriend(CIS2, DEF)
	SetTeamAsEnemy(ATT, CIS2)
	SetTeamAsFriend(DEF, CIS2) 
	SetTeamAsEnemy(ACK2, ATT)
	SetTeamAsEnemy(ATT, ACK2)


	------------------------------------------------
	------------   LEVEL PROPERTIES   --------------
	------------------------------------------------
	
	-- constants
	local MAP_CEILING = 55
	local MAP_CEILING_AI = MAP_CEILING
	local MAP_FLOOR = 0
	local MAP_FLOOR_AI = MAP_FLOOR
	local MIN_FLOCK_HEIGHT = 90.0
	local NUM_BIRD_TYPES = 1		-- 1 to 2 birds, -1 dragons
	local NUM_FISH_TYPES = 1		-- 1 fish
	
	-- load gamemode
	ReadDataFile("fel\\fel1.lvl", "fel1_campaign")
	
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
	local VIEW_MULTIPLIER = 0.65-- -1 for default
	
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "fel_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 
    
    -- winning/losing announcement
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
  
    -- out of bounds warning
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
    
    -- open ambient streams
    OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\fel.lvl", "fel1")
    OpenAudioStream("sound\\fel.lvl", "fel1")
    
    -- game over song
    SetVictoryMusic(ALL, "all_fel_amb_victory")
    SetDefeatMusic (ALL, "all_fel_amb_defeat")
    SetVictoryMusic(IMP, "imp_fel_amb_victory")
    SetDefeatMusic (IMP, "imp_fel_amb_defeat")
   
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

    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)
end


-- PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()   
	
	SetAIDifficulty(1, -5, "medium")
	SetMissionEndMovie("ingame.mvs", "felmon02")
	AICanCaptureCP("CP1", 5, false)
	AICanCaptureCP("CP1", DEF, false)
	ScriptCB_SetGameRules("campaign")
	--SetProperty("ATTE", "Team", 0)
	--Set Turrets to team 0 until turret objective
	SetProperty("turret1", "Team", 0)
	SetProperty("turret2", "Team", 0)
	SetProperty("turret3", "Team", 0)
	SetProperty("turret4", "Team", 0)
	SetProperty("turret5", "Team", 0)
	SetProperty("turret1", "CurHealth", 1e+37)
	SetProperty("turret2", "CurHealth", 1e+37)
	SetProperty("turret3", "CurHealth", 1e+37)
	SetProperty("turret4", "CurHealth", 1e+37)
	SetProperty("turret5", "CurHealth", 1e+37)
	SetAIDamageThreshold("turret1", 0.5)
	SetAIDamageThreshold("turret2", 0.5)
	SetAIDamageThreshold("turret3", 0.5)
	SetAIDamageThreshold("turret4", 0.5)
	SetAIDamageThreshold("turret5", 0.5)
	ScriptCB_PlayInGameMovie("ingame.mvs", "felmon01")
	ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	--This delays the objectives until the player spawns
    onfirstspawn = OnCharacterSpawn(
	        function(character)
	            if IsCharacterHuman(character) then
	                ReleaseCharacterSpawn(onfirstspawn)
	                onfirstspawn = nil
	                
	                ScriptCB_PlayInGameMusic("rep_fel_amb_obj1_3_explore")
	                onfirstspawn = nil
	                start_timer = CreateTimer("start_timer")
	                SetTimerValue(start_timer, 2)
	                StartTimer(start_timer)
	                begin_objectives = OnTimerElapse(
                	function()
                		BeginObjectives()
                		ReleaseTimerElapse(begin_objectives)
                		begin_objectives = nil
                	end,
                	start_timer
                	)
	            end
	            
	        end)
	        
	        
    Objective1 = ObjectiveGoto:New{TeamATT = ATT, TeamDEF = DEF, text = "level.fel1.objectives.campaign.1", popupText = "level.fel1.objectives.campaign.1_popup", regionName = "goto1", timeLimit = 30, timeLimitWinningTeam = DEF}
    
    Objective1.OnStart = function(self)
    	MapAddEntityMarker("atte_busted", "hud_objective_icon_circle", 3.0, 1, "YELLOW", true)
    	
--    	SetClassProperty("rep_walk_atte", "MaxSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "MaxStrafeSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "MaxTurnSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "StoppedTurnSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "Acceleration", 0)
    	SetProperty("atte_busted", "MaxHealth", 5000000)
    	SetProperty("atte_busted", "CurHealth", 4000000)
    	ScriptCB_EnableCommandPostVO(0)
    	BroadcastVoiceOver("FEL_obj_05", ATT)
    	
    	vo2_timer = CreateTimer("vo2_timer")
    	SetTimerValue(vo2_timer, 1)
    	StartTimer(vo2_timer)
    	vo3_timer = CreateTimer("vo3_timer")
    	vo4_timer = CreateTimer("vo4_timer")
    	
    	playvo2 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_09", ATT)
    			ReleaseTimerElapse(playvo2)
    			playvo2 = nil
    			
    			SetTimerValue(vo3_timer, 9)
    			StartTimer(vo3_timer)
    		end,
    		vo2_timer
    		)
    		
    	playvo3 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_10", ATT)
    			ReleaseTimerElapse(playvo3)
    			playvo3 = nil
    			
    			SetTimerValue(vo4_timer, 3)
    			StartTimer(vo4_timer)
    		end,
    		vo3_timer
    		)
    		
    	playvo4 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_obj_06", ATT)
    			ReleaseTimerElapse(playvo4)
    			playvo4 = nil
    		end,
    		vo4_timer
    		)
    			
    	
    		
    end
    
    Objective1.OnComplete = function(self, winningTeam)
    	if winningTeam == ATT then
    		ReleaseTimerElapse(playvo2)
    		playvo2 = nil
    		ReleaseTimerElapse(playvo3)
    		playvo3 = nil
    		ReleaseTimerElapse(playvo4)
    		playvo4 = nil
    		
	    	MapRemoveEntityMarker("atte_busted")
	    	BroadcastVoiceOver("FEL_inf_11", ATT)
	    	vo6_timer = CreateTimer("vo6_timer")
	    	SetTimerValue(vo6_timer, 3)
	    	StartTimer(vo6_timer)
	    	ShowMessageText("game.objectives.complete", ATT)
    	end
    	
    	if winningTeam == DEF then
    	end
    	
    	
    	
    end
    
    --Objective 2
    acklay_count = 6
    Objective2 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.fel1.objectives.campaign.2", popupText = "level.fel1.objectives.campaign.2_popup", AIGoalWeight = 0}
	
	Objective2.OnStart = function(self) 
	

	
		BlockPlanningGraphArcs (1)
		--AI goals for objecjective 2
		att_obj2_defend = AddAIGoal(ATT, "Defend", 100, "atte_busted")
		--acklay_obj2_attack = AddAIGoal(3, "Destroy", 100, "ATTE")
		BroadcastVoiceOver("FEL_obj_07", ATT)
		vo7_timer = CreateTimer("vo7_timer")
		SetTimerValue(vo7_timer, 3)
    	StartTimer(vo7_timer)
    	vo8_timer = CreateTimer("vo8_timer") 
    	
    	playvo7 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_12", ATT)
    			ReleaseTimerElapse(playvo7)
    			playvo7 = nil
    			
    			SetTimerValue(vo8_timer, 3)
    			StartTimer(vo8_timer)
    		end,
    		vo7_timer
    		)
    		
    	playvo8 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_obj_08", ATT)
    			ReleaseTimerElapse(playvo8)
    			playvo8 = nil
    		end,
    		vo8_timer
    		)
    		
--		SetProperty("acklay_cp1", "Team", 5)
--		SetProperty("acklay_cp2", "Team", 3)
--		SetProperty("acklay_cp3", "Team", 3)
		
		--ambush in the acklay
		Ambush("acklay_spawn", 3, 5, 0.5)
		MapAddClassMarker("geo_inf_acklay", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
		
		acklay_aigoal = AddAIGoal(5, "Defend", 100, "atte_busted")
		ReleaseTimerElapse(acklayspawn)
		acklayspawn = nil
		
		--MapAddClassMarker("geo_walk_acklay", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true)
		Objective2AcklayKill = OnObjectKillClass( 
			function(object, killer)
				if killer and IsCharacterHuman(killer) then
					acklay_count = acklay_count - 1 
					
					if acklay_count > 0 then						
						ShowMessageText("level.fel1.objectives.campaign.2-" .. acklay_count, 1)				 
					elseif acklay_count == 0 then
						Objective2:Complete(ATT)
						ReleaseObjectKill(Objective2AcklayKill)
						Objective2AcklayKill = nil
					end
					if acklay_count == 3 then
						Ambush("acklay_spawn", 3, 5, 0.5)
					elseif acklay_count == 2 then
						BroadcastVoiceOver("FEL_obj_15", ATT)
					elseif acklay_count == 1 then
						BroadcastVoiceOver("FEL_obj_16", ATT)
					end
					
				end
			end,
			"geo_inf_acklay"
		) 
		
	
		
--		acklayKillSpawn2 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp2", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn2)
--				end
--			end,
--			"acklay2"
--			)
--		acklayKillSpawn1 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp1", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn1)
--				end
--			end,
--			"acklay1"
--			)
--		acklayKillSpawn0 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp3", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn0)
--				end
--			end,
--			"acklay3"
--			)
--		
--		acklay1_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay1 damage threshold")
--				SetAIDamageThreshold("acklay1", 0.2)
--				ReleaseObjectInit(acklay1_dmgthreshold)
--			end,
--			"acklay1"
--			) 
--		acklay2_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay2 damage threshold")
--				SetAIDamageThreshold("acklay2", 0.2)
--				ReleaseObjectInit(acklay2_dmgthreshold)
--			end,
--			"acklay2"
--			)
--		acklay3_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay3 damage threshold")
--				SetAIDamageThreshold("acklay3", 0.2)
--				ReleaseObjectInit(acklay3_dmgthreshold)
--			end,
--			"acklay3"
--			)
                 
	end
	
	Objective2.OnComplete = function(self)
		RespawnObject("CP6")
		ShowMessageText("game.objectives.complete", ATT)
		UnblockPlanningGraphArcs (1)
		RespawnObject("CP4")
		MapRemoveClassMarker("geo_inf_acklay")
		BroadcastVoiceOver("FEL_obj_09", ATT)
		ScriptCB_StopInGameMusic("rep_fel_amb_obj1_3_explore")
		ScriptCB_PlayInGameMusic("rep_fel_ObjComplete_01")
		 -- Music Timer -- 
		 music01Timer = CreateTimer("music01")
		SetTimerValue(music01Timer, 17.0)
				              
			StartTimer(music01Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("rep_fel_ObjComplete_01")
				ScriptCB_PlayInGameMusic("rep_fel_amb_defendATTE")
				DestroyTimer(timer)
			end,
			music01Timer
                         )		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)

		
	end
	
	--Objective3
	
	ATTE = Target:New{name = "atte_busted"}    
    Objective3 = ObjectiveAssault:New{teamATT = DEF, teamDEF = ATT, 
                    textDEF = "level.fel1.objectives.campaign.3",
                    textATT = "blah",
                    popupText = "level.fel1.objectives.campaign.3_popup", 
                    timeLimit = 120, timeLimitWinningTeam = ATT, AIGoalWeight = 0}
    Objective3:AddTarget(ATTE)
   
    Objective3.OnStart = function(self)
    	SetProperty("atte_busted", "MaxHealth", 50000)
    	SetProperty("atte_busted", "CurHealth", 40000)
    	def_obj3_attack = AddAIGoal(DEF, "Destroy", 60, "atte_busted")
    	def_obj3_dm = AddAIGoal(DEF, "Deathmatch", 40)
    	MapAddEntityMarker("atte_busted", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
    	DisableBarriers("acklay1")
    	DisableBarriers("acklay2")
    	DisableBarriers("acklay3")
    end
    
    Objective3.OnComplete = function(self, winningTeam)
    
    	if winningTeam == ATT then
    		SetProperty("atte_busted", "MaxHealth", 500000000)
    		SetProperty("atte_busted", "CurHealth", 400000000)
    		ShowMessageText("game.objectives.complete", ATT)
	    	DeleteAIGoal(def_obj3_attack)
	    	DeleteAIGoal(def_obj3_dm)
	    	DeleteAIGoal(att_obj2_defend)
	    	PowerCellSpawn = GetPathPoint("powercell_spawn", 0)
	    	CreateEntity("fel1_flag_powercell", PowerCellSpawn, "powercell") --Spawns the Holocron.
	    	--SetProperty("powercell", "GeometryName", "fel1_icon_powercell")
	    	--SetProperty("powercell", "CarriedGeometryName", "fel1_icon_powercell")
	    	SetProperty("powercell", "AllowAIPickUp", 0)
	    	UnlockHeroForTeam(1)
	    	BroadcastVoiceOver("FEL_obj_10", ATT)

	    	ATTReinforcementCount = GetReinforcementCount(ATT)
			SetReinforcementCount(ATT, ATTReinforcementCount + 15)
			MapRemoveEntityMarker("atte_busted")
		elseif winningTeam == DEF then
			BroadcastVoiceOver("FEL_inf_05", ATT)
		end
    	
    end
    
    --Objective 4
    
    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.fel1.objectives.campaign.4", popupText = "level.fel1.objectives.campaign.4_popup", AIGoalWeight = 0}
	Objective4:AddFlag{name = "powercell", homeRegion = "", captureRegion = "powercell_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				mapIcon = "flag_icon", mapIconScale = 2.0}
	
	Objective4.OnStart = function(self)
		
		Ambush("acklay_spawn_powercell", 1, 5)
		Ambush("ctf_ambush", 8, 4)
		team4_ctf_goal = AddAIGoal(4, "Defend", 100, "obj4_defend")
		BroadcastVoiceOver("FEL_obj_11", ATT)
		ScriptCB_PlayInGameMusic("rep_fel_amb_power_retrieve")
		--SetProperty("cis_spawn1", "SpawnPath", "cis_spawn3")
		--SetProperty("cis_spawn1", "AllyPath", "GeoSpawn13")
		
		--This swaps the busted ATTE in for the functional one when the player picks up the power cell
		atte_swap = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					KillObject("atte_busted")
					SetProperty("atte_cp", "Team", 1)
					ReleaseFlagPickUp(atte_swap)
					atte_swap = nil
					SetProperty("ATTE", "DisableTime", 1e+37)
				
				end
			end,
			"powercell"
			)
			
		powercell_capture_on = OnFlagPickUp(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("atte_marker", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
			ScriptCB_PlayInGameMusic("Rep_fel_amb_power_return")	
			end
		end,
		"powercell"
		)
		
		powercell_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapRemoveEntityMarker("atte_marker")				
			end
		end,
		"powercell"
		)
		
		att_obj4_dm = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj4_dm = AddAIGoal(DEF, "Deathmatch", 100)
	end
	
	Objective4.OnComplete = function(self)
		SetProperty("snail_cp", "Team", 2)
		ShowMessageText("game.objectives.complete", ATT)
		MapRemoveEntityMarker("atte_marker")
		
		ReleaseFlagPickUp(powercell_capture_on)
		powercell_capture_on = nil
		ReleaseFlagDrop(powercell_capture_off)
		powercell_capture_off = nil
		
		DeleteAIGoal(team4_ctf_goal)
		DeleteAIGoal(att_obj4_dm)
		DeleteAIGoal(def_obj4_dm)
		SetProperty("ATTE", "DisableTime", 0)
		SetProperty("ATTE", "Team", 1)
		BroadcastVoiceOver("FEL_OBJ_20", ATT)
		ScriptCB_PlayInGameMusic("rep_fel_act_01")
		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)
		BatchChangeTeams(4, DEF, 8)
		SetProperty("CP4", "SpawnPath", "c_cp2_spawn")
		
	end
	
	--Objective 5a
	
	Turret1 = Target:New{name = "turret1"}
	Turret2 = Target:New{name = "turret2"}
	Turret3 = Target:New{name = "turret3"}
	Turret4 = Target:New{name = "turret4"}
	Turret5 = Target:New{name = "turret5"}
	
	Objective5a = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
							  text = "level.fel1.objectives.campaign.5a", popupText = "level.fel1.objectives.campaign.5a_popup", AIGoalWeight = 0}
	Objective5a:AddTarget(Turret1)
	Objective5a:AddTarget(Turret2)
	Objective5a:AddTarget(Turret3)
	Objective5a:AddTarget(Turret4)
	Objective5a:AddTarget(Turret5)
	
	Objective5a.OnStart = function(self)
		SetProperty("turret1", "Team", 2)
		SetProperty("turret2", "Team", 2)
		SetProperty("turret3", "Team", 2)
		SetProperty("turret4", "Team", 2)
		SetProperty("turret5", "Team", 2)
		SetProperty("turret1", "CurHealth", 3000)
		SetProperty("turret2", "CurHealth", 3000)
		SetProperty("turret3", "CurHealth", 3000)
		SetProperty("turret4", "CurHealth", 3000)
		SetProperty("turret5", "CurHealth", 3000)
		Ambush("acklay_spawn_turret", 3, 5)
		BroadcastVoiceOver("FEL_obj_12", ATT)
		att_obj5_destroy1 = AddAIGoal(ATT, "Destroy", 10, "turret1")
		att_obj5_destroy2 = AddAIGoal(ATT, "Destroy", 10, "turret2")
		att_obj5_destroy3 = AddAIGoal(ATT, "Destroy", 10, "turret3")
		att_obj5_destroy4 = AddAIGoal(ATT, "Destroy", 60)
		att_obj5_dm = AddAIGoal(ATT, "Deathmatch", 10, "turret1")
		def_obj5_defend1 = AddAIGoal(DEF, "Defend", 25, "turret1")
		def_obj5_defend2 = AddAIGoal(DEF, "Defend", 25, "turret2")
		def_obj5_defend3 = AddAIGoal(DEF, "Defend", 25, "turret3")
		def_obj5_defend4 = AddAIGoal(DEF, "Defend", 25, "turret4")
		
		--Setup callback to show update messages when turrets are killed
		turret_count = 5
		TurretKill = OnObjectKillClass( 
			function(object, killer)
				if killer and IsCharacterHuman(killer) then
					turret_count = turret_count - 1 
					
					if turret_count > 0 then						
						ShowMessageText("level.fel1.objectives.campaign.5a-" .. turret_count, 1)				 
					end					
				end
			end,
			"tur_bldg_recoilless_fel_auto"
			) 
	end
	
	Objective5a.OnComplete = function(self)
		ReleaseObjectKill(TurretKill)
		TurretKill = nil
		
		ShowMessageText("game.objectives.complete", ATT)
		DeleteAIGoal(att_obj5_destroy1)
		DeleteAIGoal(att_obj5_destroy2)
		DeleteAIGoal(att_obj5_destroy3)
		DeleteAIGoal(att_obj5_destroy4)
		DeleteAIGoal(att_obj5_dm)
		DeleteAIGoal(def_obj5_defend1)
		DeleteAIGoal(def_obj5_defend2)
		DeleteAIGoal(def_obj5_defend3)
		DeleteAIGoal(def_obj5_defend4)
		--RespawnObject("CP2")
		--AICanCaptureCP("CP2", ATT, false)
		--BroadcastVoiceOver("FEL_obj_19", ATT)
		BroadcastVoiceOver("FEL_obj_14", ATT) --set back to 13
		--ATTReinforcementCount = GetReinforcementCount(ATT)
		--SetReinforcementCount(ATT, ATTReinforcementCount + 15)

	end
		
    --Objective 5
    
    Objective5CP = CommandPost:New{name = "CP2"}
	Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.fel1.objectives.campaign.5", popupText = "level.fel1.objectives.campaign.5_popup", AIGoalWeight = 0}
	Objective5:AddCommandPost(Objective5CP)
	
	Objective5.OnStart = function(self)
		def_obj5_defend = AddAIGoal(DEF, "Defend", 100, "CP2")
		att_obj5_capture = AddAIGoal(ATT, "Defend", 100, "CP2")
	end
	
	Objective5.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)
		DeleteAIGoal(def_obj5_defend)
		DeleteAIGoal(att_obj5_capture)
	end
	--Objective6			
	--This is the actual objective setup
    Objective6 = ObjectiveTDM:New{teamATT = ATT, teamDEF = DEF, 
                           textATT = "level.fel1.objectives.campaign.6",
                           popupText = "level.fel1.objectives.campaign.6_popup",
                           textDEF = "Kill Everyone!", AIGoalWeight = 0}
	
	Objective6.OnStart = function(self)
		SetReinforcementCount(DEF, 20)
		att_obj6goal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj6goal = AddAIGoal(DEF, "Deathmatch", 100)
	end
	
	Objective6.OnComplete = function(self)
		BroadcastVoiceOver("FEL_obj_14", ATT)
    end
    
    EnableSPScriptedHeroes()


    
    
end


function BeginObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 7.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5a)
    --objectiveSequence:AddObjectiveSet(Objective5)
    --objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:Start()
end
