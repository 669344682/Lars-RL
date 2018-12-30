----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local function Supermarket()
	local items		= settings.systems.shops.supermarket.menues
	
	local window	= dxWindow:new("24/7 Supermarkt", nil, nil, 500, 390, nil, nil, nil, nil, nil, true, function() triggerServerEvent("toggleGhostMode", localPlayer, localPlayer, false) end)
	local infoTxt	= dxText:new(10, 5, 480, 20, "Willkommen im 24/7 Supermarkt!\nHier findest Du alles was Du brauchst.", window, "center", 1, 'exo-10', nil, false)
	
	local grid, image, prodTit, prodTxt, prodCount = nil, nil, nil, nil, nil
	local selectCB	= function()
		prodCount:setText('1')
		local i, row = grid:getSelected()
		prodTit:setText(row[1])
		prodTxt:setText(items[i].text)
		image:setImage("files/images/supermarket/"..items[i].image)
	end
	grid			= dxGrid:new(10, 45, 250, 240, window, selectCB)
	grid:addColumn({{"Produkt",85}, {"Preis",15}})
	
	image			= dxImage:new(270, 45, 220, 165, "files/images/map.png", window)
	
	prodTit			= dxText:new(270, 220, 220, 20, "", window, "left", 1, 'exo-bold-10', nil, false)
	prodTxt			= dxText:new(270, 238, 220, 20, "", window, "left", 1, 'exo-9', nil, false)
	
	
	local prodCtit	= dxText:new(10, 290, 110, 10, "Anzahl", window, "left", 1, 'exo-9', nil, false)
	prodCount		= dxEdit:new(10, 305, 110, 15, window)
	prodCount:setText('1')
	
	local buyIt = function()
		local i, row	= grid:getSelected()
		local count		= prodCount:getText()
		if (tonumber(count) ~= nil and tonumber(count) > 0) then
			if (items[i].onlyOnce == true) then
				prodCount:setText('1')
				count = 1
			end
			triggerServerEvent("supermarketBuy", localPlayer, i, tonumber(count))
		end
	end
	local buyBtn	= dxButton:new(270, 295, 220, 40, "Kaufen", window, buyIt, nil, nil, 1)
	
	
	for i, item in ipairs(items) do
		grid:addItem({item.title, item.price.." $"})
	end
	grid:setSelected(1)
	selectCB()
end
addEvent("supermarketHello", true)
addEventHandler("supermarketHello", root, Supermarket)