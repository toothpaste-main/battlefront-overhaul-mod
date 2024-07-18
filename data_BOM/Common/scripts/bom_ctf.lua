--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v2.0
--
-- Constants and functions related to both the 
-- 1-Flag and 2-Flag CTF game modes. All
-- parameters are assumed to be strings unless
-- stated otherwise.
--
print("Loading bom_ctf.lua...")

-- load dependencies
ScriptCB_DoFile("bom_constants")
ScriptCB_DoFile("bom_gamemode")


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   CONSTANTS   ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- flag icon
local ICON = ""
local FLAG_ICON = "flag_icon"
local FLAG_ICON_SCL = 3.0

-- capture region marker
local CAP_REG_MRK = "hud_objective_icon_circle"
local CAP_REG_MRK_ATT = CAP_REG_MRK
local CAP_REG_MRK_DEF = CAP_REG_MRK

-- capture region marker scale
local CAP_REG_MRK_SCL = 3.0
local CAP_REG_MRK_ATT_SCL = CAP_REG_MRK_SCL
local CAP_REG_MRK_DEF_SCL = CAP_REG_MRK_SCL


------------------------------------------------
------------   1-FLAG PROPERTIES   -------------
------------------------------------------------

-- message text for player
local TEXT_ATT_1FLAG = "game.modes.1flag"
local TEXT_DEF_1FLAG = "game.modes.1flag2"

-- capture limit
local CAP_LIMIT_1FLAG = 5

-- misc
local HIDE_CPS_1FLAG = true
local MULTIPLAYER_RULES_1FLAG = true

------------------------------------------------
------------   2-FLAG PROPERTIES   -------------
------------------------------------------------

-- message text for player
local TEXT_ATT_CTF = "game.modes.ctf"
local TEXT_DEF_CTF = "game.modes.ctf2"

-- caputure limit
local CAP_LIMIT_CTF = 5

-- misc
local HIDE_CPS_CTF = true
local MULTIPLAYER_RULES_CTF = true


------------------------------------------------
------------   FLAG GEOMETRY   -----------------
------------------------------------------------

-- visibility of flag when dropped
local DROP_COLORIZE = 1

-- alliance
local ALL_GEO_NAME = "com_icon_alliance_flag"
local ALL_GEO_NAME_CARRIED = "com_icon_alliance_flag_carried"

-- cis
local CIS_GEO_NAME = "com_icon_cis_flag"
local CIS_GEO_NAME_CARREID = "com_icon_cis_flag_carried"

-- empire
local IMP_GEO_NAME = "com_icon_imperial_flag"
local IMP_GEO_NAME_CARRIED = "com_icon_imperial_flag_carried"

-- republic
local REP_GEO_NAME = "com_icon_republic_flag"
local REP_GEO_NAME_CARREID = "com_icon_republic_flag_carried"


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   2-FLAG OBJECTIVE   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setTeamNames
-- PURPOSE:     Saves team names to local memory
-- INPUT:		params = {teamATTName, teamDEFName} 
-- OUTPUT:
-- NOTES:       There is an expected number of team names provided set by
--				NUM_FLAGS_CTF in bom_constants.lua. If the they are not 
--				provided or are previously saved, then an error is thrown.
---------------------------------------------------------------------------
local teamNames = {}
function setTeamNames(params) 
	-- att, def
	if params.teamATTName then teamNames.teamATTName = params.teamATTName end
	if params.teamDEFName then teamNames.teamDEFName = params.teamDEFName end
	
	-- check if enough team name are provided or previously set
	do			
		-- count how many team names are known
		local teamCount = 0
		for _ in pairs(teamNames) do teamCount = teamCount + 1 end

		-- check number of team names
		if teamCount < getNumFlagsCTF() then
			error("Not enough team names have been provided. Expected " .. getNumFlagsCTF() .. ", got " .. teamCount)
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setAnnouncers
-- PURPOSE:     Saves team names to local memory and assigns team 
--				announcers
-- INPUT:		params = {teamATT teamATT, 
--						  teamATTName, teamDEFName,
--						  overrideTeamNames = boolean} 
-- OUTPUT:
-- NOTES:       If not enough team names are provided, then an error is
--				thrown. Acceptable team names are defined by 
--				TEAM_NAMES_SHORT in bom_constants.lua. If you wish to use a
--				custom team, then set overrideTeamNames to true.
---------------------------------------------------------------------------
function setAnnouncers(params)

	-- set team numbers
	setTeamNumbers(params)

	-- set team names
	setTeamNames(params)
	
	-- check if team names are known teams
	do
		local TEAM_NAMES = getTeamNamesShort()
	
		-- this function checks if a team name is a known team
		local function checkTeam(team)	
			-- courtesy of ChatGPT-4o
			for _, defaultName in pairs(TEAM_NAMES) do
				if team == defaultName then
					return true
				end
			end
			if not params.overrideTeamNames then
				error("Unexpected team name " .. team .. ". If you want to use custom teams, then set overrideTeamNames to True")
			end
			return false
		end
		
		-- log custom team name
		local function customTeam(team)
			Print("Overriding team name for team " .. team)
		end
	
		-- check if team is known or custom team is being used
		if not checkTeam(teamNames.teamATTName) then customTeam(teamNames.teamATTName) end
		if not checkTeam(teamNames.teamDEFName) then customTeam(teamNames.teamDEFName) end
	end

	-- set announcers
	SoundEvent_SetupTeams(getTeamNumbers().teamATT, teamNames.teamATTName, 
						  getTeamNumbers().teamDEF, teamNames.teamDEFName)
end


---------------------------------------------------------------------------
-- FUNCTION:    setFlagNames
-- PURPOSE:     Saves flag names to local memory
-- INPUT:		params = {allFlagName, cisFlagName, 
--						  impFlagName, repFlagName} 
-- OUTPUT:
-- NOTES:       There is an expected number of flag names provided set by
--				NUM_FLAGS_CTF in bom_constants.lua. If the expected 
--				quantity is not met, then an error is thrown. That is, 
--				unless the flag names have been previously saved.
---------------------------------------------------------------------------
local flagNames = {}
function setFlagNames(params)
	-- alliance, cis, empire, republic
	if params.allFlagName then flagNames.allFlagName = params.allFlagName end
	if params.cisFlagName then flagNames.cisFlagName = params.cisFlagName end
	if params.impFlagName then flagNames.impFlagName = params.impFlagName end
	if params.repFlagName then flagNames.repFlagName = params.repFlagName end
	
	-- check for enough names
	do			
		-- count how many flag names were provided
		local flagCount = 0
		for _ in pairs(flagNames) do flagCount = flagCount + 1 end
		
		-- check number of flag names
		if flagCount ~= getNumFlagsCTF() then
			error("Expected " .. getNumFlagsCTF() .. " flag names, got " .. flagCount)
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setFlagGeometry
-- PURPOSE:     Set CTF flag gemoetry
-- INPUT:		params = {allFlagName, impFlagName, 
--						  repFlagName, cisFlagName} 
-- OUTPUT:
-- NOTES:       
---------------------------------------------------------------------------
function setFlagGeometry(params)
	-- save flag names
	setFlagNames(params)
	
	-- log when geometry set
	local function printToLog(flag, team)
		print("Set flag geometry for: " .. flag .. " as " .. team)
	end
	
	-- alliance
	if flagNames.allFlagName then
		SetProperty(flagNames.allFlagName, "GeometryName", ALL_GEO_NAME)
		SetProperty(flagNames.allFlagName, "CarriedGeometryName", ALL_GEO_NAME_CARRIED)
		printToLog(flagNames.allFlagName, "alliance")
	end
	
	-- cis
	if flagNames.cisFlagName then
		SetProperty(flagNames.cisFlagName, "GeometryName", CIS_GEO_NAME)
		SetProperty(flagNames.cisFlagName, "CarriedGeometryName", CIS_GEO_NAME_CARREID)
		printToLog(flagNames.cisFlagName, "cis")
	end
	
	-- empire
	if flagNames.impFlagName then
		SetProperty(flagNames.impFlagName, "GeometryName", IMP_GEO_NAME)
		SetProperty(flagNames.impFlagName, "CarriedGeometryName", IMP_GEO_NAME_CARRIED)
		printToLog(flagNames.impFlagName, "empire")
	end
	
	-- republic
	if flagNames.repFlagName then
		SetProperty(flagNames.repFlagName, "GeometryName", REP_GEO_NAME)
		SetProperty(flagNames.repFlagName, "CarriedGeometryName", REP_GEO_NAME_CARREID)
		printToLog(flagNames.repFlagName, "republic")
	end
	
	-- set flag visibility when dropped
	SetClassProperty("com_item_flag", "DroppedColorize", DROP_COLORIZE)	
end


---------------------------------------------------------------------------
-- FUNCTION:    setHomeRegions
-- PURPOSE:     Saves names of home regions to local memory
-- INPUT:		params = {allHomeRegion, cisHomeRegion, 
--						  impHomeRegion, repHomeRegion} 
-- OUTPUT:
-- NOTES:       There is an expected number of capture regions provided set
--				by NUM_FLAGS_CTF in bom_constants.lua. If the expected 
--				quantity is not met, then an error is thrown. That is, 
--				unless the capture regions have been previously saved.
---------------------------------------------------------------------------
local homeRegions = {}
function setHomeRegions(params)
	-- alliance, cis, empire, republic
	if params.allHomeRegion then homeRegions.allHomeRegion = params.allHomeRegion end
	if params.cisHomeRegion then homeRegions.cisHomeRegion = params.cisHomeRegion end
	if params.impHomeRegion then homeRegions.impHomeRegion = params.impHomeRegion end
	if params.repHomeRegion then homeRegions.repHomeRegion = params.repHomeRegion end
	
	-- check for enough home regions
	do			
		-- count how many home regions were provided
		local flagCount = 0
		for _ in pairs(homeRegions) do flagCount = flagCount + 1 end
		
		-- check number of flag names
		if flagCount ~= getNumFlagsCTF() then
			print()
			print("WARNING: Expected " .. getNumFlagsCTF() .. " home regions, got " .. flagCount)
			print()
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setCaptureRegions
-- PURPOSE:     Saves names of capture regions to local memory
-- INPUT:		params = {allCaptureRegion, cisCaptureRegion, 
--						  impCaptureRegion, repCaptureRegion} 
-- OUTPUT:
-- NOTES:       There is an expected number of capture regions provided set
--				by NUM_FLAGS_CTF in bom_constants.lua. If the expected 
--				quantity is not met, then an error is thrown. That is, 
--				unless the capture regions have been previously saved.
---------------------------------------------------------------------------
local captureRegions = {}
function setCaptureRegions(params)
	-- alliance, cis, empire, republic
	if params.allCaptureRegion then captureRegions.allCaptureRegion = params.allCaptureRegion end
	if params.cisCaptureRegion then captureRegions.cisCaptureRegion = params.cisCaptureRegion end
	if params.impCaptureRegion then captureRegions.impCaptureRegion = params.impCaptureRegion end
	if params.repCaptureRegion then captureRegions.repCaptureRegion = params.repCaptureRegion end
	
	-- check for enough capture regions
	do			
		-- count how many capture regions were provided
		local flagCount = 0
		for _ in pairs(captureRegions) do flagCount = flagCount + 1 end
		
		-- check number of flag names
		if flagCount ~= getNumFlagsCTF() then
			error("Expected " .. getNumFlagsCTF() .. " capture regions, got " .. flagCount)
		end
	end
end

---------------------------------------------------------------------------
-- FUNCTION:    createCTFObjective
-- PURPOSE:     Create CTF objective and add flags to the objective
-- INPUT:		params = {teamATT,	teamDEF,
--						  teamATTName, teamDEFName,
---						  allFlagName, cisFlagName, 
--						  impFlagName, repFlagName,
--						  allHomeRegion, cisHomeRegion,
--						  impHomeRegion, repHomeRegion,
--						  allCaptureRegion, cisCaptureRegion,
-- 						  impCaptureRegion, repCaptureRegion}
-- OUTPUT:		ObjectiveCTF
-- NOTES:       
---------------------------------------------------------------------------
function createCTFObjective(params)
	-- check if objective module is loaded
	assert(ObjectiveCTF, "ObjectiveCTF has not been loaded!")
	

	------------------------------------------------
	------------   CREATE OBJECTIVE   --------------
	------------------------------------------------
	
	-- team numbers
	setTeamNumbers(params)
	
	-- create objective
	local ctf = ObjectiveCTF:New{teamATT = getTeamNumbers().teamATT, teamDEF = getTeamNumbers().teamDEF, 
								 textATT = TEXT_ATT_CTF, textDEF = TEXT_DEF_CTF, 
							     captureLimit = CAP_LIMIT_CTF, 
								 hideCPs = HIDE_CPS_CTF, 
								 multiplayerRules = MULTIPLAYER_RULES_CTF}
	print("Created: ObjectiveCTF")
	
	------------------------------------------------
	------------   ADD FLAGS TO OBJECTIVE   --------
	------------------------------------------------

	-- save flag names
	setFlagNames(params)
	
	-- save home regions
	setHomeRegions(params)
	
	-- save capture regions
	setCaptureRegions(params)
	
	-- log when flag is added
	local function printToLog(flag, team)
		print("Added flag " .. flag .. " to CTF objective as " .. team)
	end
	
	-- add alliance flag
	if flagNames.allFlagName then
		ctf:AddFlag{name = flagNames.allFlagName, 
					homeRegion = params.allHomeRegion, captureRegion = captureRegions.allCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog(flagNames.allFlagName, "alliance")
	end
    
	-- add cis flag
	if flagNames.cisFlagName then
		ctf:AddFlag{name = flagNames.cisFlagName, 
					homeRegion = params.cisHomeRegion, captureRegion = captureRegions.cisCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog(flagNames.cisFlagName, "cis")
	end
	
	-- add empire flag
	if flagNames.impFlagName then
		ctf:AddFlag{name = flagNames.impFlagName, 
					homeRegion = params.impHomeRegion, captureRegion = captureRegions.impCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog(flagNames.impFlagName, "empire")
	end
	
	-- add republic flag
	if flagNames.repFlagName then
		ctf:AddFlag{name = flagNames.repFlagName, 
					homeRegion = params.repHomeRegion, captureRegion = captureRegions.repCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog(flagNames.repFlagName, "republic")
	end
	
	
	------------------------------------------------
	------------   SETUP ANNOUNCER   ---------------
	------------------------------------------------
	
	setAnnouncers(params)
	
	return ctf
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   1-FLAG OBJECTIVE   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    setOneFlagProperties
-- PURPOSE:     Saves 1-flag properties to memory
-- INPUT:		params = {flagName, homeRegion, 
--						  attCaptureRegion defCaptureRegion} 
-- OUTPUT:
-- NOTES:       All properties are expected to be provied. If a property
-- 				is not provided, then an error is thrown. That is, unless
--				the property has been previously saved.
---------------------------------------------------------------------------
local oneFlag = {}
function setOneFlagProperties(params)
	-- flagName, homeRegion, attCaptureRegion, defCaptureRegion
	if params.flagName then oneFlag.flagName = params.flagName end
	if params.homeRegion then oneFlag.homeRegion = params.homeRegion end
	if params.attCaptureRegion then oneFlag.attCaptureRegion = params.attCaptureRegion end
	if params.defCaptureRegion then oneFlag.defCaptureRegion = params.defCaptureRegion end
	
	-- verify all properties set
	if not oneFlag.flagName then error("Expected flag name, got " .. oneFlag.flagName) end
	if not oneFlag.homeRegion then error("Expected homer region, got " .. oneFlag.homeRegion) end
	if not oneFlag.attCaptureRegion then error("Expected att capture region, got " .. oneFlag.attCaptureRegion) end
	if not oneFlag.defCaptureRegion then error("Expected def capture region, got " .. oneFlag.defCaptureRegion) end
end


---------------------------------------------------------------------------
-- FUNCTION:    createOneFlagObjective
-- PURPOSE:     Create 1-flag objective
-- INPUT:		params = {teamATT, teamDEF,
--						  teamATTName, teamDEFName,
--						  flagName, homeRegion, 
--						  attCaptureRegion, defCaptureRegion}
-- OUTPUT:		ObjectiveOneFlagCTF
-- NOTES:       
---------------------------------------------------------------------------
function createOneFlagObjective(params)
	-- check if objective module is loaded
	assert(ObjectiveOneFlagCTF, "ObjectiveOneFlagCTF has not been loaded!")

	-- team numbers
	setTeamNumbers(params)
	
	-- save 1flag properties
	setOneFlagProperties(params)
	
	-- create objective
	local ctf = ObjectiveOneFlagCTF:New{teamATT = getTeamNumbers().teamATT, teamDEF = getTeamNumbers().teamDEF,
									    textATT = TEXT_ATT_1FLAG, textDEF = TEXT_DEF_1FLAG,
									    flag = oneFlag.flagName, homeRegion = oneFlag.homeRegion,
									    captureRegionATT = oneFlag.attCaptureRegion, captureRegionDEF = oneFlag.defCaptureRegion,
									    --capRegionWorldATT = "1flag_effect2", capRegionWorldDEF = "1flag_effect1", seen on tat3g_1flag
									    capRegionMarkerATT = CAP_REG_MRK_ATT, capRegionMarkerDEF = CAP_REG_MRK_DEF,
									    capRegionMarkerScaleATT = CAP_REG_MRK_ATT_SCL, capRegionMarkerScaleDEF = CAP_REG_MRK_DEF_SCL,
									    flagIcon = FLAG_ICON, flagIconScale = FLAG_ICON_SCL, 
									    captureLimit = CAP_LIMIT_1FLAG,
									    hideCPs = HIDE_CPS_1FLAG,
									    multiplayerRules = MULTIPLAYER_RULES_1FLAG}
	print("Created: ObjectiveOneFlagCTF")
	
	-- setup announcers
	setAnnouncers(params)
	
	return ctf
end