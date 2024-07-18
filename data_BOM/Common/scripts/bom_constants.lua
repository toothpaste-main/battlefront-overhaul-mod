--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMain 
-- Version: v1.0
--
-- Constants which represent constants and
-- limitations of the Zero game engine or 
-- general practical imitations.
--
print("Loading bom_constants.lua...")


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

local NUM_FLAGS_1FLAG = 1
function getNumFlags1Flag() return NUM_FLAGS_1FLAG end

-- there are two flags in 2-flag CTF
local NUM_FLAGS_CTF = 2
function getNumFlagsCTF() return NUM_FLAGS_CTF end


------------------------------------------------
------------   TEAM PROPERTIES   ---------------
------------------------------------------------

-- constants of life
local ATT = 1 -- attacker is always #1
function getATT() return ATT end
local DEF = 2
function getDEF() return DEF end

-- stock team names
local TEAM_NAMES_LONG = {"alliance", "cis", "ewok", "gammorean guard",
						 "naboo guard", "geonosian", "gungan", "empire", 
						 "jawa", "republic", "tuskan", "wampa", 
						 "wookie"}
function getTeamNamesLong() return TEAM_NAMES_LONG end

-- abbreviated stock team names
local TEAM_NAMES_SHORT = {"all", "cis", "ewk", "gam", 
						  "gar", "geo", "gun", "imp", 
						  "jaw", "rep", "tus", "wam", 
						  "wok"}
function getTeamNamesShort() return TEAM_NAMES_SHORT end


------------------------------------------------
------------   BF2 LIMITATIONS   ---------------
------------------------------------------------
--
-- See the following for more BF2 limitations:
-- http://www.gametoast.com/viewtopic.php?f=27&t=13034
--

-- maximum simultaneously active regions
local MAX_ACTIVE_REGIONS = 64
function getMaxActiveRegions() return MAX_ACTIVE_REGIONS end

-- maximum amera shots (more can be loaded but will never appear)
local MAX_CAMERA_SHOTS = 16
function getMaxCameraShots() return MAX_CAMERA_SHOTS end

-- maximum amount of command posts including command vehicles
local MAX_COMMAND_POSTS = 16
function getMaxCommandPosts() return MAX_COMMAND_POSTS end

-- maximum path nodes that can exist on a map (Zero editor will not let exceed this amount)
local MAX_PATH_NODES = 256
function getMaxPathNodes() return MAX_PATH_NODES end

-- maximum playable teams in a given game (first two teams loaded are playable)
local MAX_PLAYABLE_TEAMS = 2
function getMaxPlayableTeams() return MAX_PLAYABLE_TEAMS end

-- maximum powerup items spawned on the ground
local MAX_POWERUP_ITEM = 25
function getMaxPowerupItem() return MAX_POWERUP_ITEM end

-- maximum selectable units on a given team (including heroes)
local MAX_SELECTABLE_UNITS = 10
function getMaxSelectableUnits() return MAX_SELECTABLE_UNITS end

-- maximum teams in any given game (team = 0 is an option)
local MAX_TEAMS = 9
function getMaxTeams() return MAX_TEAMS end

-- maximum amount of tentacles that can be defined in an odf
local MAX_TENTACLES_PER_UNIT = 4
function getMaxTentaclesPerUnits() return MAX_TENTACLES_PER_UNIT end

-- maximum weapons that can exist in a weapon slot while sitting in a vehicle seat
local MAX_VEHICLE_WEAPONS_PER_WEAPON_SLOT = 1
function getMaxVehicleWeaponsPerWeaponSlot() return MAX_VEHICLE_WEAPONS_PER_WEAPON_SLOT end

-- maximum number of weapon slots (not total weapons in all slots)
local MAX_WEAPON_SLOTS = 2
function getMaxWeaponSlots() return MAX_WEAPON_SLOTS end

-- maximum weapons that a single person can conrol in a vehicle seat
local MAX_VEHICLE_WEAPONS_PER_SEAT = getMaxWeaponSlots() * getMaxVehicleWeaponsPerWeaponSlot()
function getMaxVehicleWeaponsPerSeat() return MAX_VEHICLE_WEAPONS_PER_SEAT end 

--  any combination of primary and secondary weapons
local MAX_WEAPONS_PER_UNIT = 8
function getMaxWeaponsPerUnit() return MAX_WEAPONS_PER_UNIT end

-- maximum world extents before game crash
local MAX_WORLD_EXTENTS = 19000
function getMaxWorldExtents() return MAX_WORLD_EXTENTS end
