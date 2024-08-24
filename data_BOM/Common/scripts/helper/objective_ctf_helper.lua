--[[
	Battlefront Mission Helper
	Module name: objective_ctf_helper
	Description: Heper module for 1-flag and 2-flag CTF set up
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies: tableUtils, constants, objective_helper
	Notes: Assume all parameters are strings unless stated otherwise
--]]
local objective_ctf_helper = {
	name = "objective_ctf_helper",
	version = 1.0,
	
	initialized = false,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")
local constants = import("constants")
local objectiveHelper = import("objective_helper")
local TeamConfig = import("TeamConfig")


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   CONSTANTS   ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- flag icon
local ICON = ""
local FLAG_ICON = constants.getIconFlag()
local FLAG_ICON_SCL = 3.0

-- capture region marker
local CAP_REG_MRK = constants.getIconCircle()
local CAP_REG_MRK_ATT = CAP_REG_MRK
local CAP_REG_MRK_DEF = CAP_REG_MRK

-- capture region marker scale
local CAP_REG_MRK_SCL = 3.0
local CAP_REG_MRK_ATT_SCL = CAP_REG_MRK_SCL
local CAP_REG_MRK_DEF_SCL = CAP_REG_MRK_SCL

local MULTIPLAYER_RULES = true

------------------------------------------------
------------   1-FLAG PROPERTIES   -------------
------------------------------------------------

-- capture limit
local CAP_LIMIT_1FLAG = 5

-- misc
local HIDE_CPS_1FLAG = true

------------------------------------------------
------------   2-FLAG PROPERTIES   -------------
------------------------------------------------

-- caputure limit
local CAP_LIMIT_CTF = 5

-- misc
local HIDE_CPS_CTF = true


------------------------------------------------
------------   FLAG GEOMETRY   -----------------
------------------------------------------------

-- visibility of flag when dropped
local DROP_COLORIZE = 1


---------------------------------------------------------------------------
-- FUNCTION:    validateParameters
-- PURPOSE:		Validate parameters for erros, and populate missing 
--				parameters
-- INPUT:		params = {
--					textATT, textDEF,
--					teamNameATT, teamNameDEF,
--					flagNameATT, flagNameDEF
--					homeRegionATT, homeRegionDEF
--					captureRegionATT, captureRegionDEF,
-- 				},
--				isOneFlag
-- OUTPUT:		params
-- NOTES:       
---------------------------------------------------------------------------
local function validateParameters(params, isOneFlag)
	local function validateType(params)
		-- parameters to validate
		local keys = {
			"teamNameATT", "teamNameDEF",
			"captureRegionATT", "captureRegionDEF",
			
		}
		
		if isOneFlag then
			local oneFlagKeys = {
				"flagName",
				"homeRegion",
				
			}
			keys = tableUtils.appendTable(keys, oneFlagKeys)
			
		else
			local ctfKeys = {
				"flagNameATT", "flagNameDEF",
				"homeRegionATT", "homeRegionDEF",
			}
			keys = tableUtils.appendTable(keys, ctfKeys)
		end
		
		
		-- check if string
		for _, key in ipairs(keys) do
			assert(type(params[key]) == "string", "Expected type string, got " .. type(params[key]) .. " for parameter " .. key)
		end
	end
	
	local function validateTeamNames(teamNames)
		for team, name in pairs(teamNames) do
			assert(constants.getTeamNamesShortToLong()[name], "Invalid team name for team " .. team .. ", got " .. name)
		end
	end
	
	-- objective text params
	if isOneFlag then
		objectiveText = "oneFlag"
	else
		objectiveText = "ctf"
	end
	params.textATT = params.textATT or constants.getTextATT(objectiveText)
	params.textDEF = params.textDEF or constants.getTextDEF(objectiveText)
	
	-- validate all params are strings
	validateType(params)
	
	-- validate team name exists
	validateTeamNames{
		teamNameATT = params.teamNameATT, 
		teamNameDEF = params.teamNameDEF,
	}
	
	return params
end


---------------------------------------------------------------------------
-- FUNCTION:    setTeamAnnouncers
-- PURPOSE:		Set team objective announcers
-- INPUT:		teamNameATT, teamNameDEF
-- OUTPUT:
-- NOTES:       
---------------------------------------------------------------------------
local function setTeamAnnouncers(teamNameATT, teamNameDEF)
	SoundEvent_SetupTeams(TeamConfig:getTeamNumbers().teamATT, teamNameATT, 
						  TeamConfig:getTeamNumbers().teamDEF, teamNameDEF)
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   1-FLAG OBJECTIVE   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    initOneFlag
-- PURPOSE:     Create 1-flag objective
-- INPUT:		params = {
--					textATT, textDEF,
--					teamNameATT, teamNameDEF,
--					flagName, homeRegion, 
--					captureRegionATT, captureRegionDEF,
--					multiplayerRules = boolean,
--					delayStart = boolean,
--				}
-- OUTPUT:		ObjectiveOneFlagCTF
-- NOTES:       
---------------------------------------------------------------------------
function objective_ctf_helper:initOneFlag(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")
	
	-- check if objective module is loaded
	assert(ObjectiveOneFlagCTF, "ObjectiveOneFlagCTF has not been loaded!")

	-- compile parameters
	local validParams = validateParameters(params, true)

	-- multiplayer rules params
	local multiplayerRules_ = params.multiplayerRules or MULTIPLAYER_RULES
	assert(type(multiplayerRules_) == "boolean", "ERROR: Expected boolean got, " .. type(multiplayerRules_))
	
	-- create objective
	self.objective = ObjectiveOneFlagCTF:New{
		teamATT = TeamConfig:getTeamNumbers().teamATT, teamDEF = TeamConfig:getTeamNumbers().teamDEF,
		textATT = validParams.textATT, textDEF = validParams.textDEF,
		flag = validParams.flagName, homeRegion = validParams.homeRegion,
		captureRegionATT = validParams.captureRegionATT, captureRegionDEF = validParams.captureRegionDEF,
		capRegionMarkerATT = CAP_REG_MRK_ATT, capRegionMarkerDEF = CAP_REG_MRK_DEF,
		capRegionMarkerScaleATT = CAP_REG_MRK_ATT_SCL, capRegionMarkerScaleDEF = CAP_REG_MRK_DEF_SCL,
		flagIcon = FLAG_ICON, flagIconScale = FLAG_ICON_SCL, 
		captureLimit = CAP_LIMIT_1FLAG,
		hideCPs = HIDE_CPS_1FLAG,
		multiplayerRules = multiplayerRules_
	}
	print("Created: ObjectiveOneFlagCTF")
	
	-- set announcers
	setTeamAnnouncers(validParams.teamNameATT, validParams.teamNameDEF)
	
	-- auto start objective
	objectiveHelper.startObjective(self.objective, params.delayStart)
	
	self.initialized = true
	return self.objective
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   2-FLAG OBJECTIVE   --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    compileTeams
-- PURPOSE:		Pair team names with flag properties
-- INPUT:		params = {
--					teamNameATT, teamNameDEF,
--					flagNameATT, flagNameDEF
--					homeRegionATT, homeRegionDEF
--					captureRegionATT, captureRegionDEF,
-- 				}
-- OUTPUT:		teams
-- NOTES:       The design choice of restructing the table of parameters
--				is to help with simplicity for the user when setting up the
--				function call. The structure actually used is far more 
--				complicated.
---------------------------------------------------------------------------
local function compileTeams(params)
	local teams = {
		[params.teamNameATT] = {
			flagName = params.flagNameATT, 
			homeRegion = params.homeRegionATT, 
			captureRegion = params.captureRegionATT,
		},
		[params.teamNameDEF] = {
			flagName = params.flagNameDEF, 
			homeRegion = params.homeRegionDEF, 
			captureRegion = params.captureRegionDEF,
		},
	}
	return teams
end


---------------------------------------------------------------------------
-- FUNCTION:    setFlagGeometry
-- PURPOSE:     Set CTF flag gemoetry
-- INPUT:		teams = {
--					allFlagName, impFlagName, 
--					repFlagName, cisFlagName
--				} 
-- OUTPUT:
-- NOTES:       
---------------------------------------------------------------------------
local function setFlagGeometry(team, flag)
	SetProperty(flag.flagName, "GeometryName", constants.getFlagGeometry(team))
	SetProperty(flag.flagName, "CarriedGeometryName", constants.getFlagGeometryCarried(team))
	print("Set flag geometry for " .. flag.flagName .. " to " .. constants.getTeamNamesShortToLong()[team])
end


---------------------------------------------------------------------------
-- FUNCTION:    addFlag
-- PURPOSE:     Add flag to the objective
-- INPUT:		ctf, team, flag
-- OUTPUT:
-- NOTES:		
---------------------------------------------------------------------------
local function addFlag(objective, flag)
	objective:AddFlag{
		name = flag.flagName, 
		homeRegion = flag.homeRegion, 
		captureRegion = flag.captureRegion,
		capRegionMarker = CAP_REG_MRK,
		capRegionMarkerScale = CAP_REG_MRK_SCL, 
		icon = ICON, 
		mapIcon = FLAG_ICON, 
		mapIconScale = FLAG_ICON_SCL
	}
	print("Added flag " .. flag.flagName .. " to CTF objective")
end


---------------------------------------------------------------------------
-- FUNCTION:    initializeFlags
-- PURPOSE:     Set flag geometry and add flag to the objective
-- INPUT:		teams
-- OUTPUT:
-- NOTES:		
---------------------------------------------------------------------------
local function initializeFlags(objective, teams)
	for team, flag in pairs(teams) do	
		-- flag gemoetry
		setFlagGeometry(team, flag)
		
		-- add flag to objective
		addFlag(objective, flag)
	end
	
	-- set flag visibility when dropped
	SetClassProperty("com_item_flag", "DroppedColorize", DROP_COLORIZE)	
end


---------------------------------------------------------------------------
-- FUNCTION:    initCTF
-- PURPOSE:     Create CTF objective and add flags to the objective
-- INPUT:		params = {
--					textATT, textDEF,
--					teamNameATT, teamNameDEF,
--					flagNameATT, flagNameDEF
--					homeRegionATT, homeRegionDEF
--					captureRegionATT, captureRegionDEF,
--					multiplayerRules = boolean,
--					delayStart = boolean,
-- 				}
-- OUTPUT:		ObjectiveCTF
-- NOTES:       
---------------------------------------------------------------------------
function objective_ctf_helper:initCTF(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")

	-- check if objective module is loaded
	assert(ObjectiveCTF, "ObjectiveCTF has not been loaded!")
	
	-- compile parameters
	local validParams = validateParameters(params)
	local teams = compileTeams(validParams)
	
	-- multiplayer rules params
	local multiplayerRules_ = params.multiplayerRules or MULTIPLAYER_RULES
	assert(type(multiplayerRules_) == "boolean", "ERROR: Expected boolean got, " .. type(multiplayerRules_))
	
	-- create objective
	self.objective = ObjectiveCTF:New{
		teamATT = TeamConfig:getTeamNumbers().teamATT, teamDEF = TeamConfig:getTeamNumbers().teamDEF, 
		textATT = validParams.textATT, textDEF = validParams.textDEF, 
		captureLimit = CAP_LIMIT_CTF, 
		hideCPs = HIDE_CPS_CTF, 
		multiplayerRules = multiplayerRules_,
	}
	print("Created: ObjectiveCTF")

	-- set flag geometry and add to objective
	initializeFlags(self.objective, teams)
	
	-- set announcers
	setTeamAnnouncers(validParams.teamNameATT, validParams.teamNameDEF)
	
	-- auto start objective
	objectiveHelper.startObjective(self.objective, params.delayStart)
	
	self.initialized = true
	return self.objective
end


-- import function
function get_objective_ctf_helper()
	return objective_ctf_helper
end
