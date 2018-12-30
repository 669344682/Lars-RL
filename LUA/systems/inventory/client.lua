----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local categoryImgs		= {
	[1]	= "/files/images/inventory/rucksack.png", -- Unkategorisiert
	[2]	= "/files/images/inventory/food.png", -- Lebensmittel
	[3]	= "/files/images/inventory/portemonnaie.png", -- Geldbörse
	[4]	= "/files/images/inventory/box.png", -- Objekte
}
local categoryNames		= {
	[1]	= "other",
	[2]	= "food",
	[3]	= "moneybag",
	[4]	= "object",
}
local InventoryItems	= {}
local furnitureNames	= {}
local Inventory			= {}
local curCat			= 1
local hasKlicked		= false
local curDragDrop		= nil
local window			= nil
local handelWindow		= nil
local handelGrid		= nil
local handelX			= 0
local handelY			= 0
local handelW			= 270
local handelH			= 386
local hover				= nil
local hoverCount		= 0
local hoverAlpha		= 10

local FONT				= dxCreateFont("files/fonts/exo.ttf", 10)

local linie = tocolor(10,10,10)
local lastLines = 0
local checkSize = false
local function renderInv(startX, startY)
	local lW = 0
	for i = 1, 4 do
		local x, y, w, h = startX+3+(92*(i-1)), startY+2, 90, 60
		local c = tocolor(40, 40, 40)
		if (isCursorOnElement(x, y, w, h) or curCat == i) then
			c = tocolor(55, 55, 55)
			if (hasKlicked and getKeyState("mouse1") and curDragDrop == nil) then
				curCat = i
				checkSize = true
			end
		end
		dxDrawRectangle(x, y, w, h, c)
		
		dxDrawImage(startX+3+(92*(i-1))+20, startY+4+3, 48, 48, categoryImgs[i])
		lW = startX+3+(92*(i-1))+90
	end
	
	
	
	-- Current Cat Items
	local Items = {}
	for i, v in pairs(Inventory) do
		if (type(v) == "table") then
			if (categoryNames[curCat] == v.category and v.itemCount > 0) then
				table.insert(Items, i)
			end
		end
	end
	local cLines = math.ceil((#Items / 6))
	if (cLines < 2) then cLines = 2 end
	
	
	--Kacheln
	local endI	= 0
	for l = 0, (cLines-1) do
		for i = (endI+1), (endI+6) do
			local x, y, w, h = startX+10+(60*(i-1)) - ((360*l)), startY+72+(59*l), 52, 52
			local c = tocolor(70, 70, 70)
			if (isCursorOnElement(x, y, w, h)) then
				c = tocolor(85, 85, 85)
			end
			dxDrawRectangle(x, y, w, h, c)
			
			endI = i
		end
	end
	
	
	-- Linien
	for i = 1, 3 do
		dxDrawLine(startX+(92*i)+1, startY, startX+(92*i)+1, startY+64, linie, 2)
	end
	dxDrawLine(startX+1, startY, startX+1, startY+63, linie, 2)
	dxDrawLine(startX, startY, lW+1, startY, linie, 2)
	
	dxDrawLine(lW+1, startY, lW+1, startY+63, linie, 2)
	dxDrawLine(startX, startY+63, lW, startY+63, linie, 2)
		
	
	-- Item imgs, zuletzt rendern
	local drawItem = function(i)
		local v = Items[i]
		local item = Inventory[v]
		
		local cLine = math.ceil(i/6)
		
		local x, y, w, h = startX+10+(60*(i-1)) - ((360*(cLine-1))), startY+72+(59*(cLine-1)), 52, 52
		
		if (isCursorOnElement(x, y, w, h)) then
			hoverCount = hoverCount + 1
			hover = v
			
			if (hasKlicked and getKeyState("mouse1") and curDragDrop == nil) then
				curDragDrop = i
			end
		else
			if (v == hover) then
				hover = nil
				hoverCount = 0
			end
		end
		
		local _x, _y = x, y
		if (curDragDrop == i) then
			cx, cy = getCursorPosition()
			_x, _y = cx*screenX-26, cy*screenY-26
		end
		
		dxDrawImage(_x, _y, w, h, item.image)
		if (curDragDrop ~= i) then
			dxDrawText("x"..item.itemCount, x, y, x+w, y+h, tocolor(255, 255, 255), 0.95, FONT, "right", "bottom")
		end
	end
	for i, v in ipairs(Items) do
		if (i ~= curDragDrop) then
			drawItem(i)
		end
	end
	if (curDragDrop ~= nil) then
		drawItem(curDragDrop)
	end
	
	
	if (curDragDrop ~= nil) then
		local item									= Inventory[(Items[curDragDrop])]
		local pX, pY, pZ							= getElementPosition(localPlayer)
		local cX, cY, cwX, cwY, cwZ					= getCursorPosition()
		local cX, cY, cZ							= getCameraMatrix(localPlayer)
		local hit, hX, hY, hZ, hitElement, nX, nY, nZ, material, lightning, piece, worldModelID, worldModelPos, worldModelRot, worldLODModelID = processLineOfSight(cX, cY, cZ, cwX, cwY, cwZ, true, true, true, true, true, true, false, false, nil, true, true)
		
		local x, y, z = 0, 0, 0
		if (hX and hY and hZ) then
			x, y, z = hX, hY, hZ
		elseif (nX and nY and nZ) then
			x, y, z = nX, nY, nZ
		else
			x, y, z = cwX, cwY, cwZ
		end
		_z = getGroundPosition(x, y, z)
		if (not _z or tonumber(_z) < 1) then
			_z = getGroundPosition(x, y, z)
			if (_z and tonumber(_z) >= 1) then
				z = _z
			end
		end
		z = z+1
		if (getDistanceBetweenPoints3D(pX, pY, pZ, x, y, z) < 20) then
			
			local wW, wH		= unpack(window:getSize())
			local dropTarget	= nil
			local dropPlayer	= nil
			local kofferraum	= false
			
			if (isCursorOnElement(startX, startY, wW, wH)) then
				--inventar
				
			elseif (hit and hitElement and isElement(hitElement) and getElementType(hitElement) == "player") then
				dropTarget = "handel"
				dropPlayer = hitElement
				
			elseif (hit and hitElement and isElement(hitElement) and getElementType(hitElement) == "vehicle") then
				local txt = "Mit Fahrzeug nutzen"
				if (piece == 2 or piece == 4) then
					kofferraum = true
					txt = "Ablegen in Kofferraum"
				end
				dropTarget = hitElement
				
				local cx, cy	= getCursorPosition()
				cx, cy			= cx*screenX, cy*screenY
				dxDrawImage(cx, cy, 200, 45, "/files/images/inventory/hover.png", 0, 0, 0, tocolor(255,255,255, 255))
				dxDrawText(txt, cx, cy, cx+200, cy+45, tocolor(255,255,255, 255), 1.05, FONT, "center", "center")
				
			elseif (isCursorOnElement(handelX, handelY, handelW, handelH)) then
				dropTarget = "handel"
				
			else
				dropTarget = "world"
			end
			
			if (dropTarget ~= nil) then
				
				if ((item.delete == true) or (item.delete == false and dropTarget ~= "world")) then
					if (not getKeyState("mouse1")) then
						if (dropTarget == "handel") then
							if (item.delete or item.consume) then
								if (not handelWindow) then
									openHandelSender(dropPlayer)
								end
								if (handelWindow) then
									addItemToHandel(item)
								end
							else
								notificationShow("error", "Dieses Item kannst Du nicht in ein anderes Inventar ablegen.")
							end
						else
							triggerServerEvent("dropInvItem", localPlayer, dropTarget, item.itemID, x, y, z, kofferraum)
						end
					end
				end
			end
			
		end
	end
	
	if (tonumber(hover) ~= nil and curDragDrop == nil and hoverCount > 20) then
		if (hoverAlpha < 255) then
			hoverAlpha = hoverAlpha + 8.5
		end
		local txt	= Inventory[hover].itemName
		local len	= string.len(txt)
		local w, h	= 125, 35
		if (len > 30) then
			w, h = 280, 54
		elseif (len > 26) then
			w, h = 260, 52
		elseif (len > 23) then
			w, h = 230, 50
		elseif (len > 18) then
			w, h = 200, 45
		elseif (len > 14) then
			w, h = 180, 42
		elseif (len > 10) then
			w, h = 150, 40
		end
		
		local cx, cy	= getCursorPosition()
		cx, cy			= cx*screenX, cy*screenY
		dxDrawImage(cx, cy, w, h, "/files/images/inventory/hover.png", 0, 0, 0, tocolor(255,255,255, hoverAlpha))
		dxDrawText(txt, cx, cy, cx+w, cy+h, tocolor(255,255,255, hoverAlpha), 1.05, FONT, "center", "center")
		--hover = nil
	else
		hoverAlpha = 0
	end
	
	
	hasKlicked = false
	if (not getKeyState("mouse1")) then
		curDragDrop = nil
	end
	
	if (checkSize or lastLines ~= cLines) then
		local w, h = 374, 234
		if (cLines > 2) then
			h = h + ((cLines-2)*60)
		end
		window:resize(w, h, true)
	end
	lastLines = cLines
end

addEventHandler("onClientClick", root, function(button, state)
	if (button == "left" and state == "down") then
		hasKlicked = true
	end
end)

local function refreshInventory(inv)
	Inventory		= {}
	for k, v in pairs(inv) do
		if (type(InventoryItems[k]) == "table" or (tonumber(k) ~= nil and tonumber(k) > 600)) then
			if (tonumber(v) > 0) then
				local name, category, image, move, delete, drop = nil, nil, nil, nil, nil, nil
				if (type(InventoryItems[k]) == "table") then
					name		= InventoryItems[k].title
					category	= InventoryItems[k].category
					image		= InventoryItems[k].image
					move		= InventoryItems[k].move
					delete		= InventoryItems[k].delete
					drop		= InventoryItems[k].drop
					consume		= InventoryItems[k].consume
					
				elseif (tonumber(k) ~= nil and tonumber(k) > 600) then
					--name		= "Platzierbares Objekt ("..k..")"
					local model = engineGetModelNameFromID(k)
					if (not model) then
						model = "Platzierbares Objekt"
					end
					name		= model.." ("..k..")"
					if (furnitureNames[tonumber(k)]) then
						name = furnitureNames[tonumber(k)]
					end
					category	= categoryNames[4]
					image		= categoryImgs[4]
					move		= true
					delete		= true
					drop		= true
					consume		= false
				end
				
				if (name ~= nil) then
					table.insert(Inventory, {
						itemID		= k,
						itemName	= name,
						itemCount	= v,
						category	= category,
						image		= image,
						move		= move,
						delete		= delete,
						drop		= drop,
						consume		= consume,
					})
				end
			end
		end
	end
end
addEvent("refreshInventory", true)
addEventHandler("refreshInventory", root, refreshInventory)

local function useItem(btn, state)
	if (btn == "mouse2" and state == true) then
		if (hover) then
			local item = Inventory[hover]
			if (type(item) == "table") then
				if ((item.delete == true) or (item.delete == false)) then
					triggerServerEvent("dropInvItem", localPlayer, localPlayer, item.itemID, 0, 0, 0, false)
				end
			end
		end
	end
end




local function openInventar(inv, invItems, fNames, handel)
	InventoryItems	= invItems
	furnitureNames	= fNames
	curDragDrop		= nil
	hasKlicked		= false
	checkSize		= true
	
	refreshInventory(inv)
	
		
	setTimer(function()
		window = dxWindow:new("Inventar", nil, nil, 374, 234, nil, nil, nil, nil, nil, true, function() removeEventHandler("onClientKey", root, useItem) if (handelWindow) then setTimer(function() handelWindow:close(true)handelWindow = nil end, 150, 1) end end, renderInv)
	end, 75, 1)
	
	addEventHandler("onClientKey", root, useItem)
end
addEvent("openInventar", true)
addEventHandler("openInventar", root, openInventar)


addEvent("closeInventory", true)
addEventHandler("closeInventory", root, function()
	if (window) then
		window:close()
	end
	
	removeEventHandler("onClientKey", root, useItem)
end)








--/// Vehicle & Hosue Inventory ///--
local VhInventory = {}

local moveToVhBtn, moveToMyBtn, itmCount, vhInvGrid, myInvGrid = nil, nil, nil, nil, nil


local function refreshVhInventory(myInv, vhInv)
	local function addFromTo(from, grid)
		local ret = {}
		grid:removeAllItems()
		
		for k, v in pairs(from) do
			if (type(InventoryItems[k]) == "table" or (tonumber(k) ~= nil and tonumber(k) > 600)) then
				if (tonumber(v) > 0) then
					local name, category, image, move, delete, drop = nil, nil, nil, nil, nil, nil
					if (type(InventoryItems[k]) == "table") then
						name		= InventoryItems[k].title
						category	= InventoryItems[k].category
						image		= InventoryItems[k].image
						move		= InventoryItems[k].move
						delete		= InventoryItems[k].delete
						drop		= InventoryItems[k].drop
						consume		= InventoryItems[k].consume
						
					elseif (tonumber(k) ~= nil and tonumber(k) > 600) then
						--name		= "Platzierbares Objekt ("..k..")"
						local model = engineGetModelNameFromID(k)
						if (not model) then
							model = "Platzierbares Objekt"
						end
						name		= model.." ("..k..")"
						if (furnitureNames[tonumber(k)]) then
							name = furnitureNames[tonumber(k)]
						end
						category	= categoryNames[4]
						image		= categoryImgs[4]
						move		= true
						delete		= true
						drop		= true
						consume		= false
					end
					
					if (name ~= nil) then
						table.insert(ret, {
							itemID		= k,
							itemName	= name,
							itemCount	= v,
							category	= category,
							image		= image,
							move		= move,
							delete		= delete,
							drop		= drop,
							consume		= consume,
						})
						grid:addItem({name, v})
					end
				end
			end
		end
		
		return ret
	end
	
	Inventory	= addFromTo(myInv, myInvGrid)
	VhInventory = addFromTo(vhInv, vhInvGrid)
end
addEvent("refreshVhInventory", true)
addEventHandler("refreshVhInventory", root, refreshVhInventory)

local function VehicleHouseInventory(myInv, vhInv, invItems, fNames, targetElement)
	InventoryItems	= invItems
	furnitureNames	= fNames
	
	local txt = "Haus-Inventar"
	if (getElementType(targetElement) == "vehicle") then
		txt = "Kofferraum"
	end
	
	local window	= dxWindow:new(txt, nil, nil, 600, 300, nil, nil, nil, nil, nil, true, function() end, nil, true)
	
	local myInvTxt	= dxText:new(10, 5, 225, 10, "Mein Inventar:", window, "left", 1, 'exo-10', nil, false)
	myInvGrid		= dxGrid:new(10, 25, 225, 220, window, selectCB)
	myInvGrid:addColumn({{"Item",80}, {"Anzahl",20}})
	
	local vhInvTxt	= dxText:new(365, 5, 225, 10, txt..":", window, "left", 1, 'exo-10', nil, false)
	vhInvGrid		= dxGrid:new(365, 25, 225, 220, window, selectCB)
	vhInvGrid:addColumn({{"Item",80}, {"Anzahl",20}})
	
	local itmCountTxt	= dxText:new(245, 120, 110, 15, "Anzahl", window, "left", 1, 'exo-9', nil, false)
	itmCount			= dxEdit:new(245, 135, 110, 15, window)
	itmCount:setText('1')
	
	
	local function moveToVh()
		local i, row	= myInvGrid:getSelected()
		local count		= tonumber(itmCount:getText())
		if (count ~= nil and count > 0 and i > 0) then
			if (type(Inventory[i]) == "table") then
				if (Inventory[i].itemCount >= count) then
					if (Inventory[i].move == true) then
						vhInvGrid:setSelected(-1)
						myInvGrid:setSelected(-1)
						itmCount:setText('1')
						triggerServerEvent("moveItemToVh", localPlayer, Inventory[i].itemID, count, targetElement)
					else
						notificationShow("error", "Dieses Item kannst Du nicht in ein anderes Inventar ablegen.")
					end
				else
					notificationShow("error", "Bitte korrigiere die Item-Anzahl.")
				end
			end
		end
	end
	local function moveToMy()
		local i, row	= vhInvGrid:getSelected()
		local count		= tonumber(itmCount:getText())
		if (count ~= nil and count > 0 and i > 0) then
			if (type(VhInventory[i]) == "table") then
				if (VhInventory[i].itemCount >= count) then
					if (VhInventory[i].move == true) then
						vhInvGrid:setSelected(-1)
						myInvGrid:setSelected(-1)
						itmCount:setText('1')
						triggerServerEvent("moveItemToMy", localPlayer, VhInventory[i].itemID, count, targetElement)
					else
						notificationShow("error", "Dieses Item kannst Du nicht in ein anderes Inventar ablegen.")
					end
				else
					notificationShow("error", "Bitte korrigiere die Item-Anzahl.")
				end
			end
		end
	end
	
	moveToVhBtn	= dxButton:new(245, 175, 110, 30, ">>>", window, moveToVh, nil, 'exo-bold-10', 1)
	moveToMyBtn	= dxButton:new(245, 215, 110, 30, "<<<", window, moveToMy, nil, 'exo-bold-10', 1)
	
	--[[for i, item in ipairs(items) do
		grid:addItem({item.title, item.price.." $"})
	end
	grid:setSelected(1)
	selectCB()]]
	
	refreshVhInventory(myInv, vhInv)
end
addEvent("VehicleHouseInventory", true)
addEventHandler("VehicleHouseInventory", root, VehicleHouseInventory)



















--/// HANDEL ///--
function openHandelSender(target)	
	handelX = (screenX/2)+(374/2)+20;
	handelY = (screenY/2)-(400/2);
	
	handelWindow	= dxWindow:new("Handel mit "..getPlayerName(target), handelX, handelY, handelW, handelH, nil, nil, nil, nil, nil, true, function() removeEventHandler("onClientKey", root, useItem) window:close(true) handelWindow = nil end, nil, true)
	local infoTxt	= dxText:new(10, 5, 250, 30, "Ziehe die Items aus deinem Inventar\nin dieses Fenster, um sie der\nListe hinzuzufügen.\nDoppelklick zum entfernen.", handelWindow, "center", 1, 'exo-10', nil, false)
	handelGrid		= dxGrid:new(10, 75, 250, 200, handelWindow, nil, rmItemFromHandel)
	handelGrid:addColumn({{"Item",75}, {"Anzahl",25}})
	
	
	local prodCtit	= dxText:new(10, 285, 100, 10, "Preis", handelWindow, "left", 1, 'exo-9', nil, false)
	local price		= dxEdit:new(10, 300, 100, 30, handelWindow)
	
	local send = function()
		if (target and isElement(target)) then
			local txt = tonumber(price:getText())
			if (txt ~= nil and txt >= 0) then
				triggerServerEvent("handelStart", localPlayer, target, handelGrid:getAllItems(), txt)
				handelWindow:close()
				
				notificationShow("success", "Dein Angebot wurde gesendet.")
				
			else
				notificationShow("error", "Gib eine gültige Summe an.")
			end
		else
			notificationShow("error", "Der Spieler ist offline.")
			handelWindow:close()
		end
	end
	local buyBtn	= dxButton:new(120, 300, 140, 31, "Anbieten", handelWindow, send, nil, nil, 1)
end
addEvent("openHandelSender", true)
addEventHandler("openHandelSender", root, openHandelSender)

function addItemToHandel(item)
	local items = handelGrid:getAllItems();
	
	local exists	= nil
	local oldCount	= 0
	for i, arr in ipairs(items) do
		if (arr[1] == item.itemName) then
			exists = i
			oldCount = tonumber(arr[2])
			break
		end
	end
	
	if (exists ~= nil) then
		handelGrid.m_Items.rows[exists][2] = oldCount+1
	else
		handelGrid:addItem({item.itemName, "1", item.itemID})
	end
end
function rmItemFromHandel()
	local sel, _ = handelGrid:getSelected()
	
	local count = tonumber(handelGrid.m_Items.rows[sel][2])
	if (count ~= nil and count > 1) then
		handelGrid.m_Items.rows[sel][2] = count-1
	else
		handelGrid:removeItem(sel)
	end
end


function openHandelReceiver(tbl)
	local handelRcvWindow	= nil
	local AcceptOrDecline 	= function(bool)
		triggerServerEvent("answerHandel", localPlayer, bool)
		handelRcvWindow:close()
	end
	
	handelRcvWindow			= dxWindow:new("Handel", nil, nil, handelW, handelH, nil, nil, nil, nil, nil, true, nil)
	local infoTxt			= dxText:new(10, 5, 250, 20, tbl.from.." bietet dir\nfolgende Items an:", handelRcvWindow, "center", 1, 'exo-10', nil, false)
	
	local grid				= dxGrid:new(10, 45, 250, 230, handelRcvWindow)
	grid:addColumn({{"Item",75}, {"Anzahl",25}})
	
	for k, v in pairs(tbl.items) do
		grid:addItem({v[1], v[2]})
	end
	
	
	local prodCtit			= dxText:new(10, 280, 240, 10, "Preis: "..setDotsInNumber(tbl.price).." $", handelRcvWindow, "left", 1, 'exo-10', nil, false)
	
	local acceptBtn			= dxButton:new(10, 300, 120, 31, "Annehmen", handelRcvWindow, function() AcceptOrDecline(true) end, nil, nil, 1)
	local declineBtn		= dxButton:new(140, 300, 120, 31, "Ablehnen", handelRcvWindow, function() AcceptOrDecline(false) end, nil, nil, 1)
end
addEvent("handeReceiveGui", true)
addEventHandler("handeReceiveGui", root, openHandelReceiver)