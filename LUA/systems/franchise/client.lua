----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function showFranchiseGUI(name, owner, price, mintime, visitors, earnings, cID, sID)
	local window = dxWindow:new(name, nil, nil, 316, 225)
	
	dxImage:new(190, 9, 118, 99, "files/images/franchise/franchise.png", window)
	if (owner == "none") then owner = "Niemand" end
	dxText:new(18, 15, 995, 15, "Besitzer: "..owner, window, "left", 1, nil, nil, false)
	dxText:new(18, 35, 995, 15, "Preis: "..setDotsInNumber(price).." $", window, "left", 1, nil, nil, false)
	dxText:new(18, 55, 995, 15, "Mindestspielzeit: "..mintime.." Std.", window, "left", 1, nil, nil, false)
	dxText:new(18, 75, 995, 15, "Kunden / Tag: ø"..visitors, window, "left", 1, nil, nil, false)
	dxText:new(18, 95, 995, 15, "Einnahmen / Tag: ø"..earnings.." $", window, "left", 1, nil, nil, false)
	
	local txt	= "Kaufen"
	local ev	= "Franchise:buyShop"
	if (owner == getPlayerName(localPlayer)) then
		txt = "Verkaufen"
		ev	= "Franchise:sellShop"
	end
	local btn = dxButton:new(18, 130, 280, 35, txt, window, function() triggerServerEvent(ev, localPlayer, cID, sID) window:close() end)
	
	
	-- anders gehts nich o_O
	if (tostring(owner) == "none") then
	else
		if (tostring(owner) ~= getPlayerName(localPlayer)) then
			btn:deactivate()
		end
	end
end
addEvent("showFranchiseGUI", true)
addEventHandler("showFranchiseGUI", root, showFranchiseGUI)