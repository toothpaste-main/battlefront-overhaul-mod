--[[
	Battlefront Overhaul Mod
	Module name: cis_config
	Description: CIS configuration data
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-08
	Dependencies: table_utils
	Notes:
--]]
local cis_config = {
	name = "cis_config",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")


local UNIT_CONFIGS = {
	soldier = {
		basic = "cis_inf_bdroid",
	},
	
	assault = {
		basic = "cis_inf_rocketeer",
	},
	
	sniper = {
		basic = "cis_inf_sniper",
	},
	
	engineer = {
		basic = "cis_inf_engineer",
	},
	
	officer = {
		basic = "cis_inf_sbdroid",
	},
	
	special = {
		basic = "cis_inf_droideka",
	},
	
	pilot = {
		basic = "",
	},
	
	marine = {
		basic = "",
	},
}
function cis_config.getUnitConfigs() return tableUtils.copyTable(UNIT_CONFIGS) end


-- import function
function get_cis_config()
	return cis_config
end
