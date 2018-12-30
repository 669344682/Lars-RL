----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------


local collis = {}
local function toggleGhostModeClient(element, bool)
	
	collis[element] = bool
	local allPlayers = getElementsByType("player", root, false)
	for _, pl in pairs(allPlayers) do
		if ((type(collis[pl]) ~= "boolean" or collis[pl] == true) or (collis[pl] == false and bool == false)) then
			setElementCollidableWith(element, pl, bool)
		end
	end
	
	local allVehicles = getElementsByType("vehicle", root, false)
	for _, pl in pairs(allVehicles) do
		if ((type(collis[pl]) ~= "boolean" or collis[pl] == true) or (collis[pl] == false and bool == false)) then
			setElementCollidableWith(element, pl, bool)
		end
	end
end
addEvent("toggleGhostModeClient", true)
addEventHandler("toggleGhostModeClient", root, toggleGhostModeClient)