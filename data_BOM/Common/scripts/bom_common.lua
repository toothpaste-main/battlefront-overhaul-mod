--[[
	Battlefront Mission Helper
	Module name: bom_common
	Description: Common constants for the Battlefront Overhaul Mod
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-08
	Dependencies: tableUtils
	Notes:
--]]
local bom_common = {
	name = "bom_common",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")

PS2_MEMORY = 4000000 -- 4MB


------------------------------------------------
------------   TEAM DISTRIBUTION   -------------
------------------------------------------------

-- side config files
local SIDE_CONFIG_FILE_NAMES = {
	["all"] = "all_config",
	["cis"] = "cis_config",
	["imp"] = "imp_config",
	["rep"] = "rep_config",
}
function bom_common.getSideConfigFileNames(side) return tableUtils.copyTable(tableUtils.elementOrTable(SIDE_CONFIG_FILE_NAMES, side)) end

-- load side configs
for _, configFileName in pairs(SIDE_CONFIG_FILE_NAMES) do
	ScriptCB_DoFile(configFileName)
end

-- maximum units on each team
local MAX_UNITS = 32
function bom_common.getMaxUnits() return MAX_UNITS end

-- number of reinforcements
local REINFORCEMENTS = 200
function bom_common.getReinforcements() return REINFORCEMENTS end

-- unit types and AI restrictions
local UNIT_TYPES = {
	soldier = {minUnits = 10, maxUnits = MAX_UNITS},
	assault = {minUnits = 2, maxUnits = 6},
	sniper = {minUnits = 1, maxUnits = 6},
	engineer = {minUnits = 1, maxUnits = 4},
	officer = {minUnits = 1, maxUnits = 4},
	special = {minUnits = 1, maxUnits = 4},
	pilot = {minUnits = 10, maxUnits = MAX_UNITS},
	marine = {minUnits = 10, maxUnits = MAX_UNITS},
}
function bom_common.getUnitTypes() return tableUtils.copyTable(UNIT_TYPES) end

-- ground unit types
local GROUND_UNITS = {
	soldier = UNIT_TYPES.soldier,
	assault = UNIT_TYPES.assault,
	sniper = UNIT_TYPES.sniper,
	engineer = UNIT_TYPES.engineer,
	officer = UNIT_TYPES.officer,
	special = UNIT_TYPES.special,
}
function bom_common.getGroundUnitTypes() return tableUtils.copyTable(GROUND_UNITS) end

-- space unit types
local SPACE_UNITS = {
	pilot = UNIT_TYPES.pilot,
	marine = UNIT_TYPES.marine,
}
function bom_common.getSpaceUnitTypes() return tableUtils.copyTable(SPACE_UNITS) end

-- The following is formatted as:
-- unit class
-- maximum ai in class
-- minimum ai in class

-- soldier
MAX_SOLDIER = MAX_UNITS
MIN_SOLDIER = 10

-- assault
MAX_ASSAULT = 6
MIN_ASSAULT = 2

-- sniper
MAX_SNIPER = 6
MIN_SNIPER = 1

-- engineer
MAX_ENGINEER = 4 
MIN_ENGINEER = 1

-- officer
MAX_OFFICER = 4
MIN_OFFICER = 1

-- specialist
MAX_SPECIAL = 4
MIN_SPECIAL = 1


------------------------------------------------
------------   UBER_MODE   ---------------------
------------------------------------------------

-- remove the unit cap
UBER_MODE = 0

-- maximum units on each team
UBER_MAX_UNITS = 200

-- number of reinforcements
UBER_DEFAULT_REINFORCEMENTS = 1000

-- The following is formatted as:
-- unit class
-- maximum ai in class
-- minimum ai in class

-- soldier
UBER_MAX_SOLDIER = UBER_MAX_UNITS
UBER_MIN_SOLDIER = 10

-- assault
UBER_MAX_ASSAULT = 40
UBER_MIN_ASSAULT = 2

-- sniper
UBER_MAX_SNIPER = 20
UBER_MIN_SNIPER = 1

-- engineer
UBER_MAX_ENGINEER = 10
UBER_MIN_ENGINEER = 1

-- officer
UBER_MAX_OFFICER = 30
UBER_MIN_OFFICER = 1

-- specialist
UBER_MAX_SPECIAL = 30
UBER_MIN_SPECIAL = 1


------------------------------------------------
------------   AI RULES   ----------------------
------------------------------------------------

-- SetSpawnDelay(AI_WAVE_SPAWN_DELAY, PERCENTAGE_AI_RESPAWNED)
AI_WAVE_SPAWN_DELAY = 10.0		-- wave spawn delay for AI
PERCENTAGE_AI_RESPAWNED = 0.25	-- percentage of AI respawned with each wave


------------------------------------------------
------------   META   -------------
------------------------------------------------

-- assault
ASSAULT_MINES = 4

-- sniper
SNIPER_TURRETS = 1


-- import function
function get_bom_common()
	return bom_common
end
