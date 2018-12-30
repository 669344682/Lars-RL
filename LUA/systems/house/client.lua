----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

for i = 2, 4 do
	setInteriorFurnitureEnabled(i, false)
end

local FONT			= dxCreateFont("files/fonts/harabara.ttf", 12)
local renderTarget	= dxCreateRenderTarget(sx, sy, true)
addEventHandler("onClientRender", root, function()
	dxSetRenderTarget(renderTarget, true)
	for _, pickup in ipairs(getElementsByType("pickup", resourceRoot, true)) do
		if (getElementModel(pickup) == 1272 or getElementModel(pickup) == 1273) then
			if (type(getElementData(pickup, "data")) == "table") then
				local x, y, z		= getElementPosition(pickup)
				local wx, wy, wz 	= getScreenFromWorldPosition(x, y, z+0.5, 0.6)
				local cx, cy, cz	= getCameraMatrix()
				if (isLineOfSightClear(cx, cy, cz, x, y, z, true, true, false, true, false, false, false, pickup)) then
					local dist		= getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)
					if (dist >= 1 and dist <= 20) then
						if (wx) then
							
							local DATA		= getElementData(pickup, "data")
							local owner		= DATA["owner"]
							local text		= ""
							
							if (owner == "none") then
								text = "Steht zum Verkauf!\nPreis: "..setDotsInNumber(DATA["price"]).." $\nMindestspielzeit: "..DATA["mintime"].." Std."
							else
								local state = "Verschlossen"
								if (tostring(DATA["locked"])=="0") then state = "nicht Verschlossen" end
								
								text = "Gehört: "..owner.."\n"..state.."\n"
								local miete		= tonumber(DATA["miete"])
								if (miete > 0) then
									text = text.."Miete: "..miete.." $"
								else
									text = text.."Nicht zu vermieten"
								end
							end
							text = text.."\nHausnummer: "..DATA["ID"]
							dxDrawText(text, wx, wy, wx, wy, tocolor(255, 255, 255, 255), 1, FONT, "center", "center", false, false)
						end
						
					end
				end
			end
		end
	end
	dxSetRenderTarget()
	dxDrawImage(0, 0, sx, sy, renderTarget)
end)



local function showHouseGUI_out(data, myHouse, myFlat)
	if (type(data) ~= "table") then return end	
	
	local window = dxWindow:new("Haus", nil, nil, 336, 265)
	
	dxImage:new(210, 9, 118, 99, "files/images/house/house.png", window)
	dxText:new(18, 15, 995, 417, "Hausnummer: "..data["ID"], window, "left", 1, nil, nil, false)
	local owner = data["owner"]
	if (owner == "none") then owner = "Niemand" end
	dxText:new(18, 35, 995, 417, "Besitzer: "..owner, window, "left", 1, nil, nil, false)
	dxText:new(18, 55, 995, 417, "Preis: "..setDotsInNumber(data["price"]).." $", window, "left", 1, nil, nil, false)
	dxText:new(18, 75, 995, 417, "Mindestspielzeit: "..data["mintime"].." Std.", window, "left", 1, nil, nil, false)
	local miete = "-"
	if (tonumber(data["miete"]) > 0) then miete = data["miete"].." $" end
	dxText:new(18, 95, 995, 417, "Mietpreis: "..miete, window, "left", 1, nil, nil, false)
	
	if not (getElementData(localPlayer, "curHouseInt")) or (getElementData(localPlayer, "curHouseInt") == 0) then
		dxButton:new(18, 126, 146, 35, "Betreten", window, function() triggerServerEvent("House:In", localPlayer) window:close() end)
	else
		dxButton:new(18, 126, 146, 35, "Verlassen", window, function() triggerServerEvent("House:Out", localPlayer) window:close() end)
	end	
	
	

	local btn = nil
	local function lockHouse()
		triggerServerEvent("House:Lock", localPlayer, data["ID"])
		
		if btn:getText() == "Aufschließen" then
			btn:setText("Abschließen")
		elseif btn:getText() == "Abschließen" then
			btn:setText("Aufschließen")
		end
	end
	local state = "Aufschließen"
	if (tostring(data["locked"])=="0") then
		state = "Abschließen"
	end
	
	btn = dxButton:new(172, 126, 146, 35, state, window, lockHouse)
	
	
	if (not myHouse) then btn:deactivate() end
	
	local fix1 = "Kaufen"
	local fix2 = "Buy"
	if (myHouse) then
		fix1 = "Verkaufen"
		fix2 = "Sell"
	end
	local btn = dxButton:new(172, 170, 146, 35, fix1, window, function() triggerServerEvent("House:"..fix2, localPlayer, data["ID"]) window:close() end)
	if (data["owner"] ~= "none" and myHouse == false) then btn:deactivate() end
	
	local fix1 = "Ein"
	local fix2 = "Rent"
	if (myFlat) then
		fix1 = "Aus"
		fix2 = "Unrent"
	end
	local btn = dxButton:new(18, 170, 146, 35, fix1.."mieten", window, function() triggerServerEvent("House:"..fix2, localPlayer, data["ID"]) window:close() end)
end
addEvent("showHouseGUI_out", true)
addEventHandler("showHouseGUI_out", root, showHouseGUI_out)


local function showHouseGUI_in(pickup, myHouse, myFlat)
	local data = getElementData(pickup, "data")
	if (type(data) ~= "table") then return end
	
	local window = dxWindow:new("Hausmenü", nil, nil,  370, 403)
	local tabBg, btn1, btn2 = nil, nil, nil, nil
	local tabElements = {}
	local curTab = 0
	
	local function changeTab(what, force)
		if (curTab == what and not force) then return end
		data = getElementData(pickup, "data")
		for k,v in pairs(tabElements) do
			v:delete()
			tabElements[k] = nil
		end
		
		btn1:setImage("/files/images/dxgui/tab.png")
		btn2:setImage("/files/images/dxgui/tab.png")
		
		local function inOut(bool)
			local sum = tonumber(tabElements['edit']:getText())
			if (sum ~= nil and sum > 0) then
				triggerServerEvent("housePayInOut", localPlayer, data["ID"], bool, tonumber(sum))
				setTimer(function()
					changeTab(1, true)
				end, 250, 1)
			else
				notificationShow("error", "Bitte gib eine gültige Summe ein.")
			end
		end
		local function setRent()
			local sum = tonumber(tabElements['edit3']:getText())
			if (sum ~= nil and sum >= 0) then
				triggerServerEvent("House:SetRent", localPlayer, data["ID"], tonumber(sum))
				setTimer(function()
					changeTab(2, true)
				end, 250, 1)
			else
				notificationShow("error", "Bitte gib eine gültige Summe ein.")
			end
		end
		local function kickMieter()
			local i, row	= tabElements['dxg']:getSelected()
			if (i and row) then
				triggerServerEvent("House:KickMieter", localPlayer, data["ID"], row[1])
				setTimer(function()
					changeTab(2, true)
				end, 250, 1)
			end
		end
		local function giveKey()
			local name = tabElements['edit2']:getText()
			triggerServerEvent("House:AddFreeMieter", localPlayer, data["ID"], name)
			setTimer(function()
				changeTab(2, true)
			end, 250, 1)
		end
		
		
		
		local miete = "-"
		if (tonumber(data["miete"]) > 0) then miete = setDotsInNumber(data["miete"]).." $" end
		local owner = data["owner"]
		if (owner == "none") then owner = "Niemand" end
			
		if (what == 1) then
			btn1:setImage("/files/images/dxgui/tab-hover.png")
			tabElements['owner']	= dxText:new(30, 55, 15, 10, "Besitzer: "..owner, window, "left", 1, nil, nil, false)
			tabElements['rentText']	= dxText:new(30, 75, 15, 10, "Mietpreis: "..miete, window, "left", 1, nil, nil, false)
			tabElements['kasse']	= dxText:new(30, 95, 15, 10, "Kasse: "..setDotsInNumber(data["kasse"]).." $", window, "left", 1, nil, nil, false)
			
			tabElements['icon']		= dxImage:new(210, 50, 108, 89, "files/images/house/house.png", window)
			
			tabElements['edit']		= dxEdit:new(30, 170, 313, 40, window)
			tabElements['einz']		= dxButton:new(30, 220, 151, 40, "Einzahlen", window, function() inOut(false); end, nil, 'exo-9', 1)
			tabElements['ausz']		= dxButton:new(191, 220, 151, 40, "Auszahlen", window, function() inOut(true); end, nil, 'exo-9', 1)
			
			tabElements['item']		= dxButton:new(30, 285, 151, 40, "Itemdepot", window, function() window:close() setTimer(function() triggerServerEvent("openVhInventory", localPlayer, localPlayer, pickup) end, 750, 1) end)
			tabElements['furn']		= dxButton:new(191, 285, 151, 40, "Furniture", window, function() window:close() setTimer(function() triggerServerEvent("getElementsInHouseAndPlot", localPlayer, data["ID"]) end, 750, 1) end)

		elseif (what == 2) then
			btn2:setImage("/files/images/dxgui/tab-hover.png")
			tabElements['rentText2']	= dxText:new(30, 55, 15, 10, "Mietpreis: "..miete, window, "left", 1, nil, nil, false)
			--tabElements['rent_deac']	= dxButton:new(190, 57, 152, 25, "Vermietung aktivieren", window, nil)	
			tabElements['edit3']		= dxEdit:new(30, 90, 152, 25, window)
			tabElements['rent_change']	= dxButton:new(190, 90, 152, 25, "Mietpreis setzen", window, function() setRent() end)		

			tabElements['edit2']		= dxEdit:new(30, 125, 152, 25, window)
			tabElements['key']			= dxButton:new(190, 125, 152, 25, "Schlüssel geben", window, function() giveKey() end)		
			
			tabElements['dxg']			= dxGrid:new(29, 165, 313, 130, window, nil)
			tabElements['dxg']:addColumn({{"Name",70},{"Miete",30}})
			
			for name, price in pairs(fromJSON(data["mieter"])) do
				tabElements['dxg']:addItem({name, price.." $"})
			end
			
			tabElements['remove']		= dxButton:new(60, 308, 250, 25, "Mieter kündigen", window, function() kickMieter() end)			
		end
		
		curTab = what
	end
	
	btn1			= dxImage:new(10, 9, 175, 25, "/files/images/dxgui/tab-hover.png", window, nil, function() changeTab(1); end)
	local text1		= dxText:new(10, 13, 175, 15, "Dashboard", window, "center", 1, 'exo-bold-10', nil, false)
	btn2			= dxImage:new(185, 9, 175, 25, "/files/images/dxgui/tab.png", window, nil, function() changeTab(2); end)
	local text2		= dxText:new(185, 13, 175, 15, "Verwaltung", window, "center", 1, 'exo-bold-10', nil, false)
	local tabBg		= dxImage:new(7, 35, 356, 316, "/files/images/dxgui/tabbg.png", window, nil)

	changeTab(1)
end
addEvent("showHouseGUI_in", true)
addEventHandler("showHouseGUI_in", root, showHouseGUI_in)



function receiveElementsInHouseAndPlot(objects)
	local window	= nil
	local selected	= nil
	local render = function()
		if (selected) then
			renderGridlines(selected)
		end
	end
	
	local oldDim	= getElementDimension(localPlayer)
	local oldInt	= getElementInterior(localPlayer)
	
	local grid		= nil
	local select	= function()
		local i, row	= grid:getSelected()
		if (isElement(objects[i])) then
			local x, y, z	= getElementPosition(objects[i])
			local int		= getElementInterior(objects[i])
			local dim		= getElementDimension(objects[i])
			
			setCameraInterior(int)
			setElementDimension(localPlayer, dim)
			
			local f = 4
			if (int==0) then f = 15 end
			setCameraMatrix(x, y, z+f, x, y, z)
			
			selected		= objects[i]
		end
	end
	local remove	= function()
		local i, row	= grid:getSelected()
		triggerServerEvent("pickupObject", localPlayer, localPlayer, objects[i])
	end
	closeIt = function()
		selected = nil
		removeEventHandler("onClientRender", root, render)
		
		setElementDimension(localPlayer, oldDim)
		setElementInterior(localPlayer, oldInt)
		setCameraInterior(oldInt)
		setCameraTarget(localPlayer, localPlayer)
		setElementFrozen(localPlayer, false)
	end
	
	window = dxWindow:new("Furniture", screenX-(245+20), (screenY/2)-160, 245, 320, nil, nil, nil, nil, nil, true, closeIt)
	dxText:new(12, 8, 217, 21, "Doppelklick um Objekt in das\nInventar zu legen.", window, "left", 1, 'exo-9', nil, false)
	
	grid = dxGrid:new(12, 50, 220, 220, window, select, remove)
	grid:addColumn({{"Name", 0}})
	
	
	for i, ele in ipairs(objects) do
		grid:addItem({engineGetModelNameFromID(getElementModel(ele))})
	end
	
	addEventHandler("onClientRender", root, render)
	setElementFrozen(localPlayer, true)
end
addEvent("receiveElementsInHouseAndPlot", true)
addEventHandler("receiveElementsInHouseAndPlot", root, receiveElementsInHouseAndPlot)



addCommandHandler("newhouse", function(cmd, price, mintime, int)
	if (price and mintime and int) then
		
		local price		= tonumber(price)
		local mintime	= tonumber(mintime)
		local int		= tonumber(int)
		
		if (price >= 10000 and mintime >= 15 and int ~= nil) then
			
			local pX, pY, pZ = getElementPosition(localPlayer)
			setCameraMatrix(pX, pY, pZ+100, pX, pY, pZ)
			setElementRotation(getCamera(), 270, 0, 90)
			showCursor(true)
			
			outputChatBox("4 Grundstücksecken durch klicken makieren.", 255, 50, 0)
			outputChatBox("Rechtsklick = Reset, Leertaste = Beenden, Enter = Bestätigen, Pfeiltasten = Kamera Bewegen, Bild-Auf/-Ab = Zoom", 255, 50, 0)
			
			local x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			local positions			= {}
			local CLOSE				= function()end
			local col				= nil
			
			local x = 1
			local function Render()
				if (x >= 5) then
					dxDrawText("IMMER IM UHRZEIGERSINN MAKIEREN!!!\nOBEN LINKS->OBEN RECHTS->UNTEN RECHTS->UNTEN LINKS\nDIE LINIEN DÜRFEN NICHT ÜBER KREUZ SEIN!!1elf!", 200, 200, 0, 0, tocolor(255,0,0), 2, "default-bold", "left", "top", false, false, false, true)
					if (x >= 20) then
						x = 0
					end
					x = x + 1
				else
					x = x + 1
				end
				
				for i = 1, 4 do
					if (type(positions[i]) == "table") then
						local x, y, _, _ = unpack(positions[i])
						dxDrawRectangle(x, y, 15, 15, tocolor(255, 0, 0, 255), true)
						
						if (i >= 2) then
							local x1, y1, _, _ = unpack(positions[1])
							local x2, y2, _, _ = unpack(positions[2])
							dxDrawLine(x1, y1, x2, y2, tocolor(255,0,0))
							
							if (i >= 3) then
								local x3, y3, _, _ = unpack(positions[3])
								dxDrawLine(x2, y2, x3, y3, tocolor(255,0,0))
								
								if (i >= 4) then
									local x4, y4, _, _ = unpack(positions[4])
									dxDrawLine(x3, y3, x4, y4, tocolor(255,0,0))
									dxDrawLine(x4, y4, x1, y1, tocolor(255,0,0))
								end
							end
							
						end
					end
				end
				
			end
			addEventHandler("onClientRender", root, Render)
			
			local function OnKey(btn, press)
				local cX, cY, cZ, cX2, cY2, cZ2	= getCameraMatrix(localPlayer)
				if (press ~= true) then return end
				
				if (btn == "mouse1") then
					
					for i = 1, 4 do
						if (type(positions[i]) ~= "table") then
							local sX, sY = getCursorPosition()
							local sX=sX*screenX
							local sY=sY*screenY
							
							local swX, swY, _	= getWorldFromScreenPosition(sX, sY, (cZ-pZ))
							positions[i] = {sX, sY, swX, swY}
							break
						end
					end
					
					
				elseif (btn == "enter") then
					local radius		= toJSON({positions[1][3], positions[1][4], positions[2][3], positions[2][4], positions[3][3], positions[3][4], positions[4][3], positions[4][4]})
					CLOSE()
					return triggerServerEvent("addNewHouse", localPlayer, price, mintime, int, radius)
					
				else
					--if (press ~= true) then
						if (btn == "mouse2") then
							positions = {}
							destroyElement(col)
						elseif (btn == "space") then
							return CLOSE()
							
							
						elseif (btn == "pgup") then
							cZ = cZ + 2
						elseif (btn == "pgdn") then
							cZ = cZ - 2
							
						elseif (btn == "arrow_u") then
							cX = cX - 2
							cX2 = cX2 - 2
						elseif (btn == "arrow_d") then
							cX = cX + 2
							cX2 = cX2 + 2
						elseif (btn == "arrow_l") then
							cY = cY - 2
							cY2 = cY2 - 2
						elseif (btn == "arrow_r") then
							cY = cY + 2
							cY2 = cY2 + 2
						end
					--end
				end
				if (type(positions[1]) ~= "table") then
					setCameraMatrix(cX, cY, cZ, cX2, cY2, cZ2)
					setElementRotation(getCamera(), 270, 0, 90)
				end
			end
			addEventHandler("onClientKey", root, OnKey)
			
			function CLOSE()
				setCameraTarget(localPlayer)
				showCursor(false)
				removeEventHandler("onClientRender", root, Render)
				removeEventHandler("onClientKey", root, OnKey)
				destroyElement(col)
			end
			
		else
			outputChatBox("Verwende: /newhouse [Preis] [Mind. Spielzeit in Stunden] [Interior (/iraum [1-30])] #2", 255, 155, 0)
		end
		
	else
		outputChatBox("Verwende: /newhouse [Preis] [Mind. Spielzeit in Stunden] [Interior (/iraum [1-30])] #1", 255, 155, 0)
	end
end)