--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM") 
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")
ScriptCB_SetGameRules("campaign")

-- load BOM constants
ScriptCB_DoFile("bom_cmn") 
ScriptCB_DoFile("bom_cw_ep3_marine") 

-- these variables do not change
ATT = 1
DEF = 2
-- REP attacking (attacker is always #1)
REP = ATT
CIS = DEF


-- ambush data
ambushTeam1 = 4
ambushCount1 = 3

ambushTeam2 = 5
ambushCount2 = 3

ambushTeam3 = 6
ambushCount3 = 8

CIS2 		= 7


 function ScriptPostLoad()
 
	------------------------------------------------
	------------   OUT OF BOUNDS   -----------------
	------------------------------------------------
	
	-- death regions
 	AddDeathRegion("deathregion")
	
	-- remove AI barriers
	DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
	DisableBarriers("dropship")
	
 	
 
	------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
 	DisableAIAutoBalance()
 	
 	SetAIDifficulty(3, -5, "medium")
 	SetAIDifficulty(1, 2, "hard")
 
	
	------------------------------------------------
	------------   MOVIES  -------------------------
	------------------------------------------------
 	
 	ScriptCB_PlayInGameMovie("ingame.mvs", "mygmon01")
	SetMissionEndMovie("ingame.mvs", "mygmon02")
	
	------------------------------------------------
	------------   MAP INTERACTION   ---------------
	------------------------------------------------
 
	-- activate ambush regions
    ActivateRegion("magnatrigger")
    ActivateRegion("solrush")
 
	-- set up ambush trigers
	-- SetupAmbushTrigger("region", "path", COUNT, TEAM)
    SetupAmbushTrigger("magnatrigger", "magnapath", ambushCount1, ambushTeam1)
    SetupAmbushTrigger("solrush", "solrush", ambushCount3, ambushTeam3)
	
	-- direct call to ambush
	--Ambush("path", COUNT, TEAM)
	
	-- set up dropship
	EntityFlyerInitAsLanded("repveh6")
	EntityFlyerTakeOff("repveh5")
	EntityFlyerTakeOff("repveh4")
	
	
	-- remove CP's used for later
 	KillObject("CP2")
 	KillObject("CP4")
 	KillObject("norun")
    
    BlockPlanningGraphArcs("incore")
    PlayAnimation("gunshipfly2")
	
	-- AI can't damage objects 
    SetAIDamageThreshold("autoturret1", 0.5)
    SetAIDamageThreshold("autoturret2", 0.5)
    SetAIDamageThreshold("autoturret3", 0.5)
    SetAIDamageThreshold("autoturret4", 0.5)
    SetAIDamageThreshold("backgen1", 0.7)
    SetAIDamageThreshold("generator_03", 0.7)
    SetAIDamageThreshold("backgen2", 0.7)
    SetAIDamageThreshold("core", 0.3)
	
	-- map properties
    SetProperty("core", "MaxHealth", 1e+37)
    SetProperty("core", "CurHealth", 1e+37)
    SetProperty("cforce_shield_01", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_01", "CurHealth", 1e+37)
    SetProperty("cforce_shield_02", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_02", "CurHealth", 1e+37)
    SetProperty("cforce_shield_03", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_03", "CurHealth", 1e+37)
    SetProperty("cforce_shield_04", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_04", "CurHealth", 1e+37)
    SetProperty("cforce_shield_05", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_05", "CurHealth", 1e+37)
    SetProperty("cforce_shield_06", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_06", "CurHealth", 1e+37)
    SetProperty("cforce_shield_07", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_07", "CurHealth", 1e+37)
    SetProperty("force_shield_01", "MaxHealth", 1e+37)
    SetProperty("force_shield_01", "CurHealth", 1e+37)
    SetProperty("force_shield_02", "MaxHealth", 1e+37)
    SetProperty("force_shield_02", "CurHealth", 1e+37)
    SetProperty("force_shield_03", "MaxHealth", 1e+37)
    SetProperty("force_shield_03", "CurHealth", 1e+37)
    SetProperty("generator_03", "MaxHealth", 1e+37)
    SetProperty("generator_03", "CurHealth", 1e+37)
    SetProperty("backgen1", "MaxHealth", 1e+37)
    SetProperty("backgen1", "CurHealth", 1e+37)
    SetProperty("backgen2", "MaxHealth", 1e+37)
    SetProperty("backgen2", "CurHealth", 1e+37)
    SetProperty("autoturret1", "MaxHealth", 1e+37)
    SetProperty("autoturret1", "CurHealth", 1e+37)
    SetProperty("autoturret2", "MaxHealth", 1e+37)
    SetProperty("autoturret2", "CurHealth", 1e+37)
    SetProperty("enemyspawn", "IsVisible", 0)
    SetProperty("turretcp", "IsVisible", 0)
    SetProperty("tankspawn", "IsVisible", 0)
    
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
    
	
	------------------------------------------------
	------------   INTIAL SPAWN  -------------------
	------------------------------------------------
	
    -- set up 3-second timer
    timePop = CreateTimer("timePop")
	SetTimerValue(timePop, 3.0)

	-- on first player spawn
	onfirstspawn = OnCharacterSpawn(
		function(character)
			if IsCharacterHuman(character) then
				ScriptCB_PlayInGameMusic("rep_myg_amb_obj1_2_explore")
				ReleaseCharacterSpawn(onfirstspawn)
				onfirstspawn = nil
				
				-- display first objective after timer elapses
				StartTimer(timePop)
				OnTimerElapse(
					function(timer)
						StartObjectives()
						ScriptCB_EnableCommandPostVO(0)		
						ScriptCB_SndPlaySound("MYG_obj_01")
						ScriptCB_SndPlaySound("MYG_obj_02")
						DestroyTimer(timer)
					end,
					timePop
				)          
			end
		end
	)
        
	
	------------------------------------------------
	------------   MISSION REGIONS   ---------------
	------------------------------------------------
	
	-- move initial enemy spawn back
	ActivateRegion("enemytrigger1")
    EnemyStart = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				EnemyTrigger1() 
				DeactivateRegion("enemytrigger1")
			end
		end,
		"enemytrigger1"
    )
    
	-- move initial enemy spawn back further
	ActivateRegion("enemytrigger2")
    EnemyStart2 = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				EnemyTrigger2() 
				DeactivateRegion("enemytrigger2")
			end
		end,
		"enemytrigger2"
    )
	
	-- spawn cp across starting bridge upon approaching steps
	FlyerTrigger = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				NoRunCP() 
			end
		end,
		"magnatrigger"
    )
    
	-- disable tank spawn
    TankSpawnNew = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				TankSpawn() 
				DeactivateRegion("killtank")
			end
		end,
		"killtank"
    )   
	
	-- destroy shield generator to access core
    CoreReminder2 = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				CoreReminder() 
				DeactivateRegion("corereminder")
			end
		end,
		"corereminder"
    )
    
	-- Removed first stage of running sequence because it is
	-- never called. Moved the code to the start of Objective7.
	
	-- second stage in returning cyrstal
    CoreRun = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreRunHome() 
            DeactivateRegion("corerun2")
        end
    end,
    "corerun2"
    )
    
	-- third stage in returning cyrstal
    CoreRun3 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreRunHome3() 
            DeactivateRegion("corerun3")
        end
    end,
    "corerun3"
    )
	
	-- I don't think this does anything --------------------------------------------------------------------
	RealFlyer = OnEnterRegion(
		function(region, character) 
			if IsCharacterHuman(character) then 
				PlayAnimation("dropshipnew")
				DeactivateRegion("realflyer")
			end
		end,
		"realflyer"
    )
    
	-- spawn dropship
    FlyerTrigger = OnEnterRegion(
    function(region, character) 
			if IsCharacterHuman(character) then 
				FlyerTrigger1() 
				DeactivateRegion("flyertrigger")
			end
		end,
		"flyertrigger"
    )
    
	
	------------------------------------------------
	------------   OBJECTIVE 1   -------------------
	------------------------------------------------
	-- 
	-- Capture CP
	--
	
	-- initialize objective
    Objective1CP = CommandPost:New{name = "CP9OBJ"}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
									   text = "level.myg1.obj.c1", 
									   popupText = "level.myg1.obj.pop.c1"}
    Objective1:AddCommandPost(Objective1CP)
    
	-- on start
    Objective1.OnStart = function(self)
		-- prevent REP AI from capturing CP
    	AICanCaptureCP("CP9OBJ", ATT, false)
		
		-- set AI goal
    	Objective1.defGoal1 = AddAIGoal(ATT, "Defend", 3000, "CP9OBJ")
    	Objective1.defendGoal1 = AddAIGoal(CIS2, "Defend", 3000, "CP9OBJ")
    end
	
	-- on completion
	Objective1.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they capture CP
		if self.winningTeam == DEF then
			ScriptCB_SndPlaySound("MYG_obj_15")
		else
			-- "Good job men, now we need to make some space for General Mundi to land..."
			ScriptCB_SndPlaySound("MYG_obj_03")
		end
		
		-- remove AI goal
		DeleteAIGoal(Objective1.defGoal1)
		DeleteAIGoal(Objective1.defendGoal1)

		-- move capture region off of the map
		SetProperty("CP9OBJ", "CaptureRegion", "distraction")
		
		-- deprioritize CP for CIS
		SetProperty("CP9OBJ", "Value_DEF_CIS", "0")
		
		-- move CP spawn path to on top of CP
		SetProperty("CP9OBJ", "SpawnPath", "cp9objpath2")
		
		-- make REP AI spawn at new CP
		SetProperty("CP9OBJ", "AISpawnWeight", "1000")
		
		-- I don't think this does anything --------------------------------------------------------------------
		SetProperty("turretcp", "SpawnPath", "")
		
		-- allow tanks to spawn, then disable after player leaves CP
		SetProperty("enemyspawn", "SpawnPath", "tankspawn")
		SetObjectTeam("tankspawn", 2)
		ActivateRegion("killtank")

		-- increase REP reinforcements 
		ATT_ReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
	end
    
	
	------------------------------------------------
	------------   OBJECTIVE 2   -------------------
	------------------------------------------------
	-- 
	-- Destroy turrets
	--
    
	-- initialize objective
    MainframeString = "level.myg1.obj.c2-"
    Mainframe01 = Target:New{name = "autoturret1"}
    Mainframe02 = Target:New{name = "autoturret2"}
    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
									  text = "level.myg1.obj.c2", 
									  popupText = "level.myg1.obj.pop.c2"}
    Objective2:AddTarget(Mainframe01)
    Objective2:AddTarget(Mainframe02)
	
	-- update objective after destruction of first turret
	Objective2.OnSingleTargetDestroyed = function(self, target)
		local numTargets = self:GetNumSingleTargets()
		if numTargets > 0 then
			-- message "1 of 2"
			ShowMessageText(MainframeString .. (numTargets + 1), 1)
			
			-- "One more to go."
			ScriptCB_SndPlaySound("MYG_obj_04")
		end
	end
   
	-- on start
    Objective2.OnStart = function(self)
		SetObjectTeam("CP9OBJ", 1)
		
		-- set turret health
		SetProperty("autoturret1", "MaxHealth", 1000)
		SetProperty("autoturret1", "CurHealth", 1000)
		SetProperty("autoturret2", "MaxHealth", 1000)
		SetProperty("autoturret2", "CurHealth", 1000)
		
		-- set AI goals
		Objective2.defendGoal1 = AddAIGoal(CIS2, "Deathmatch", 5000)
		Objective2.atkGoal1 = AddAIGoal(ATT, "Destroy", 3000, "autoturret1")
		Objective2.atkGoal2 = AddAIGoal(ATT, "Destroy", 3000, "autoturret2")
		Objective2.defGoal1 = AddAIGoal(DEF, "Defend", 3000, "autoturret1")
		Objective2.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "autoturret2")
    end
    
	-- on completion
	Objective2.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they destroy turrets
		if self.winningTeam == DEF then
			ScriptCB_SndPlaySound("MYG_obj_15")
		else
			ScriptCB_SndPlaySound("MYG_obj_18")
		end
		
		-- remove AI goal
		DeleteAIGoal(Objective2.atkGoal1)
		DeleteAIGoal(Objective2.atkGoal2)
		DeleteAIGoal(Objective2.defGoal1)
		DeleteAIGoal(Objective2.defGoal2)
		
		-- allow REP to use hero
		UnlockHeroForTeam(REP)
		
		-- enable AI barrier around dropship landing zone
		EnableBarriers("dropship")
		
		-- activate mission regions
		ActivateRegion("leftshield")
		ActivateRegion("lshield2")
		
		ScriptCB_PlayInGameMusic("rep_myg_act_01") 

		-- I don't think this does anything --------------------------------------------------------------------
		SetProperty("core", "SpawnPath", "corespawn")
		
		-- increase REP reinforcements 
		ATT_ReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
    end
    
	------------------------------------------------
	------------   OBJECTIVE 3   -------------------
	------------------------------------------------
	-- 
	-- Destroy shield generator
	--
	
	-- initialize objective
    NewShieldObj = Target:New{name = "generator_03"}
    Objective3 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
									  text = "level.myg1.obj.c13", 
									  popupText = "level.myg1.obj.pop.c13", 
									  AIGoalWeight = 0.0} -- REP AI seems to shut off with this though
    Objective3:AddTarget(NewShieldObj)
    
	-- on start
    Objective3.OnStart = function(self)
		ShowMessageText("level.myg1.obj.c2c", 1)
		
		-- make generator destructable
		SetProperty("generator_01", "MaxHealth", 150)
    	SetProperty("generator_01", "CurHealth", 150)
		
		-- set AI goals
		Objective2.dmGoal1 = AddAIGoal(ATT, "Deathmatch", 3000) 
		Objective2.defGoal1 = AddAIGoal(DEF, "Defend", 3000, "generator_03")
		
		-- move CIS spawns
		SetProperty("enemyspawn", "SpawnPath", "enemyspawnr")
		SetProperty("CP2", "SpawnPath", "cp2spawnpath")
		
		-- set generator health
    	SetProperty("generator_03", "MaxHealth", 150)
    	SetProperty("generator_03", "CurHealth", 150)
    end
    
	-- on completion
    Objective3.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they destroy generator
    	if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
				-- "Capture the CP. It will serve as an excellent lookout for our mission."
    			ScriptCB_SndPlaySound("MYG_obj_35")
	    end
		
		-- remove AI goal
		DeleteAIGoal(Objective3.dmGoal1)
      	DeleteAIGoal(Objective3.defGoal1)
		
		-- spawn CP for next objective
    	RespawnObject("CP2")
		
		-- increase REP reinforcements 
    	ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
    end
    
    
	------------------------------------------------
	------------   OBJECTIVE 4   -------------------
	------------------------------------------------
	-- 
	-- Capture CP
	--

	-- initialize objective
	Objective4CP = CommandPost:New{name = "CP2"}
    Objective4 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
									   text = "level.myg1.obj.c10", 
									   popupText = "level.myg1.obj.pop.c10"}
    Objective4:AddCommandPost(Objective4CP)
    
	-- on start
    Objective4.OnStart = function(self)
		-- spawn objective CP
		RespawnObject("CP2")
		
		-- prevent REP AI from capturing CP
    	AICanCaptureCP("CP2", ATT, false)
		
		-- set AI goals
    	Objective4.defGoal1 = AddAIGoal(ATT, "Defend", 3000, "CP2")
    	Objective4.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "CP2")
		
		-- spawn some droids on CP
		Ambush("cp2_ambush", ambushCount3, ambushTeam3)
		
		-- move CIS spawn away from objective
    	SetProperty("newenemyspawn", "SpawnPath", "enemyspawn2_1")
    	SetProperty("enemyspawn", "SpawnPath", "enemyspawn2_1")
    end
    
	-- on completion
    Objective4.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they capture CP
		if self.winningTeam == DEF then
				ScriptCB_SndPlaySound("MYG_obj_15")
			else
				--ScriptCB_SndPlaySound("MYG_obj_29")
				ScriptCB_SndPlaySound("turret_obj")
	    end
		
		-- remove AI goal
		DeleteAIGoal(Objective4.defGoal1)
      	DeleteAIGoal(Objective4.defGoal2)
    	
		-- move capture region off of the map
      	SetProperty("CP2", "CaptureRegion", "distraction")
		
		-- make REP AI spawn at new CP
      	SetProperty("CP2", "AISpawnWeight", "1000") 
		SetProperty("CP9OBJ", "AISpawnWeight", "5000") 
		
		ScriptCB_PlayInGameMusic("rep_myg_amb_obj5_explore")
		
		-- increase REP reinforcements 
      	ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 30)
        
    end
    
	
	------------------------------------------------
	------------   OBJECTIVE 5   -------------------
	------------------------------------------------
	-- 
	-- Destroy turrets
	--
	
	-- initialize objective
	MainframeString2 = "level.myg1.obj.c2-"
    Mainframe03 = Target:New{name = "autoturret3"}
    Mainframe04 = Target:New{name = "autoturret4"}
    Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
									  text = "level.myg1.obj.c11", 
									  popupText = "level.myg1.obj.pop.c11"}
    Objective5:AddTarget(Mainframe03)
    Objective5:AddTarget(Mainframe04)
    
	-- update objective after destruction of first turret
    Objective5.OnSingleTargetDestroyed = function(self, target)
		local numTargets = self:GetNumSingleTargets()
		if numTargets > 0 then
			-- message "1 of 2"
			ShowMessageText(MainframeString2 .. (numTargets + 1), 1)
		end
	end
	
	-- on start
	Objective5.OnStart = function(self)  
		
		-- spawn some droids near turrets
		Ambush("cis2spawn1", ambushCount3, ambushTeam3)
		
		-- set turret health
		Objective5.atkGoal1 = AddAIGoal(ATT, "Destroy", 3000, "autoturret3")
		Objective5.atkGoal2 = AddAIGoal(ATT, "Destroy", 3000, "autoturret4")
		Objective5.defGoal1 = AddAIGoal(DEF, "Defend", 3000, "autoturret3")
		Objective5.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "autoturret4")

		-- move CIS spawn away from objective
		SetProperty("newenemyspawn", "SpawnPath", "lback")
		SetProperty("enemyspawn", "SpawnPath", "rshield2")
    end
    
	-- on completion
	Objective5.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they destroy turrets
		if self.winningTeam == DEF then
				ScriptCB_SndPlaySound("MYG_obj_15")
			else
				ScriptCB_SndPlaySound("MYG_obj_06")
	    end
		
		-- remove AI goal
		DeleteAIGoal(Objective5.atkGoal1)
		DeleteAIGoal(Objective5.atkGoal2)
		DeleteAIGoal(Objective5.defGoal1)
		DeleteAIGoal(Objective5.defGoal2)
    end
    
	
	------------------------------------------------
	------------   OBJECTIVE 6   -------------------
	------------------------------------------------
	--
	-- Destroy core
	--

	-- initialize objective
    core = Target:New{name = "core"}
    Objective6 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
									  text = "level.myg1.obj.c4", 
									  popupText = "level.myg1.obj.pop.c4"}
    Objective6:AddTarget(core)
	
	-- on start
	Objective6.OnStart = function(self)
		ShowMessageText("level.myg1.obj.c2c", 1)
		
		ActivateRegion("corereminder")
		
		-- set core and generator health
		SetProperty("core", "MaxHealth", 1800)
		SetProperty("core", "CurHealth", 1800)
		SetProperty("backgen1", "MaxHealth", 150)
		SetProperty("backgen1", "CurHealth", 150)
		SetProperty("backgen2", "MaxHealth", 150)
		SetProperty("backgen2", "CurHealth", 150)

		-- I don't think this is necesary --------------------------------------------------------------
		SetObjectTeam("CP2", 1)
		
		-- move CIS spawn to behind core and right side of map
		SetProperty("newenemyspawn", "SpawnPath", "corespawn")
		SetProperty("enemyspawn", "SpawnPath", "rshield2")

		-- set REP to defend shields and CIS to kill everyone (weird but devs did this)
		Objective6.dmGoalATT1 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_04")
		Objective6.dmGoalATT2 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_05")
		Objective6.dmGoalATT3 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_06")
		Objective6.dmGoalATT4 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_07")
		Objective6.dmGoal1 = AddAIGoal(DEF, "Deathmatch", 1000)  
		Objective6.dmGoal2 = AddAIGoal(ambushTeam2, "Defend", 3000, "core")
	end
    
	-- on completion
    Objective6.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)

		-- CIS wins if REP runs out of tickets
		-- REP wins if they destroy core
		if self.winningTeam == DEF then
			ScriptCB_SndPlaySound("MYG_obj_15")
		  else
			ScriptCB_SndPlaySound("MYG_obj_20")
		end

		-- remove AI goal
		DeleteAIGoal(Objective6.dmGoalATT1)
		DeleteAIGoal(Objective6.dmGoalATT2)
		DeleteAIGoal(Objective6.dmGoalATT3)
		DeleteAIGoal(Objective6.dmGoalATT4)
		
		-- allow CIS tanks to spawn
		SetObjectTeam("tankspawn", 2)
		
		-- make sure left shield are dead
		SetProperty("generator_01", "CurHealth", 0)
		SetProperty("generator_02", "CurHealth", 0)
		
		-- spawn crystal (spawn instantly here vs in next objective)
		Holocron1Spawn = GetPathPoint("codespawn", 0) -- gets the path point
		CreateEntity("myg1_flag_crystal", Holocron1Spawn, "crystal") -- spawns crystal

		-- increase REP reinforcements 
		ATT_ReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
    end


	------------------------------------------------
	------------   OBJECTIVE 7   -------------------
	------------------------------------------------
	-- 
	-- Power crystal
	--
	
	-- initialize objective
    Objective7 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, 
								 captureLimit = 1, 
								 text = "level.myg1.obj.c5", 
								 popupText = "level.myg1.obj.pop.c5",
								 showTeamPoints = false,
								 AIGoalWeight = 1000.0}
    Objective7:AddFlag{name = "crystal", captureRegion = "droppoint",
            capRegionMarker = "rep_icon", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}
            
	-- update objective upon crystal pickup
	Objective7.OnPickup = function(self, flag)
		if IsCharacterHuman(flag.carrier) then
			MapAddEntityMarker("newenemyspawn", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
			ScriptCB_SndPlaySound("MYG_obj_23")
			SetProperty("enemyspawn", "SpawnPath", "lastspawn")		
		end
	end
	
	-- on start
	Objective7.OnStart = function(self)
	
		-- prevent REP AI from picking up crystal
		SetProperty("crystal", "AllowAIPickUp", 0)
		
		-- activate regions for running sequence back to dropship
		ActivateRegion("corerun2")
        ActivateRegion("corerun3")
		ActivateRegion("realflyer")
        ActivateRegion("flyertrigger")
		
		-- move CIS spawn for running sequence
		SetProperty("enemyspawn", "SpawnPath", "lastspawn")
		Ambush("solrush2", ambushCount1, ambushTeam1)		
	    
	    -- play one song for a short time then play another one
		ScriptCB_PlayInGameMusic("rep_myg_objComplete_01")
	    music01Timer = CreateTimer("music01")
	    SetTimerValue(music01Timer, 15.0)
		StartTimer(music01Timer)
		OnTimerElapse(
			function(timer)
				ScriptCB_StopInGameMusic("rep_myg_objComplete_01")
				ScriptCB_PlayInGameMusic("rep_myg_amb_immVict_01")
				DestroyTimer(timer)
			end,
			music01Timer
		)  
    end
	
    -- on completion
    Objective7.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
		
		-- CIS wins if REP runs out of tickets
		-- REP wins if they capture crystal
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("MYG_obj_16")
    	else
	    	ScriptCB_SndPlaySound("MYG_obj_14")
	    end
		
		MapRemoveEntityMarker("newenemyspawn")
    	MapRemoveEntityMarker("repveh6")
    end

    
	------------------------------------------------
	------------   SHIELD AND CORE   ---------------
	------------------------------------------------

    Init("01")
    Init("02")
    Init("03")
    Init("04")
    Init("05")
    Init("06")
    Init("07")

	-- left shield 1
    OnObjectRespawnName(Revived, "generator_01")
    OnObjectKillName(ShieldDied, "force_shield_01")
    OnObjectKillName(ShieldDied, "generator_01")
    
	-- left shield 2
    OnObjectRespawnName(Revived, "generator_02")
    OnObjectKillName(ShieldDied, "force_shield_02")
    OnObjectKillName(ShieldDied, "generator_02")

	-- right shield
    OnObjectRespawnName(Revived, "generator_03")
    OnObjectKillName(ShieldDied, "force_shield_03")
    OnObjectKillName(ShieldDied, "generator_03")
    
    -- back generators
    Generator = 2
    OnObjectKillName(GeneratorKill, "backgen2")
    OnObjectKillName(GeneratorKill, "backgen1")
	
	-- core
	OnObjectKillName(CoreDied, "core")
    
	
	------------------------------------------------
	------------   MISC   --------------------------
	------------------------------------------------
    
	-- low reinforcement warning
    OnTicketCountChange(
		function (team, count)
			if team == ATT and count == 35 then				
				ScriptCB_SndPlaySound("rep_off_com_report_us_overwhelmed")
			elseif team == DEF and count == 10 then
				-- play DEF is low on reinforce sound
			end
		end
	)
	
	EnableSPScriptedHeroes()
end

-- objective sequencer
function StartObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective7)
    objectiveSequence:Start()
end
	

------------------------------------------------
------------   SPAWN PATH TRIGGERS   -----------
------------------------------------------------

-- move initial CIS spawn back further
function EnemyTrigger1()
	SetProperty("enemyspawn", "SpawnPath", "enemyspawn1")
	ScriptCB_SndPlaySound("MYG_inf_04")
end

-- move CIS spawn to cp
function EnemyTrigger2()
	SetProperty("enemyspawn", "SpawnPath", "enemyspawn2")
	SetProperty("turretcp", "SpawnPath", "cpfight")
end

-- spawn CP across starting bridge
function NoRunCP()
	RespawnObject("norun")
end

function TankSpawn()
	-- spawns zero tanks
    SetObjectTeam("tankspawn", 0)
end

function CoreReminder()
	-- Notify the player they need to destroy the shield generators
	-- in order to access the core.
	
	-- display objective message and audio description
    ShowMessageText("level.myg1.obj.c8", 1)
	ScriptCB_SndPlaySound("MYG_obj_34")
    
	-- mark generators
	MapAddEntityMarker("backgen1", "hud_objective_icon", 3.0, 1, "YELLOW", true) 
    MapAddEntityMarker("backgen2", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    
	-- trigger ambush behind core
	Ambush("magna2", ambushCount3, ambushTeam3)
	
	-- move enemy spawn to right side of map
    SetProperty("enemyspawn", "SpawnPath", "rshield2")
    SetProperty("newenemyspawn", "SpawnPath", "rshield2")
end

-- ambush between left shields
function CoreRunHome()
	Ambush("cp4spawnpath", ambushCount5, ambushTeam5)
end

-- droideka ambush
function CoreRunHome3()
	-- bridge ambush
	Ambush("droideka2", ambushCount2, ambushTeam2)
	Ambush("testing", ambushCount3, ambushTeam3)
	
	-- I don't think this does anything
	MapRemoveEntityMarker("enemyspawn2")
end

-- spawn dropship
function FlyerTrigger1()
	SetObjectTeam("repship", 1)
	MapAddEntityMarker("repveh6", "hud_objective_icon", 3.0, 1, "YELLOW", true)
	SetProperty("repveh6", "MaxHealth", 1e+37)
    SetProperty("repveh6", "CurHealth", 1e+37)
	--PlayAnimation("dropshipnew")
	ScriptCB_SndPlaySound("MYG_inf_07")
end

------------------------------------------------
------------   CORE DESTRUCTION LOGIC   --------
------------------------------------------------

-- take down core shields
function CoreShield2()
	-- unmark generators
	MapRemoveEntityMarker("backgen1")
	MapRemoveEntityMarker("backgen2")

	-- remove core shields
	PlayAnimation("cshield_down_04")
	PlayAnimation("cshield_down_05")
	PlayAnimation("cshield_down_06")
	PlayAnimation("cshield_down_07")

	-- spawn droidekas in core
	Ambush("droideka", ambushCount2, ambushTeam2)

	UnblockPlanningGraphArcs("incore")
end

function CoreDied(actor)
	MapRemoveEntityMarker("backgen1")
    MapRemoveEntityMarker("backgen2")
	
    PlayAnimation("cshield_down_04")
    PlayAnimation("cshield_down_05")
	PlayAnimation("cshield_down_06")
	PlayAnimation("cshield_down_07")
	
	-- remove AI barrier around core
	DisableBarriers("coresh1")
	
	SetProperty("backgen1", "MaxHealth", 1e+37)
    SetProperty("backgen1", "CurHealth", 1e+37)
    SetProperty("backgen2", "MaxHealth", 1e+37)
    SetProperty("backgen2", "CurHealth", 1e+37)	
end

-- called upon destruction of a core shield generator
function GeneratorKill()
	Generator = Generator - 1 
	if Generator == 0 then
		CoreShield2()
		ShowMessageText("level.myg1.obj.c9", 1)
		ScriptCB_SndPlaySound("MYG_obj_09")
	else
	end
end


------------------------------------------------
------------   SHIELD LOGIC  -------------------
------------------------------------------------


-- called upon destruction of left shield generator
function RemoveMarker()
	MapRemoveEntityMarker("force_shield_01")
end

-- initialize shield
function Init(numberStr)
	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldUp(shieldName, genName, upAnim, downAnim)

	BlockPlanningGraphArcs("shield_" .. numberStr)
	EnableBarriers("shield_" .. numberStr)
end

-- upon shield life
function Revived(actor)
	fullName = GetEntityName(actor)
	numberStr = string.sub(fullName, -2, -1)

	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldUp(shieldName, genName, upAnim, downAnim)
	BlockPlanningGraphArcs("shield_" .. numberStr)
	EnableBarriers("shield_" .. numberStr)
end

-- upon shield death
function ShieldDied(actor)
	fullName = GetEntityName(actor)
	numberStr = string.sub(fullName, -2, -1)

	shieldName = "force_shield_" .. numberStr
	genName = "generator_" .. numberStr
	upAnim = "shield_up_" .. numberStr
	downAnim = "shield_down_" .. numberStr

	PlayShieldDown(shieldName, genName, upAnim, downAnim)

	UnblockPlanningGraphArcs("shield_" .. numberStr)
	DisableBarriers("shield_" .. numberStr)
end

-- raise shield
function PlayShieldUp(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj)
      RespawnObject(genObj)
      PauseAnimation(downAnim)
      RewindAnimation(upAnim)
      PlayAnimation(upAnim)
end

-- lower shield
function PlayShieldDown(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj)
      KillObject(genObj)
      PauseAnimation(upAnim)
      RewindAnimation(downAnim)
      PlayAnimation(downAnim)
    
end

 
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
    ReadDataFile("ingame.lvl")

	------------------------------------------------
	------------   DLC SOUNDS   --------------------
	------------------------------------------------

	ReadDataFile("dc:sound\\bom.lvl;bomcw")
	

	------------------------------------------------
	------------   VANILLA SOUNDS   ----------------
	------------------------------------------------

	ReadDataFile("sound\\myg.lvl;myg1cw")
	
	
	------------------------------------------------
	------------   UNIT TYPES   --------------------
	------------------------------------------------	
	
	-- republic
	REP_HERO				= "rep_hero_kiyadimundi"
	
	
	------------------------------------------------
	------------   LOAD VANILLA ASSETS   -----------
	------------------------------------------------

	-- republic
    ReadDataFile("SIDE\\rep.lvl",
				 REP_HERO,
				 "rep_fly_gunship_dome",
				 "uta_fly_ride_gunship",
				 "uta_fly_ride_gunshipmyg",
				 "rep_walk_oneman_atst")

	-- cis
    ReadDataFile("SIDE\\cis.lvl",
				 "cis_fly_gunship_dome",
				 "cis_hover_aat")
	
	-- turrets
    ReadDataFile("SIDE\\tur.lvl",
		"tur_bldg_recoilless_lg",
		"tur_bldg_recoilless_myg_auto")

	
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
				 CIS_OFFICER_CLASS,
				 CIS_SPECIAL_CLASS)
 
 
	------------------------------------------------
	------------   SETUP TEAMS   -------------------
	------------------------------------------------
	
    SetupTeams{
		-- republic
        rep = {
            team = REP,
            units = 22,
            reinforcements = 60,
            soldier		= {REP_SOLDIER_CLASS},
            assault		= {REP_ASSAULT_CLASS},
			sniper		= {REP_SNIPER_CLASS, 1, 4},
            engineer	= {REP_ENGINEER_CLASS, 1, 4},
            officer		= {REP_OFFICER_CLASS, 1, 4},
            special		= {REP_SPECIAL_CLASS, 1, 4},
        },
		-- cis
        cis = {
            team = CIS,
            units = 8,
            reinforcements = -1,
            soldier		= {CIS_SOLDIER_CLASS},
            assault		= {CIS_ASSAULT_CLASS},
        }
    }
	
	-- heroes
    SetHeroClass(REP, REP_HERO)
    
	-- cis2
	SetupTeams{
        cis = {
       		team = CIS2,
       		units = 4,
       		reinforcements = -1,
       		soldier = {CIS_SOLDIER_CLASS},
            assault = {CIS_ASSAULT_CLASS},
        }
    }
	
	-- ambush 1
	AddUnitClass(ambushTeam1, CIS_OFFICER_CLASS)
	SetUnitCount(ambushTeam1, ambushCount1)
	AddAIGoal(ambushTeam1, "deathmatch", 100)

	-- ambush 2
	AddUnitClass(ambushTeam2, CIS_SPECIAL_CLASS)
	SetUnitCount(ambushTeam2, ambushCount2)
	AddAIGoal(ambushTeam2, "deathmatch", 100)	

	-- ambush 3
	AddUnitClass(ambushTeam3, CIS_SOLDIER_CLASS)
	SetUnitCount(ambushTeam3, ambushCount3)
	AddAIGoal(ambushTeam3, "deathmatch", 100)
	
	-- friends and enemies setup
    SetTeamAsEnemy(CIS2, REP)
    SetTeamAsEnemy(REP, CIS2)
    SetTeamAsEnemy(ambushTeam1, REP)
    SetTeamAsEnemy(REP, ambushTeam1)
    SetTeamAsEnemy(ambushTeam2, REP)
    SetTeamAsEnemy(REP, ambushTeam2)
    SetTeamAsEnemy(ambushTeam3, REP)
    SetTeamAsEnemy(REP, ambushTeam3)
    SetTeamAsEnemy(REP, CIS2)
    SetTeamAsFriend(ambushTeam1, CIS)
    SetTeamAsFriend(ambushTeam1, CIS2)
    SetTeamAsFriend(ambushTeam1, ambushTeam2)
    SetTeamAsFriend(ambushTeam1, ambushTeam3)
    SetTeamAsFriend(ambushTeam2, CIS)
    SetTeamAsFriend(ambushTeam2, CIS2)
    SetTeamAsFriend(ambushTeam2, ambushTeam1)
    SetTeamAsFriend(ambushTeam2, ambushTeam3)
    SetTeamAsFriend(ambushTeam3, CIS)
    SetTeamAsFriend(ambushTeam3, CIS2)
    SetTeamAsFriend(ambushTeam3, ambushTeam1)
    SetTeamAsFriend(ambushTeam3, ambushTeam2)
    SetTeamAsFriend(ambushTeam3, CIS)
    SetTeamAsFriend(ambushTeam3, CIS2)
    SetTeamAsFriend(ambushTeam3, ambushTeam1)
    SetTeamAsFriend(ambushTeam3, ambushTeam2)
    SetTeamAsFriend(CIS2, CIS)
    SetTeamAsFriend(CIS, CIS2)
    SetTeamAsFriend(CIS2, ambushTeam1)
    SetTeamAsFriend(CIS, ambushTeam1)
    SetTeamAsFriend(CIS2, ambushTeam2)
    SetTeamAsFriend(CIS, ambushTeam2)
    SetTeamAsFriend(CIS2, ambushTeam3)
    SetTeamAsFriend(CIS, ambushTeam3)
    
	-- walkers
    ClearWalkers()
	AddWalkerType(0, 4)				-- droidekas
	AddWalkerType(1, 4) 			-- 1x2 (1 pair of legs)    
	
	
	------------------------------------------------
	------------   LEVEL STATS   -------------------
	------------------------------------------------
	
	-- memory pool
    local weaponCnt= 240
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1500)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 24)
    SetMemoryPoolSize("EntityFlyer", 3)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("EntitySoundStream", 10) --1
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("MountedTurret", 16)
	SetMemoryPoolSize("Navigator", 45)
    SetMemoryPoolSize("Obstacle", 1000)
    SetMemoryPoolSize("PathFollower", 45)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 500)
	SetMemoryPoolSize("SoldierAnimation", 500)
    SetMemoryPoolSize("UnitAgent", 60)
    SetMemoryPoolSize("UnitController", 60)
    SetMemoryPoolSize("Weapon", weaponCnt)
  
	-- load gamemode
	ReadDataFile("myg\\myg1.lvl", "myg1_assult")
	
	-- world height
	SetMaxFlyHeight(250)					-- AI
    SetMaxPlayerFlyHeight(20)				-- player


    ------------------------------------------------
	------------   AI RULES   ----------------------
	------------------------------------------------
	
	-- spawn delay
    SetSpawnDelay(10, 0.25)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment("false")


    ------------------------------------------------
	------------   LEVEL ANNOUNCER   ---------------
	------------------------------------------------
	
	-- announcer slow
    voiceSlow = OpenAudioStream("sound\\global.lvl", "myg_objective_vo_slow")
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

	-- out of bounds warnin
    SetOutOfBoundsVoiceOver(REP, "repleaving")
    SetOutOfBoundsVoiceOver(CIS, "cisleaving")


    ------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------

	-- ambience
	OpenAudioStream("sound\\global.lvl", "cw_music")
    OpenAudioStream("sound\\myg.lvl", "myg1")
    OpenAudioStream("sound\\myg.lvl", "myg1")

	-- game over song
    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

	-- misc sounds effects
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")


    ------------------------------------------------
	------------   CAMERA STATS   ------------------
	------------------------------------------------
	
	-- Collector Shot
    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090)
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359)
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212)
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887)
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128)
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712)
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550)
end
