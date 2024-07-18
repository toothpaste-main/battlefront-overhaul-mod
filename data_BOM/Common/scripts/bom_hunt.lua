--
-- Battlefront Overhaul Mod
-- Author: ToothpasteMaine
--
-- Constants and functions related to the hunt
-- game mode.
--
print("Loading bom_hunt.lua...")

-- load dependencies
ScriptCB_DoFile("bom_deathmatch")

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

-- gungans
GUN_SOLDIER_CLASS		= "gun_inf_soldier"
GUN_ENGINEER_CLASS		= "gun_inf_defender"

-- jawas
JAW_SOLDIER_CLASS		= "tat_inf_jawa"

-- naboo guard
NAB_OFFICER_CLASS		= "gar_inf_soldier_light"

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

-- message text for player (hunt)
local TEXT_ATT_HUNT = "game.modes.hunt"
local TEXT_DEF_HUNT = "game.modes.hunt2"

-- endor
TEXT_ATT_END1 = "level.end1.objectives.hunt"

-- kashyyyk
TEXT_ATT_KAS2 = "level.kas2.hunt.ATT"
TEXT_DEF_KAS2 = "level.kas2.hunt.DEF"

local MULTIPLAYER_RULES_HUNT = true


---------------------------------------------------------------------------
-- FUNCTION:    createHuntObjective
-- PURPOSE:     Create hunt objective
-- INPUT:		params = {teamATT, teamDEF,
--						  textATT, textDEF,
--						  pointsPerKillATT, pointsPerKillDEF,
--						  delayStart}
-- OUTPUT:		ObjectiveTDM
-- NOTES:       The function is purely a mask to 
--				`createDeathmatchObjective()` and is functionally the same.
---------------------------------------------------------------------------
function createHuntObjective(params)	
	-- message text params
	local textATT_ = params.textATT or TEXT_ATT_HUNT
	local textDEF_ = params.textDEF or TEXT_DEF_HUNT
	
	params.multiplayerRules = MULTIPLAYER_RULES_HUNT

	-- create objective
	local hunt = createDeathmatchObjective(params)
	
	return hunt
end
