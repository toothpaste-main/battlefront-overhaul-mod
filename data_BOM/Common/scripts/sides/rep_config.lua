--[[
	Battlefront Overhaul Mod
	Module name: rep_config
	Description: Republic configuration data
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-08-08
	Dependencies: table_utils
	Notes:
--]]
local rep_config = {
	name = "rep_config",
	version = 1.0,
}

-- load dependencies
ScriptCB_DoFile("import")
local tableUtils = import("table_utils")


local UNIT_CONFIGS = {
	soldier = {
		basic = "rep_inf_ep3_rifleman",
		basic_shiny = "rep_inf_ep3_rifleman_shiny",
		marine = "rep_inf_ep3_rifleman_marine",
		marine_jungle = "rep_inf_ep3_rifleman_marine",
		marine_pilot = "rep_inf_ep3_rifleman_marine",
		phase_i = "rep_inf_ep2_rifleman",
	},
	
	assault = {
		basic = "rep_inf_ep3_rocketeer",
		basic_shiny = "rep_inf_ep3_rocketeer_shiny",
		marine = "rep_inf_ep3_rocketeer_marine",
		marine_jungle = "rep_inf_ep3_rocketeer_marine",
		marine_pilot = "rep_inf_ep3_rocketeer_marine",
		--phase_i = "rep_inf_ep2_rocketeer", -- no phase i support
	},
	
	sniper = {
		basic = "rep_inf_ep3_sniper",
		basic_jungle = "rep_inf_ep3_sniper_jungle",
		basic_shiny = "rep_inf_ep3_sniper_shiny",
		marine_jungle = "rep_inf_ep3_sniper_jungle",
		phase_i = "rep_inf_ep2_sniper",
	},
	
	engineer = {
		basic = "rep_inf_ep3_engineer",
		basic_shiny = "rep_inf_ep3_engineer_pilot",
		marine_pilot = "rep_inf_ep3_engineer_pilot",
		phase_i = "rep_inf_ep2_engineer",
	},
	
	officer = {
		basic = "rep_inf_ep3_officer_arctrooper",
		marine = "rep_inf_ep3_officer_marine",
		marine_jungle = "rep_inf_ep3_officer_marine",
		marine_pilot = "rep_inf_ep3_officer_marine",
		phase_i = "rep_inf_ep2_officer",
	},
	
	special = {
		basic = "rep_inf_ep3_jettrooper",
		phase_i = "rep_inf_ep2_jettrooper",
	},
	
	pilot = {
		basic = "",
	},
	
	marine = {
		basic = "",
	},
}
function rep_config.getUnitConfigs() return tableUtils.copyTable(UNIT_CONFIGS) end


-- import function
function get_rep_config()
	return rep_config
end
