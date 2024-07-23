--[[
	Battlefront Mission Helper
	Module name: table_utils
	Description: Utility functions for tables
	Author: ToothpasteMain
	Version: v1.0
	Date: 2024-07-22
	Dependencies:
	Notes:
--]]
local table_utils = {
	name = "table_utils",
	version = 1.0,
}


---------------------------------------------------------------------------
-- FUNCTION:    table_utils.combineTables
-- PURPOSE:     Combines table of keys and table of values into pairs
-- INPUT:		k, v
-- OUTPUT:		t
-- NOTES:
---------------------------------------------------------------------------
function table_utils.combineTables(k, v)
	local t = {}
	for i in k do
		t[k[i]] = v[i]
	end
	return t
end


---------------------------------------------------------------------------
-- FUNCTION:    table_utils.elementOrTable
-- PURPOSE:     Given a key then return value of table, else return table
-- INPUT:		t, k
-- OUTPUT:		v or t
-- NOTES:
---------------------------------------------------------------------------
function table_utils.elementOrTable(t, k)
	if k then
		return t[k]
	else
		return t
	end
end


---------------------------------------------------------------------------
-- FUNCTION:    table_utils.appendTable
-- PURPOSE:     Append one table to another
-- INPUT:		t1, t2
-- OUTPUT:		t1
-- NOTES:		Appends t2 to t1
---------------------------------------------------------------------------
function table_utils.appendTable(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end


---------------------------------------------------------------------------
-- FUNCTION:    table_utils.isValueInTable
-- PURPOSE:     Check if a value is in table
-- INPUT:		t, k
-- OUTPUT:		boolean
-- NOTES:		Say you have a table of keys, a table of key-value pairs,
--				and you want to filter the key-value pairs by a table of
--				keys.
---------------------------------------------------------------------------
function table_utils.isValueInTable(t, k)
	for _, v in ipairs(t) do
		if k == v then
			return true
		end
	end
	return false
end


-- import function
function get_table_utils()
	return table_utils
end
