--[[
	Battlefront Mission Helper
	Module name: constants
	Description: Constants and limitations of Star Wars: Battlefront II (2005)
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-20
	Dependencies: tableUtils
	Notes:
--]]
local constants = {
	name = "constants",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")


------------------------------------------------
------------   FLAG GEOMETRY   -----------------
------------------------------------------------

-- flag geometry on the ground
local FLAG_GEOMETRY = {
	["all"] = "com_icon_alliance_flag",
	["cis"] = "com_icon_cis_flag",
	["imp"] = "com_icon_imperial_flag",
	["rep"] = "com_icon_republic_flag",
}
function constants.getFlagGeometry(team) return tableUtils.elementOrTable(FLAG_GEOMETRY, team) end

-- flag geometry when carried
local FLAG_GEOMETRY_CARRIED = {
	["all"] = "com_icon_alliance_flag_carried",
	["cis"] = "com_icon_cis_flag_carried",
	["imp"] = "com_icon_imperial_flag_carried",
	["rep"] = "com_icon_republic_flag_carried",
}
function constants.getFlagGeometryCarried(team) return tableUtils.elementOrTable(FLAG_GEOMETRY_CARRIED, team) end


------------------------------------------------
------------   TEAM PROPERTIES   ---------------
------------------------------------------------

-- constants of life
local ATT = 1 -- attacker is always #1
function constants.getATT() return ATT end
local DEF = 2
function constants.getDEF() return DEF end

-- abbreviated stock team names
local TEAM_NAMES_SHORT = {
	"all", 
	"cis", 
	"ewk", 
	"gam", 
	"gar", 
	"geo", 
	"gun", 
	"imp", 
	"jaw", 
	"rep", 
	"tus", 
	"wam", 
	"wok",
}
function constants.getTeamNamesShort() return TEAM_NAMES_SHORT end

-- stock team names
local TEAM_NAMES_LONG = {
	"alliance",
	"cis", 
	"ewok", 
	"gammorean guard",
	"naboo guard", 
	"geonosian", 
	"gungan", 
	"empire", 
	"jawa", 
	"republic", 
	"tuskan", 
	"wampa", 
	"wookie",
}
function constants.getTeamNamesLong() return TEAM_NAMES_LONG end

-- combine short and long names into pairs
function constants.getTeamNamesShortToLong() return tableUtils.combineTables(TEAM_NAMES_SHORT, TEAM_NAMES_LONG) end
function constants.getTeamNamesLongToShort() return tableUtils.combineTables(TEAM_NAMES_LONG, TEAM_NAMES_SHORT) end


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- there is one flag in 1-flag CTF
local NUM_FLAGS_ONE_FLAG_FLAG = 1
function constants.getNumFlagsOneFlag() return NUM_FLAGS_ONE_FLAG_FLAG end

-- there are two flags in 2-flag CTF
local NUM_FLAGS_CTF = 2
function constants.getNumFlagsCTF() return NUM_FLAGS_CTF end

-- flag icon
local ICON_FLAG = "flag_icon"
function constants.getIconFlag() return ICON_FLAG end

-- circle icon
local ICON_CIRCLE = "hud_objective_icon_circle"
function constants.getIconCircle() return ICON_CIRCLE end


------------------------------------------------
------------   OBJECTIVE TEXT   ----------------
------------------------------------------------

-- att
local TEXT_ATT = {
	oneFlag = "game.modes.1flag",
	conquest = "game.modes.con",
	ctf = "game.modes.ctf",
	hunt = "game.modes.hunt",
	tdm = "game.modes.tdm",
}
function constants.getTextATT(objective) return tableUtils.elementOrTable(TEXT_ATT, objective) end

-- def
local TEXT_DEF = {
	oneFlag = "game.modes.1flag2",
	conquest = "game.modes.con2",
	ctf = "game.modes.ctf2",
	hunt = "game.modes.hunt2",
	tdm = "game.modes.tdm2",
}
function constants.getTextDEF(objective) return tableUtils.elementOrTable(TEXT_DEF, objective) end

------------------------------------------------
------------   BF2 LIMITATIONS   ---------------
------------------------------------------------
--
-- See the following for more BF2 limitations:
-- http://www.gametoast.com/viewtopic.php?f=27&t=13034
--

-- maximum simultaneously active regions
local MAX_ACTIVE_REGIONS = 64
function constants.getMaxActiveRegions() return MAX_ACTIVE_REGIONS end

-- maximum amera shots (more can be loaded but will never appear)
local MAX_CAMERA_SHOTS = 16
function constants.getMaxCameraShots() return MAX_CAMERA_SHOTS end

-- maximum amount of command posts including command vehicles
local MAX_COMMAND_POSTS = 16
function constants.getMaxCommandPosts() return MAX_COMMAND_POSTS end

-- maximum path nodes that can exist on a map (Zero editor will not let exceed this amount)
local MAX_PATH_NODES = 256
function constants.getMaxPathNodes() return MAX_PATH_NODES end

-- maximum playable teams in a given game (first two teams loaded are playable)
local MAX_PLAYABLE_TEAMS = 2
function constants.getMaxPlayableTeams() return MAX_PLAYABLE_TEAMS end

-- maximum powerup items spawned on the ground
local MAX_POWERUP_ITEM = 25
function constants.getMaxPowerupItem() return MAX_POWERUP_ITEM end

-- maximum selectable units on a given team (including heroes)
local MAX_SELECTABLE_UNITS = 10
function constants.getMaxSelectableUnits() return MAX_SELECTABLE_UNITS end

-- maximum teams in any given game (team = 0 is an option)
local MAX_TEAMS = 9
function constants.getMaxTeams() return MAX_TEAMS end

-- maximum amount of tentacles that can be defined in an odf
local MAX_TENTACLES_PER_UNIT = 4
function constants.getMaxTentaclesPerUnits() return MAX_TENTACLES_PER_UNIT end

-- maximum weapons that can exist in a weapon slot while sitting in a vehicle seat
local MAX_VEHICLE_WEAPONS_PER_WEAPON_SLOT = 1
function constants.getMaxVehicleWeaponsPerWeaponSlot() return MAX_VEHICLE_WEAPONS_PER_WEAPON_SLOT end

-- maximum number of weapon slots (not total weapons in all slots)
local MAX_WEAPON_SLOTS = 2
function constants.getMaxWeaponSlots() return MAX_WEAPON_SLOTS end

-- maximum weapons that a single unit can conrol in a vehicle seat
local MAX_VEHICLE_WEAPONS_PER_SEAT = MAX_WEAPON_SLOTS * MAX_VEHICLE_WEAPONS_PER_WEAPON_SLOT
function constants.getMaxVehicleWeaponsPerSeat() return MAX_VEHICLE_WEAPONS_PER_SEAT end 

-- maximum weapons per unit (any combination of primary and secondary weapons)
local MAX_WEAPONS_PER_UNIT = 8
function constants.getMaxWeaponsPerUnit() return MAX_WEAPONS_PER_UNIT end

-- maximum world extents before game crash
local MAX_WORLD_EXTENTS = 19000
function constants.getMaxWorldExtents() return MAX_WORLD_EXTENTS end


-- import function
function get_constants()
	return constants
end