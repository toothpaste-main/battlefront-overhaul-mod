--[[
	Battlefront Overhaul Mod
	Module name: all_config
	Description: Alliance configuration data
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-08
	Dependencies: table_utils
	Notes:
--]]
local all_config = {
	name = "all_config",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")


local UNIT_CONFIGS = {
	soldier = {
		basic = "all_inf_rifleman_desert",
		basic_desert = "all_inf_rifleman_desert",
		basic_jungle = "all_inf_rifleman_jungle",
		basic_jungle_pilot = "all_inf_rifleman_jungle",
		basic_snow = "all_inf_rifleman_snow",
		basic_snow_pilot = "all_inf_rifleman_snow",
		basic_urban = "all_inf_rifleman_urban",
		basic_urban_pilot = "all_inf_rifleman_urban",
		fleet = "all_inf_rifleman_fleet",
		fleet_pilot = "all_inf_rifleman_fleet",
		fleet_urban = "all_inf_rifleman_urban",
		fleet_urban_pilot = "all_inf_rifleman_urban",
	},
	
	assault = {
		basic = "all_inf_rocketeer_jungle", -- TODO: update when desert support added
		--basic_desert = "all_inf_rocketeer_desert", -- no desert support
		basic_jungle = "all_inf_rocketeer_jungle",
		basic_jungle_pilot = "all_inf_rocketeer_jungle",
		basic_snow = "all_inf_rocketeer_snow",
		basic_snow_pilot = "all_inf_rocketeer_snow",
		--basic_urban = "all_inf_assault_urban", -- no urban support
		--basic_urban_pilot = "all_inf_assault_urban",
		fleet = "all_inf_rocketeer_fleet",
		fleet_pilot = "all_inf_rocketeer_fleet",
		fleet_urban = "all_inf_rocketeer_fleet",
		fleet_urban_pilot = "all_inf_rocketeer_fleet",
	},
	
	sniper = {
		basic = "all_inf_sniper_desert",
		basic_desert = "all_inf_sniper_desert",
		basic_jungle = "all_inf_sniper_jungle",
		basic_jungle_pilot = "all_inf_sniper_jungle",
		basic_snow = "all_inf_sniper_snow",
		basic_snow_pilot = "all_inf_sniper_snow",
		basic_urban = "all_inf_sniper_urban",
		basic_urban_pilot = "all_inf_sniper_urban",
		fleet = "all_inf_sniper_fleet",
		fleet_pilot = "all_inf_sniper_fleet",
		fleet_urban = "all_inf_sniper_fleet",
		fleet_urban_pilot = "all_inf_sniper_fleet",
	},
	
	engineer = {
		basic = "all_inf_engineer_bothan",
		basic_jungle_pilot = "all_inf_engineer_pilot",
		basic_snow_pilot = "all_inf_engineer_pilot",
		basic_urban_pilot = "all_inf_engineer_pilot",
		fleet_pilot = "all_inf_engineer_pilot",
		fleet_urban_pilot = "all_inf_engineer_pilot",
	},
	
	officer = {
		basic = "all_inf_officer_desert",
		basic_desert = "all_inf_officer_desert",
		basic_jungle = "all_inf_officer_jungle",
		basic_jungle_pilot = "all_inf_officer_jungle",
		basic_snow = "all_inf_officer_snow",
		basic_snow_pilot = "all_inf_officer_snow",
		basic_urban = "all_inf_officer_urban",
		basic_urban_pilot = "all_inf_officer_urban",
		--fleet_urban = "all_inf_officer_urban",
		--fleet_urban_pilot = "all_inf_officer_urban",
	},
	
	special = {
		basic = "all_inf_wookiee",
		basic_snow = "all_inf_wookiee_snow",
		basic_snow_pilot = "all_inf_wookiee_snow",
	},
	
	pilot = {
		basic = "",
	},
	
	marine = {
		basic = "",
	},
}
function all_config.getUnitConfigs() return tableUtils.copyTable(UNIT_CONFIGS) end


local STOCK_UNIT_CONFIGS = {
	soldier = {
		basic = {"all_inf_rifleman_desert"},
		basic_desert = {"all_inf_rifleman_desert"},
		basic_jungle = {"all_inf_rifleman_jungle"},
		basic_jungle_pilot = {"all_inf_rifleman_jungle"},
		basic_snow = {"all_inf_rifleman_snow"},
		basic_snow_pilot = {"all_inf_rifleman_snow"},
		basic_urban = {"all_inf_rifleman_urban"},
		basic_urban_pilot = {"all_inf_rifleman_urban"},
		fleet = {"all_inf_rifleman_fleet"},
		fleet_pilot = {"all_inf_rifleman_fleet"},
		fleet_urban = {"all_inf_rifleman_urban"},
		fleet_urban_pilot = {"all_inf_rifleman_urban"},
	},
	
	assault = {
		basic = {"all_inf_rocketeer", "all_inf_engineer"},
		basic_snow = {"all_inf_rocketeer", "all_inf_rifleman_snow"},
		basic_snow_pilot = {"all_inf_rocketeer", "all_inf_rifleman_snow"},
		--basic_urban = "all_inf_assault_urban", -- no urban support
		--basic_urban_pilot = "all_inf_assault_urban",
		fleet = {"all_inf_rocketeer_fleet"},
		fleet_pilot = {"all_inf_rocketeer_fleet"},
		fleet_urban = {"all_inf_rocketeer_fleet"},
		fleet_urban_pilot = {"all_inf_rocketeer_fleet"},
	},
	
	sniper = {
		basic = {"all_inf_sniper"},
		basic_jungle = {"all_inf_sniper_jungle"},
		basic_jungle_pilot = {"all_inf_sniper_jungle"},
		basic_snow = {"all_inf_sniper_snow"},
		basic_snow_pilot = {"all_inf_sniper_snow"},
		fleet = {"all_inf_sniper_fleet"},
		fleet_pilot = {"all_inf_sniper_fleet"},
		fleet_urban = {"all_inf_sniper_fleet"},
		fleet_urban_pilot = {"all_inf_sniper_fleet"},
	},
	
	engineer = {
		basic = {"all_inf_engineer", "all_inf_officer"},
		basic_jungle_pilot = {"all_inf_engineer", "all_inf_pilot"},
		basic_snow_pilot = {"all_inf_engineer", "all_inf_pilot"},
		basic_urban_pilot = {"all_inf_engineer", "all_inf_pilot"},
		fleet_pilot = {"all_inf_engineer", "all_inf_pilot"},
		fleet_urban_pilot = {"all_inf_engineer", "all_inf_pilot"},
	},
	
	officer = {
		basic = {"all_inf_officer", "all_inf_rocketeer"},
		basic_snow = {"all_inf_officer", "all_inf_rocketeer_snow"},
		basic_snow_pilot = {"all_inf_officer", "all_inf_rocketeer_snow"},
	},
	
	special = {
		basic = {"all_inf_wookiee"},
	},
	
	pilot = {
		basic = {"all_inf_pilot"},
	},
	
	marine = {
		basic = {"all_inf_marine"},
	},
}
function all_config.getStockUnitConfigs() return tableUtils.copyTable(STOCK_UNIT_CONFIGS) end


-- import function
function get_all_config()
	return all_config
end
