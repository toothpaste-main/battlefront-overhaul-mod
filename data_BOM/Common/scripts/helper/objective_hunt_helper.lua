--[[
	Battlefront Mission Helper
	Module name: objective_hunt_helper
	Description: Helper module for hunt set up
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-21
	Dependencies: constants, objective_tdm_helper
	Notes: All parameters are assumed to be strings unless stated 
		   otherwise.
--]]
local objective_hunt_helper = {
	name = "objective_hunt_helper",
	version = 1.0,
	
	initialized = false,
}

-- load dependencies
ScriptCB_DoFile("import")
local constants = import("constants")
local objectiveTDMHelper = import("objective_tdm_helper")


------------------------------------------------
------------   POINTS PER KILL  ----------------
------------------------------------------------

-- endor
END1_PPK_ATT = 1 -- empire
END1_PPK_DEF = 1 -- ewoks

-- hoth
HOT1_PPK_ATT = 1 -- wamps
HOT1_PPK_DEF = 2 -- alliance

-- kashyyyk
HOT1_PPK_ATT = 1 -- cis
HOT1_PPK_DEF = 1 -- wookiees

-- mos eisley
TAT2_PPK_ATT = 2 -- tuskens
TAT2_PPK_DEF = 1 -- jawas

-- naboo
NAB2_PPK_ATT = 1 -- cis
NAB2_PPK_DEF = 1 -- naboo inhabitants


------------------------------------------------
------------   TEAM DISTRIBUTION   -------------
------------------------------------------------

-- endor
END1_MAX_EWK_UNITS = 32
END1_MAX_IMP_UNITS = 32

-- hoth
HOT_MAX_ALL_UNITS = 32
HOT_MAX_WAM_UNITS = 12

-- kashyyyk
KAS2_MAX_CIS_UNITS = 32
KAS2_MAX_WOK_UNITS = 32

-- mos eisley
TAT2_MAX_JAW_UNITS = 32
TAT2_MAX_TUS_UNITS = 32

-- naboo
NAB2_MAX_UNITS = 32
NAB2_NUM_GUNGANS = NAB2_MAX_UNITS / 2
NAB2_MAX_SPECIAL = 2
NAB2_MIN_SPECIAL = 0


------------------------------------------------
------------   UNIT TYPES   --------------------
------------------------------------------------

-- cis
CIS_SOLDIER_CLASS		= "cis_inf_bdroid_hunt"
CIS_OFFICER_CLASS		= "cis_inf_magnaguard_hunt"
CIS_SPECIAL_CLASS		= "cis_inf_droideka_hunt"

-- empire
IMP_SNIPER_CLASS		= "imp_inf_sniper"

-- ewoks
EWK_SOLDIER_CLASS		= "ewk_inf_trooper"
EWK_SNIPER_CLASS		= "ewk_inf_scout"
EWK_ENGINEER_CLASS		= "ewk_inf_mechanic"

-- geonosians
GEO_SOLDIER_CLASS		= "geo_inf_geonosian"

-- gungans
GUN_SOLDIER_CLASS		= "gun_inf_soldier"
GUN_ENGINEER_CLASS		= "gun_inf_defender"

-- jawas
JAW_SOLDIER_CLASS		= "tat_inf_jawa"

-- naboo guard
NAB_OFFICER_CLASS		= "gar_inf_soldier_light"

-- republic
REP_SNIPER_CLASS		= "tur_bldg_geoturret"

-- tuskens
TUS_SOLDIER_CLASS		= "tat_inf_tuskenraider"
TUS_SNIPER_CLASS		= "tat_inf_tuskenhunter"

-- wookiees
WOK_SOLDIER_CLASS		= "wok_inf_warrior"
WOK_ROCKETEER_CLASS		= "wok_inf_rocketeer"
WOK_ENGINEER_CLASS		= "wok_inf_mechanic"

-- wampas
WAM_SOLDIER_CLASS		= "snw_inf_wampa"


------------------------------------------------
------------   UNIT PROPERTIES   ---------------
------------------------------------------------

-- cis

-- empire

-- ewoks
EWK_HEALTH = 60 -- pistol dmg is 50

-- gungans

-- jawas

-- magnaguards

-- naboo guard

-- tuskens

-- wampas

-- wookiees


------------------------------------------------
------------   OBJECTIVE PROPERTIES   ----------
------------------------------------------------

-- endor
TEXT_ATT_END1 = "level.end1.objectives.hunt"

-- kashyyyk
TEXT_ATT_KAS2 = "level.kas2.hunt.ATT"
TEXT_DEF_KAS2 = "level.kas2.hunt.DEF"

local MULTIPLAYER_RULES = true


---------------------------------------------------------------------------
-- FUNCTION:    initHunt
-- PURPOSE:     Create hunt objective
-- INPUT:		params = {teamATT, teamDEF,
--						  textATT, textDEF,
--						  pointsPerKillATT, pointsPerKillDEF,
--						  goalWeightATT, goalWeightDEF,
--						  multiplayerRules,
--						  delayStart}
-- OUTPUT:		ObjectiveTDM
-- NOTES:       The function is purely a mask to 
--				`createDeathmatchObjective()` and is functionally the same.
---------------------------------------------------------------------------
function objective_hunt_helper:initHunt(params)	
	assert(not self.initialized, "ERROR: " .. self.name .. " has already been initialized!")

	-- objective text params
	params.textATT = params.textATT or constants.getTextATT("hunt")
	params.textDEF = params.textDEF or constants.getTextDEF("hunt")
	
	-- multiplayer rules params
	params.multiplayerRules = params.multiplayerRules or MULTIPLAYER_RULES

	-- create objective
	self.objective = objectiveTDMHelper:initTDM(params)
	
	self.initialized = true
	return self.objective
end


-- import function
function get_objective_hunt_helper()
	return objective_hunt_helper
end
