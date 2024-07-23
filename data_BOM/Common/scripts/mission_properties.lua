--[[
	Battlefront Mission Helper
	Module name: mission_properties
	Description: Helper module for map and AI properties
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies: tableUtils, team_properties
	Notes: All parameters are assumed to be numbers unless stated 
		   otherwise.
--]]
local mission_properties = {
	name = "mission_properties",
	version = 1.0,
	
	initialized = false,
}

-- load dependencies
ScriptCB_DoFile("import")
constants = import("constants")
local tableUtils = import("table_utils")
local TeamConfig = import("TeamConfig")


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   DEFAULTS   ----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- default values
local DEFAULT_MISSION_PROPERTIES = {
-- map properties
	-- ceiling and floor limit
	mapCeiling = 25,
	mapCeilingAI = -1,
	mapFloor = 0,
	mapFloorAI = -1,
	
	-- birdies and fishies
	minFlockHeight = -1,
	numBirdTypes = 0,
	numFishTypes = 0,
	
	-- misc
	mapNorthAngle = 0,
	groundFlyerMap = 0,
	worldExtents = -1,
	
-- ai properties
	-- difficulty
	autoBalance = false,
	difficultyPlayer = 0,
	difficultyEnemy = 0,
	
	-- spawn delay
	spawnDelayAI = 10.0,
	percentageAIRespawned = 0.25,
	
	-- view distance
	denseEnvironment = false,
	urbanEnvironment = false,
	viewMultiplier = -1,
	
	-- snipe distance
	snipeDistance = 128,
	snipeDistanceATT = 196,
	snipeDistanceDEF = 196,
	
	-- misc
	blindJetJumps = true,
	stayInTurrets = false,
}

local NUMERICAL_BOOLEANS = {
	"groundFlyerMap",
	"blindJetJumps",
	"stayInTurrets",
}

local STRING_BOOLEANS = {
	"autoBalance",
	"denseEnvironment",
	"urbanEnvironment",
}

local function validateParameters(params)
	local validParams = {}

	-- validate keys and save value
	for k, v in pairs(params) do	
		-- is valid key
		assert(DEFAULT_MISSION_PROPERTIES[k] ~= nil, "ERROR: Unexpected key, got " .. k)
		
		-- value is a boolean
		if tableUtils.isValueInTable(NUMERICAL_BOOLEANS, k) or tableUtils.isValueInTable(STRING_BOOLEANS, k) then
			assert(type(v) == "boolean", "ERROR: Expected boolean for " .. k .. ", got " .. type(v))
			
		-- value is a number
		else
			assert(type(v) == "number", "ERROR: Expected number, got " .. type(v) .. " for " .. k)
		end
		
		-- save value
		validParams[k] = v
	end

	-- apply default values if key is missing
	for k, defaultValue in pairs(DEFAULT_MISSION_PROPERTIES) do
		if validParams[k] == nil then
			-- notify of default
			print("WARNING: Expected value for key " .. k .. ", got nil. Defaulting " .. k .. " to " .. tostring(defaultValue))
			
			-- apply default value
			validParams[k] = defaultValue
		end
	end
	
	-- numerical booleans are 0 or 1
	for _, k in ipairs(NUMERICAL_BOOLEANS) do
		if validParams[k] then
			validParams[k] = 1
		else
			validParams[k] = 0
		end
	end
	
	-- string booleans are "true" or "false"
	for _, k in ipairs(STRING_BOOLEANS) do
		if validParams[k] then
			validParams[k] = "true"
		else
			validParams[k] = "false"
		end
	end
	
	-- world extents limit
	do
		local err = "ERROR: Maximum world extents must be less than " .. constants.getMaxWorldExtents() .. ", got " .. validParams.worldExtents
		assert(validParams.worldExtents < constants.getMaxWorldExtents(), err)
	end
	
	-- map ceiling and floor pairing
	if validParams.mapCeilingAI == -1 then
		validParams.mapCeilingAI = validParams.mapCeiling
	end
	if validParams.mapFloorAI == -1 then
		validParams.mapFloorAI = validParams.mapFloor
	end
	
	return validParams
end

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   PROPERTIES   --------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
-- FUNCTION:    setAIProperties
-- PURPOSE:     Set AI properties
-- INPUT:		
-- OUTPUT:
-- NOTES:		If no value is set for AI ceiling and floor boundaries,
--				they will use the same rules as the player.
---------------------------------------------------------------------------
function mission_properties.setAIProperties(params)
	-- redistribute more AI on to losing team
	if params.autoBalance == "true" then 
		EnableAIAutoBalance()
	end 
	
	-- AI difficulty
	-- difficultyPlayer = 0, +/- to change skill of player's team
	-- difficultyEnemy = 0, +/- to change skill of enemy's team
	SetAIDifficulty(params.difficultyPlayer, params.difficultyEnemy)
	
	-- spawn delay
	SetSpawnDelay(params.spawnDelayAI, params.percentageAIRespawned)
	
	-- dense environment
	-- IF TRUE: decrease AI engagement distance
	-- IF FALSE: default AI engagement distance
	SetDenseEnvironment(params.denseEnvironment)
	
	-- urban environtment
	-- IF TRUE: AI vehicles strafe less
	-- IF FALSE: AI vehicles strafe
	SetUrbanEnvironment(params.urbanEnvironment)
	
	-- view distance
	if params.viewMultiplier > 0 then 
		SetAIViewMultiplier(params.viewMultiplier) 
	end
	
	-- snipe distance
	AISnipeSuitabilityDist(params.snipeDistance) -- snipe distance when on foot
	SetAttackerSnipeRange(params.snipeDistanceATT) -- snipe distance from "attack" hints
	SetDefenderSnipeRange(params.snipeDistanceDEF) -- snipe distance from "defend" hints
	
	-- misc
	SetAllowBlindJetJumps(params.blindJetJumps) -- allow AI to jet jump outside of hints
	SetStayInTurrets(params.stayInTurrets) -- force AI to stay in turrets
end


---------------------------------------------------------------------------
-- FUNCTION:    setMapProperties
-- PURPOSE:     Set map properties
-- INPUT:		
-- OUTPUT:
-- NOTES:
---------------------------------------------------------------------------
function mission_properties.setMapProperties(params)
	-- ceiling and floor limit
	SetMaxFlyHeight(params.mapCeilingAI) -- AI
	SetMaxPlayerFlyHeight(params.mapCeiling) -- player
	SetMinFlyHeight(params.mapFloorAI) -- AI
	SetMinPlayerFlyHeight(params.mapFloor) -- player

	-- min bird flock height
	if params.minFlockHeight > 0 then -- idk what the default value is
		SetBirdFlockMinHeight(params.minFlockHeight)
	end 
	
	-- dragons
	if params.numBirdTypes < 0 then 
		SetNumBirdTypes(1)
		SetBirdType(0.0, 10.0, "dragon") 
		
	-- birdies
	else
		SetNumBirdTypes(params.numBirdTypes)
		
		-- red birdies
		if params.numBirdTypes >= 1 then 
			SetBirdType(0, 1.0, "bird")
		end
		
		-- bird type 2
		if params.numBirdTypes >= 2 then 
			SetBirdType(0, 1.5, "bird2") 
		end
	end

	-- fishies
	SetNumFishTypes(params.numFishTypes)
	if params.numFishTypes >= 1 then 
		SetFishType(0, 0.8, "fish") 
	end

	-- misc
	SetMapNorthAngle(params.mapNorthAngle) -- rotates mini-map
	SetGroundFlyerMap(params.groundFlyerMap) -- make AI flyers aware of the ground
	if params.worldExtents > 0 then -- idk what the default value is
		SetWorldExtents(params.worldExtents)
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setSoundProperties
-- PURPOSE:     Set announcer and sound effects
-- INPUT:		
-- OUTPUT:
-- NOTES:       Requires TeamConfig to be initialized. It does not hurt to
--				have unncessary announcers loaded for CTF, and the solution
--				to unload under certain conditions would be too complex.
---------------------------------------------------------------------------
function mission_properties.setSoundProperties()
	local teamNameATT = TeamConfig:getTeamNames().teamATT
	local teamNameDEF = TeamConfig:getTeamNames().teamDEF
	local teamNumberATT = TeamConfig:getTeamNumbers().teamATT
	local teamNumberDEF = TeamConfig:getTeamNumbers().teamDEF
	
	
	------------------------------------------------
	------------   LEVEL ANNOUNCER   ---------------
	------------------------------------------------
	
	-- announcer slow
    voiceSlow = OpenAudioStream("sound\\global.lvl", "global_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", teamNameATT .. "_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", teamNameDEF .. "_unit_vo_slow", voiceSlow)
    
	-- announcer quick
    voiceQuick = OpenAudioStream("sound\\global.lvl", teamNameATT .. "_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", teamNameDEF .. "_unit_vo_quick", voiceQuick)

	-- winning/losing announcement
    SetBleedingVoiceOver(teamNumberATT, teamNumberATT, teamNameATT .. "_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(teamNumberATT, teamNumberDEF, teamNameATT .. "_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(teamNumberDEF, teamNumberATT, teamNameDEF .. "_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(teamNumberDEF, teamNumberDEF, teamNameDEF .. "_off_com_report_us_overwhelmed", 1)
    
	-- low reinforcement warning
    SetLowReinforcementsVoiceOver(teamNumberATT, teamNumberATT, teamNameATT .. "_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(teamNumberATT, teamNumberDEF, teamNameATT .. "_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(teamNumberDEF, teamNumberDEF, teamNameDEF .. "_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(teamNumberDEF, teamNumberATT, teamNameDEF .. "_off_victory_im", .1, 1)    

	-- out of bounds warning
    SetOutOfBoundsVoiceOver(teamNumberATT, teamNameATT .. "leaving")
    SetOutOfBoundsVoiceOver(teamNumberDEF, teamNameDEF .. "leaving")
	
	
	------------------------------------------------
	------------   LEVEL SOUNDS   ------------------
	------------------------------------------------
	
	-- misc sound effects
	--if params.numBirdTypes >= 1 then SetSoundEffect("BirdScatter", "birdsFlySeq1") end
	SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------   INITIALIZATION   ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------
-- FUNCTION:    init
-- PURPOSE:     Set mission properties
-- INPUT:		params{
--				-- map properties
--					-- ceiling and floor limit
--					mapCeiling, mapCeilingAI,
--					mapFloor, mapFloorAI,
--					
--					-- birdies and fishies
--					minFlockHeight, numBirdTypes, 
--					numFishTypes,
--					
--					-- misc
--					mapNorthAngle, worldExtents,
--					groundFlyerMap = boolean,
--					
--				-- ai properties
--					-- difficulty
--					autoBalance = false, difficultyPlayer, difficultyEnemy,
--					
--					-- spawn delay
--					spawnDelayAI, percentageAIRespawned,
--					
--					-- view distance
--					denseEnvironment = boolean, urbanEnvironment = boolean, 
--					viewMultiplier,
--					
--					-- snipe distance
--					snipeDistance, snipeDistanceATT, snipeDistanceDEF,
--					
--					-- misc
--					blindJetJumps = boolean,
--					stayInTurrets = boolean,
--				}
-- OUTPUT:
-- NOTES:       All parameters are optional. Default values will be used if 
--				nothing is passed.
---------------------------------------------------------------------------
function mission_properties:init(params)
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")

	-- validate parameters and apply defaults to missing ones
	local validParams = validateParameters(params)
	
	-- AI properties
	self.setAIProperties(validParams)
	
	-- map properties
	self.setMapProperties(validParams)
	
	-- sound properties
	self.setSoundProperties()
	
	self.initialized = true
end


-- import function
function get_mission_properties()
	return mission_properties
end
