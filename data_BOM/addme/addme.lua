--Search through the missionlist to find a map that matches mapName,
--then insert the new flags into said entry.
--Use this when you know the map already exists, but this content patch is just
--adding new gamemodes (otherwise you should just add whole new entries to the missionlist)
function AddNewGameModes(missionList, mapName, newFlags)
	for i, mission in missionList do
		if mission.mapluafile == mapName then
			for flag, value in pairs(newFlags) do
				mission[flag] = value
			end
		end
	end
end

--insert totally new maps here:
local sp_n = 0
local mp_n = 0
sp_n = table.getn(sp_missionselect_listbox_contents)

sp_missionselect_listbox_contents[sp_n+1] = { isModLevel = 1, mapluafile = "BOM%s_%s", era_g = 1, era_c = 1, mode_con_g = 1, mode_con_c  = 1,}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]

-- associate this mission name with the current downloadable content directory
-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
-- first arg: mapluafile from above
-- second arg: mission script name
-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x)

-- cor
AddDownloadableContent("cor1","cor1c_c",4)
AddDownloadableContent("cor1","cor1c_con",4)
AddDownloadableContent("cor1","cor1c_ctf",4)
AddDownloadableContent("cor1","cor1g_con",4)

-- dag
AddDownloadableContent("dag1","dag1c_con",4)
AddDownloadableContent("dag1","dag1c_ctf",4)
AddDownloadableContent("dag1","dag1g_con",4)

-- dea
AddDownloadableContent("dea1","dea1c_con",4)
AddDownloadableContent("dea1","dea1c_1flag",4)
AddDownloadableContent("dea1","dea1g_con",4)

-- end
AddDownloadableContent("end1","end1g_con",4)

-- fel
AddDownloadableContent("fel1","fel1c_c",4)
AddDownloadableContent("fel1","fel1c_con",4)
AddDownloadableContent("fel1","fel1c_1flag",4)
AddDownloadableContent("fel1","fel1g_con",4)

-- geo
--AddDownloadableContent("geo1","geo1c_xl",4)
AddDownloadableContent("geo1","geo1c_c",4)
AddDownloadableContent("geo1","geo1c_con",4)
--AddDownloadableContent("geo1","geo1c_conxl",4)
AddDownloadableContent("geo1","geo1c_ctf",4)

-- hot
AddDownloadableContent("hot1","hot1g_con",4)

-- kam
AddDownloadableContent("kam1","kam1c_con",4)
AddDownloadableContent("kam1","kam1c_1flag",4)
AddDownloadableContent("kam1","kam1g_con",4)

-- kas
AddDownloadableContent("kas2","kas2c_c",4)
AddDownloadableContent("kas2","kas2c_hunt",4)
AddDownloadableContent("kas2","kas2c_con",4)
AddDownloadableContent("kas2","kas2c_ctf",4)
AddDownloadableContent("kas2","kas2g_con",4)

-- mus
AddDownloadableContent("mus1","mus1c_con",4)
AddDownloadableContent("mus1","mus1c_ctf",4)
AddDownloadableContent("mus1","mus1g_con",4)

-- myg
AddDownloadableContent("myg1","myg1c_c",4)
AddDownloadableContent("myg1","myg1c_con",4)
AddDownloadableContent("myg1","myg1c_ctf",4)
AddDownloadableContent("myg1","myg1g_con",4)
AddDownloadableContent("myg1","myg1g_ctf",4)

-- nab
AddDownloadableContent("nab2","nab2c_hunt",4)
AddDownloadableContent("nab2","nab2c_con",4)
AddDownloadableContent("nab2","nab2c_ctf",4)
AddDownloadableContent("nab2","nab2g_con",4)

-- pol
AddDownloadableContent("pol1","pol1c_con",4)
AddDownloadableContent("pol1","pol1c_ctf",4)
AddDownloadableContent("pol1","pol1g_con",4)

-- spa3 (kas)
AddDownloadableContent("spa3c","spa3c_ass",4)
AddDownloadableContent("spa3c","spa3c_1flag",4)

-- spa6 (myg)
AddDownloadableContent("spa6c","spa6c_cmn",4)
AddDownloadableContent("spa6c","spa6c_ass",4)
AddDownloadableContent("spa6c","spa6c_1flag",4)

-- spa7 (fel)
AddDownloadableContent("spa7c","spa7c_cmn",4)
AddDownloadableContent("spa7c","spa7c_ass",4)
AddDownloadableContent("spa7c","spa7c_1flag",4)

-- tan
AddDownloadableContent("tan1","tan1c_con",4)
AddDownloadableContent("tan1","tan1c_1flag",4)
AddDownloadableContent("tan1","tan1g_con",4)

-- tat2
AddDownloadableContent("tat2","tat2c_con",4)
--AddDownloadableContent("tat2","tat2c_ctf",4)
AddDownloadableContent("tat2","tat2g_con",4)

-- tat3
AddDownloadableContent("tat3","tat3c_con",4)
AddDownloadableContent("tat3","tat3c_1flag",4)
AddDownloadableContent("tat3","tat3g_con",4)

-- uta
AddDownloadableContent("uta1","uta1c_c",4)
AddDownloadableContent("uta1","uta1c_con",4)
AddDownloadableContent("uta1","uta1c_1flag",4)
AddDownloadableContent("uta1","uta1g_con",4)

-- yav
AddDownloadableContent("yav1","yav1c_con",4)
AddDownloadableContent("yav1","yav1c_1flag",4)
AddDownloadableContent("yav1","yav1g_con",4)

-- all done
newEntry = nil
n = nil

-- Now load our core.lvl into the shell to add our localize keys
ReadDataFile("..\\..\\addon\\BOM\\data\\_LVL_PC\\core.lvl")
