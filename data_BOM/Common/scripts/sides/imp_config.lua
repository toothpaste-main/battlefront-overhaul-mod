--[[
	Battlefront Overhaul Mod
	Module name: imp_config
	Description: Empire configuration data
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-08
	Dependencies: table_utils
	Notes:
--]]
local imp_config = {
	name = "imp_config",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")


local UNIT_CONFIGS = {
	soldier = {
		basic = "imp_inf_rifleman",
		basic_atat_snow = "imp_inf_rifleman_snow",
		basic_snow = "imp_inf_rifleman_snow",
		army = "imp_inf_rifleman_armytrooper",
		army_pilot = "imp_inf_rifleman_armytrooper",
	},
	
	assault = {
		basic = "imp_inf_rocketeer",
		basic_atat_snow = "imp_inf_rocketeer_snow",
		basic_snow = "imp_inf_rocketeer_snow",
		army = "imp_inf_rocketeer_armytrooper",
		army_pilot = "imp_inf_rocketeer_armytrooper",
	},
	
	sniper = {
		basic = "imp_inf_sniper",
		basic_atat_snow = "imp_inf_sniper_snow",
		basic_snow = "imp_inf_sniper_snow",
	},
	
	engineer = {
		basic = "imp_inf_engineer_gunner",
		basic_atat = "imp_inf_engineer_atat",
		basic_atat_snow = "imp_inf_engineer_atat",
		--basic_atst = "imp_inf_engineer_atst", -- no atst support
		basic_pilot = "imp_inf_engineer_pilot",
		--basic_snow = "imp_inf_engineer_snow", -- no snow support
		fleet_pilot = "imp_inf_engineer_pilot",
	},
	
	officer = {
		basic = "imp_inf_officer_stormtrooper",
		basic_atat = "imp_inf_officer_atat",
		basic_atat_snow = "imp_inf_officer_atat",
		--basic_snow = "imp_inf_officer_snow", -- no snow support
		army = "imp_inf_officer_fleet",
		army_pilot = "imp_inf_officer_fleet",
		fleet = "imp_inf_officer_fleet",
		fleet_pilot = "imp_inf_officer_fleet",
	},
	
	special = {
		basic = "imp_inf_darktrooper",
	},
	
	pilot = {
		basic = "",
	},
	
	marine = {
		basic = "",
	},
}
function imp_config.getUnitConfigs() return tableUtils.copyTable(UNIT_CONFIGS) end


local STOCK_UNIT_CONFIGS = {
	soldier = {
		basic = {"imp_inf_rifleman"},
		basic_atat_snow = {"imp_inf_rifleman_snow"},
		basic_snow = {"imp_inf_rifleman_snow"},
	},
	
	assault = {
		basic = {"imp_inf_rocketeer"},
		basic_atat_snow = {"imp_inf_rocketeer_snow"},
		basic_snow = {"imp_inf_rocketeer_snow"},
	},
	
	sniper = {
		basic = {"imp_inf_sniper"},
		basic_atat_snow = {"imp_inf_sniper_snow"},
		basic_snow = {"imp_inf_sniper_snow"},
	},
	
	engineer = {
		basic = {"imp_inf_engineer"},
		basic_atat = {"imp_inf_engineer_snow"},
		basic_atat_snow = {"imp_inf_engineer_snow"},
		basic_pilot = {"imp_inf_engineer", "imp_inf_pilot"},
		fleet_pilot = {"imp_inf_engineer", "imp_inf_pilot"},
	},
	
	officer = {
		basic = {"imp_inf_officer"},
	},
	
	special = {
		basic = {"imp_inf_dark_trooper"},
	},
	
	pilot = {
		basic = {"imp_inf_pilot"},
	},
	
	marine = {
		basic = {"imp_inf_marine"},
	},
}
function imp_config.getStockUnitConfigs() return tableUtils.copyTable(STOCK_UNIT_CONFIGS) end


-- import function
function get_imp_config()
	return imp_config
end
