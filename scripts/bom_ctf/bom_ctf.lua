--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v1.0
--
-- Constants and functions related to both the 
-- CTF and 1-Flag game modes.
--
print("Loading bom_ctf.lua...")


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

-- there are two flags in CTF (used in error checking)
local NUM_FLAGS_CTF = 2


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


---------------------------------------------------------------------------
-- FUNCTION:    setCaptureRegions
-- PURPOSE:     Saves names of capture regions to local memory
-- INPUT:		params = {allCaptureRegion = "", cisCaptureRegion = "", 
--						  impCaptureRegion = "", repCaptureRegion = ""} 
-- OUTPUT:
-- NOTES:       There is an expected number of capture regions provided set
--				by NUM_FLAGS_CTF. If the expected quantity is not met, then 
--				an error is thrown. That is, unless the capture regions
--				have been previously saved.
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
		if flagCount ~= NUM_FLAGS_CTF then
			error("Expected " .. NUM_FLAGS_CTF .. " capture regions, got " .. flagCount)
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setFlagNames
-- PURPOSE:     Saves flag names to local memory
-- INPUT:		params = {allFlagName = "", cisFlagName = "", 
--						  impFlagName = "", repFlagName = ""} 
-- OUTPUT:
-- NOTES:       There is an expected number of flag names provided set by
--				NUM_FLAGS_CTF. If the expected quantity is not met, then an 
--				error is thrown. That is, unless the flag names have been 
--				previously saved.
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
		if flagCount ~= NUM_FLAGS_CTF then
			error("Expected " .. NUM_FLAGS_CTF .. " flag names, got " .. flagCount)
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setHomeRegions
-- PURPOSE:     Saves names of home regions to local memory
-- INPUT:		params = {allHomeRegion = "", cisHomeRegion = "", 
--						  impHomeRegion = "", repHomeRegion = ""} 
-- OUTPUT:
-- NOTES:       There is an expected number of capture regions provided set
--				by NUM_FLAGS_CTF. If the expected quantity is not met, then 
--				an error is thrown. That is, unless the capture regions
--				have been previously saved.
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
		if flagCount ~= NUM_FLAGS_CTF then
			-- print instead of error because home regions are not required
			print("Expected " .. NUM_FLAGS_CTF .. " home regions, got " .. flagCount .. " (this is does not mean there is an error)")
		end
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    setFlagGeometry
-- PURPOSE:     Set CTF flag gemoetry
-- INPUT:		params = {allFlagName = "", impFlagName = "", 
--						  repFlagName = "", cisFlagName = ""} 
-- OUTPUT:
-- NOTES:       Calls setFlagNames(params)
---------------------------------------------------------------------------
function setFlagGeometry(params)
	-- save flag names
	setFlagNames(params)
	
	-- log when geometry set
	local function printToLog(team)
		print("Set flag geometry for: " .. team)
	end
	
	-- alliance
	if flagNames.allFlagName then
		SetProperty(flagNames.allFlagName, "GeometryName", ALL_GEO_NAME)
		SetProperty(flagNames.allFlagName, "CarriedGeometryName", ALL_GEO_NAME_CARRIED)
		printToLog("alliance")
	end
	
	-- cis
	if flagNames.cisFlagName then
		SetProperty(flagNames.cisFlagName, "GeometryName", CIS_GEO_NAME)
		SetProperty(flagNames.cisFlagName, "CarriedGeometryName", CIS_GEO_NAME_CARREID)
		printToLog("cis")
	end
	
	-- empire
	if flagNames.impFlagName then
		SetProperty(flagNames.impFlagName, "GeometryName", IMP_GEO_NAME)
		SetProperty(flagNames.impFlagName, "CarriedGeometryName", IMP_GEO_NAME_CARRIED)
		printToLog("empire")
	end
	
	-- republic
	if flagNames.repFlagName then
		SetProperty(flagNames.repFlagName, "GeometryName", REP_GEO_NAME)
		SetProperty(flagNames.repFlagName, "CarriedGeometryName", REP_GEO_NAME_CARREID)
		printToLog("republic")
	end
	
	-- set flag visibility when dropped
	SetClassProperty("com_item_flag", "DroppedColorize", DROP_COLORIZE)	
end


---------------------------------------------------------------------------
-- FUNCTION:    setOneFlagProperties
-- PURPOSE:     Saves 1-flag properties to memory
-- INPUT:		params = {flagName = "", homeRegion = "", 
--						  attCaptureRegion = "", defCaptureRegion = ""} 
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
-- FUNCTION:    createCTFObjective
-- PURPOSE:     Create CTF objective and add flags to the objective
-- INPUT:		params = {allFlagName = "", cisFlagName = "", 
--						  impFlagName = "", repFlagName = "",
--						  allHomeRegion = "", cisHomeRegion = "",
--						  impHomeRegion = "", repHomeRegion = "",
--						  allCaptureRegion = "", cisCaptureRegion = "",
-- 						  impCaptureRegion = "", repCaptureRegion = ""}
-- OUTPUT:		ObjectiveCTF
-- NOTES:       Calls setFlagNames(params), setHomeRegions(params), and
--				setCaptureRegions(params) in that order.
---------------------------------------------------------------------------
function createCTFObjective(params)

	------------------------------------------------
	------------   CREATE OBJECTIVE   --------------
	------------------------------------------------
	
	-- team numbers
	local ATT = params.teamATT or 1 -- attacker is always #1
	local DEF = params.teamDEF or 2
	
	-- create objective
	local ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, 
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
	local function printToLog(team)
		print("Added flag to CTF objective: " .. team)
	end
	
	-- add alliance flag
	if flagNames.allFlagName then
		ctf:AddFlag{name = flagNames.allFlagName, 
					homeRegion = params.allHomeRegion, captureRegion = captureRegions.allCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog("alliance")
	end
    
	-- add cis flag
	if flagNames.cisFlagName then
		ctf:AddFlag{name = flagNames.cisFlagName, 
					homeRegion = params.cisHomeRegion, captureRegion = captureRegions.cisCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog("cis")
	end
	
	-- add empire flag
	if flagNames.impFlagName then
		ctf:AddFlag{name = flagNames.impFlagName, 
					homeRegion = params.impHomeRegion, captureRegion = captureRegions.impCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog("empire")
	end
	
	-- add republic flag
	if flagNames.repFlagName then
		ctf:AddFlag{name = flagNames.repFlagName, 
					homeRegion = params.repHomeRegion, captureRegion = captureRegions.repCaptureRegion,
					capRegionMarker = CAP_REG_MRK, capRegionMarkerScale = CAP_REG_MRK_SCL, 
					icon = ICON, mapIcon = FLAG_ICON, mapIconScale = FLAG_ICON_SCL}
		printToLog("republic")
	end
	
	return ctf
end


---------------------------------------------------------------------------
-- FUNCTION:    createOneFlagObjective
-- PURPOSE:     Create 1-flag objective
-- INPUT:		params = {flagName = "", homeRegion = "", 
--						  attCaptureRegion = "", defCaptureRegion = ""}
-- OUTPUT:		ObjectiveOneFlagCTF
-- NOTES:       Calls setFlagNames(params), setHomeRegions(params), and
--				setCaptureRegions(params) in that order.
---------------------------------------------------------------------------
function createOneFlagObjective(params)
	-- team numbers
	local ATT = params.teamATT or 1 -- attacker is always #1
	local DEF = params.teamDEF or 2
	
	-- save 1flag properties
	setOneFlagProperties(params)
	
	-- create objective
	ctf = ObjectiveOneFlagCTF:New{teamATT = ATT, teamDEF = DEF,
							      textATT = TEXT_ATT_1FLAG, textDEF = TEXT_DEF_1FLAG,
								  flag = oneFlag.flagName, homeRegion = oneFlag.homeRegion,
								  captureRegionATT = oneFlag.attCaptureRegion, captureRegionDEF = oneFlag.defCaptureRegion,
								  capRegionMarkerATT = CAP_REG_MRK_ATT, capRegionMarkerDEF = CAP_REG_MRK_DEF,
								  capRegionMarkerScaleATT = CAP_REG_MRK_ATT_SCL, capRegionMarkerScaleDEF = CAP_REG_MRK_DEF_SCL,
								  flagIcon = FLAG_ICON, flagIconScale = FLAG_ICON_SCL, 
							      captureLimit = CAP_LIMIT_1FLAG,
							      hideCPs = HIDE_CPS_1FLAG,
								  multiplayerRules = MULTIPLAYER_RULES_1FLAG}
	print("Created: ObjectiveOneFlagCTF")
	
	return ctf
end